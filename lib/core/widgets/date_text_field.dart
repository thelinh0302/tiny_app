import 'package:flutter/material.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';

typedef DateFormatter = String Function(DateTime date);

class DateTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateChanged;

  final String? Function(String?)? validator;
  final String? errorText;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry contentPadding;
  final TextInputAction? textInputAction;

  /// Optional custom formatter for displaying the selected date as text.
  /// Defaults to yyyy-MM-dd.
  final DateFormatter? dateFormatter;

  const DateTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
    this.validator,
    this.errorText,
    this.borderColor = AppColors.borderButtonPrimary,
    this.backgroundColor = AppColors.white,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    this.textInputAction,
    this.dateFormatter,
  });

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  late final TextEditingController _internalController;
  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();

    // Initialize from provided initialDate or existing controller text (if parseable).
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _controller.text = _formatDate(widget.initialDate!);
    } else if (_controller.text.isNotEmpty) {
      final parsed = _tryParseDate(_controller.text);
      if (parsed != null) {
        _selectedDate = parsed;
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final fmt = widget.dateFormatter ?? _defaultFormatter;
    return fmt(date);
  }

  String _defaultFormatter(DateTime d) {
    // yyyy-MM-dd without intl dependency
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  DateTime? _tryParseDate(String text) {
    // Try to parse yyyy-MM-dd (common case)
    try {
      final parts = text.split('-');
      if (parts.length == 3) {
        final y = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final d = int.parse(parts[2]);
        return DateTime(y, m, d);
      }
    } catch (_) {
      // ignore parse errors
    }
    // Fallback: try DateTime.parse for ISO formats
    try {
      return DateTime.parse(text);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final first = widget.firstDate ?? DateTime(1900, 1, 1);
    final last = widget.lastDate ?? DateTime.now();
    DateTime init = widget.initialDate ?? _selectedDate ?? DateTime.now();
    if (init.isBefore(first)) init = first;
    if (init.isAfter(last)) init = last;

    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: first,
      lastDate: last,
      helpText: widget.labelText,
      builder: (ctx, child) {
        // You can customize theme here if needed to better match app theme.
        return child ?? const SizedBox.shrink();
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
      });
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      // Ensure calendar icon is shown; if a custom suffix is provided, use it.
      suffixIcon:
          widget.suffixIcon ??
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: _pickDate,
            tooltip: 'Pick date',
          ),
      readOnly: true,
      onTap: _pickDate,
      keyboardType: TextInputType.datetime,
      validator: widget.validator,
      borderColor: widget.borderColor,
      backgroundColor: widget.backgroundColor,
      textInputAction: widget.textInputAction,
      errorText: widget.errorText,
      contentPadding: widget.contentPadding,
    );
  }
}

/*
Usage example:

DateTextField(
  labelText: 'Date of Birth',
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  onDateChanged: (date) {
    // handle selected date
  },
);

// If you want a custom format:
DateTextField(
  labelText: 'Start Date',
  dateFormatter: (d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}',
);
*/
