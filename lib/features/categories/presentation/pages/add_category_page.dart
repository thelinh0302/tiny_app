import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_icons_bloc.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_icons_grid.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedThumbnail;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryIconsBloc>(
      // Get BLoC from Modular DI and immediately trigger load
      create:
          (_) =>
              Modular.get<CategoryIconsBloc>()
                ..add(const CategoryIconsRequested()),
      child: Builder(
        builder: (context) {
          return MainLayout(
            appBar: const MainAppBar(titleKey: 'add_category'),
            enableContentScroll: true,
            topHeightRatio: 0.2,
            topChild: null,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.verticalSpaceMedium,
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'category.name.label'.tr(),
                    hintText: 'category.name.hint'.tr(),
                  ),
                  AppSpacing.verticalSpaceLarge,
                  Text(
                    'category.icon.label'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalSpaceSmall,
                  CategoryIconsGrid(
                    selectedThumbnail: _selectedThumbnail,
                    onThumbnailSelected: (thumbnail) {
                      setState(() {
                        _selectedThumbnail = thumbnail;
                      });
                    },
                  ),
                  AppSpacing.verticalSpaceMedium,
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: PrimaryButton(
                        text: 'save'.tr(),
                        onPressed: () {
                          final name = _nameController.text.trim();

                          if (name.isEmpty || _selectedThumbnail == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter name & select icon',
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.of(context).pop(<String, dynamic>{
                            'name': name,
                            'thumbnail': _selectedThumbnail,
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
