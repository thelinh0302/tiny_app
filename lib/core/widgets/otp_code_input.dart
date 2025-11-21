import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:finly_app/core/theme/app_colors.dart';

class OtpCodeInput extends StatefulWidget {
  final int numberOfFields;
  final ValueChanged<String>? onCodeChanged;
  final ValueChanged<String>? onSubmit;

  const OtpCodeInput({
    super.key,
    this.numberOfFields = 6,
    this.onCodeChanged,
    this.onSubmit,
  });

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.numberOfFields,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.numberOfFields, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _notifyCodeChanged() {
    final code = _controllers.map((c) => c.text).join();
    widget.onCodeChanged?.call(code);
    if (code.length == widget.numberOfFields) {
      widget.onSubmit?.call(code);
    }
  }

  void _onFieldChanged(int index, String value) {
    if (value.length > 1) {
      // Keep only the last typed character
      _controllers[index].text = value.substring(value.length - 1);
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
    }

    if (value.isNotEmpty && index < widget.numberOfFields - 1) {
      // Move focus to next field when user types a digit
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // If user deletes, move back to previous field
      _focusNodes[index - 1].requestFocus();
    }

    _notifyCodeChanged();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.darkGrey,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.numberOfFields, (index) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: textStyle,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.darkGrey.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.mainGreen,
                  width: 1.5,
                ),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) => _onFieldChanged(index, value),
          ),
        );
      }),
    );
  }
}
