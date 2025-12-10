import 'package:flutter/material.dart';
import 'package:finly_app/core/widgets/image_picker_field.dart';

class AddExpenseReceiptImageField extends StatelessWidget {
  const AddExpenseReceiptImageField({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImagePickerField(labelText: 'Receipt Image');
  }
}
