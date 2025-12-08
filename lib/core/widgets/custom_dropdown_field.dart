import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// A reusable dropdown form field with Finly styling.
///
/// Usage example:
/// CustomDropdownField<String>(
///   labelText: 'Type',
///   value: selected,
///   items: const [
///     DropdownMenuItem(value: 'income', child: Text('Income')),
///     DropdownMenuItem(value: 'expense', child: Text('Expense')),
///   ],
///   onChanged: (v) => setState(() => selected = v),
/// )
class CustomDropdownField<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final String? errorText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final String? placeholderText;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          hint: placeholderText != null ? Text(placeholderText!) : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.borderButtonPrimary,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.borderButtonPrimary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 2,
              ),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
