import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/models/country.dart';
import 'package:finly_app/core/services/rest_countries_service.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/utils/phone_utils.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';

/// Phone input with country picker (flag + dial code).
///
/// It fetches countries from RestCountries on first build and allows
/// searching by country code or dial code.
class PhoneTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const PhoneTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.errorText,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  final TextEditingController _controller = TextEditingController();
  final RestCountriesService _service = RestCountriesService();

  List<Country> _countries = <Country>[];
  Country? _selected;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final countries = await _service.fetchCountries();
      setState(() {
        _countries = countries;
        // Optionally pick a default like VN (+84) if present
        _selected = countries.firstWhere(
          (c) => c.code == 'VN',
          orElse: () => countries.first,
        );
      });
    } catch (e) {
      // For now just keep list empty on error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLocalChanged(String localPart) {
    // Use dynamic normalization based on the selected country dialing code.
    // This ensures values like local "0399..." with VN (+84) become
    // "+84399..." instead of "+840399...".
    final normalized = PhoneUtils.normalizePhone(
      input: localPart,
      country: _selected,
    );
    widget.onChanged?.call(normalized);
  }

  Future<void> _openCountryPicker() async {
    if (_countries.isEmpty) return;

    final Country? result = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final TextEditingController searchController = TextEditingController();
        List<Country> filtered = List<Country>.from(_countries);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void filter(String query) {
              final q = query.toLowerCase();
              setModalState(() {
                filtered =
                    _countries.where((c) {
                      final code = c.code.toLowerCase();
                      final dial = (c.primaryDialCode ?? '').toLowerCase();
                      return code.contains(q) || dial.contains(q);
                    }).toList();
              });
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Select country',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search by code or dial code',
                      ),
                      onChanged: filter,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          return ListTile(
                            leading: _FlagIcon(country: country),
                            title: Text(country.code),
                            subtitle: Text(country.primaryDialCode ?? ''),
                            onTap: () => Navigator.of(context).pop(country),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _selected = result;
      });

      // Re-emit combined value
      _onLocalChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialCode = _selected?.primaryDialCode ?? '';

    return CustomTextField(
      labelText: widget.labelText,
      hintText: widget.hintText,
      keyboardType: TextInputType.phone,
      errorText: widget.errorText,
      controller: _controller,
      onChanged: _onLocalChanged,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
          onTap: _isLoading ? null : _openCountryPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                _FlagIcon(country: _selected),
              AppSpacing.horizontalSpaceSmall,
              Text(dialCode, style: const TextStyle(fontSize: 14)),
              const Icon(Icons.arrow_drop_down),
              AppSpacing.horizontalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagIcon extends StatelessWidget {
  final Country? country;
  const _FlagIcon({this.country});

  @override
  Widget build(BuildContext context) {
    final url = country?.flagPngUrl;
    if (url == null || url.isEmpty) {
      return const Icon(Icons.flag, size: 20, color: AppColors.darkGrey);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        url,
        width: 24,
        height: 18,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.flag, size: 20, color: AppColors.darkGrey),
      ),
    );
  }
}
