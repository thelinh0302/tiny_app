import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';

/// A reusable widget that lets users select an image from their device
/// and shows a 16:9 preview. It reports the picked file and bytes via [onChanged].
class ImagePickerField extends StatefulWidget {
  final String? labelText;
  final XFile? initialFile;
  final Uint8List? initialBytes;
  final void Function(XFile? file, Uint8List? bytes)? onChanged;

  const ImagePickerField({
    super.key,
    this.labelText,
    this.initialFile,
    this.initialBytes,
    this.onChanged,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _file = widget.initialFile;
    _bytes = widget.initialBytes;
  }

  Future<void> _pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _file = picked;
        _bytes = bytes;
      });
      widget.onChanged?.call(_file, _bytes);
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _file = picked;
        _bytes = bytes;
      });
      widget.onChanged?.call(_file, _bytes);
    }
  }

  void _clear() {
    setState(() {
      _file = null;
      _bytes = null;
    });
    widget.onChanged?.call(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.labelText != null) const SizedBox(height: 8),
        ClipRRect(
          borderRadius: AppSpacing.borderRadiusLarge,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: AppColors.white,
              child:
                  (_bytes == null)
                      ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderButtonPrimary,
                          ),
                          borderRadius: AppSpacing.borderRadiusLarge,
                          color: AppColors.borderButtonPrimary.withValues(
                            alpha: 0.05,
                          ),
                        ),
                        child: const Center(child: Text('No image selected')),
                      )
                      : Image.memory(_bytes!, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Gallery',
                onPressed: _pickFromGallery,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryButton(text: 'Camera', onPressed: _pickFromCamera),
            ),
            const SizedBox(width: 8),
            if (_bytes != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkGrey,
                    side: const BorderSide(
                      color: AppColors.borderButtonPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusLarge,
                    ),
                  ),
                  child: const Text('Remove'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
