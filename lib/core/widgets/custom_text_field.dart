import 'package:finly_app/core/constants/app_sizes.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color backgroundColor;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.borderColor = AppColors.borderButtonPrimary,
    this.backgroundColor = AppColors.white,
    this.textInputAction,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.errorText,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? 1 : minLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: backgroundColor,
            contentPadding: contentPadding,
            errorText: errorText,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: BorderSide(color: borderColor, width: 1),
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
          ),
        ),
      ],
    );
  }
}
