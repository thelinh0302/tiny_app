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
import 'package:finly_app/core/widgets/custom_dropdown_field.dart';
import 'package:finly_app/features/categories/presentation/bloc/add_category_bloc.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedThumbnail;
  String? _selectedType;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryIconsBloc>(
          create:
              (_) =>
                  Modular.get<CategoryIconsBloc>()
                    ..add(const CategoryIconsRequested()),
        ),
        BlocProvider<AddCategoryBloc>(
          create: (_) => Modular.get<AddCategoryBloc>(),
        ),
      ],
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
                  BlocListener<AddCategoryBloc, AddCategoryState>(
                    listenWhen: (p, c) => p.status != c.status,
                    listener: (context, state) {
                      if (state.status == AddCategoryStatus.submissionSuccess) {
                        Navigator.of(context).pop();
                      } else if (state.status ==
                              AddCategoryStatus.submissionFailure &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage!)),
                        );
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                  BlocBuilder<AddCategoryBloc, AddCategoryState>(
                    buildWhen: (p, c) => p.name != c.name,
                    builder: (context, state) {
                      String? error;
                      if (state.name.displayError != null) {
                        error = 'category.validation.nameRequired'.tr();
                      }
                      return CustomTextField(
                        controller: _nameController,
                        labelText: 'category.name.label'.tr(),
                        hintText: 'category.name.hint'.tr(),
                        errorText: error,
                        onChanged:
                            (v) => BlocProvider.of<AddCategoryBloc>(
                              context,
                            ).add(AddCategoryNameChanged(v)),
                      );
                    },
                  ),
                  AppSpacing.verticalSpaceLarge,
                  BlocBuilder<AddCategoryBloc, AddCategoryState>(
                    buildWhen: (p, c) => p.type != c.type,
                    builder: (context, state) {
                      String? error;
                      if (state.type.displayError != null) {
                        error = 'category.validation.typeRequired'.tr();
                      }
                      return CustomDropdownField<String>(
                        labelText: 'category.type.label'.tr(),
                        value: _selectedType,
                        placeholderText: 'category.type.placeholder'.tr(),
                        items: [
                          DropdownMenuItem(
                            value: 'income',
                            child: Text('category.type.income'.tr()),
                          ),
                          DropdownMenuItem(
                            value: 'expense',
                            child: Text('category.type.expense'.tr()),
                          ),
                        ],
                        errorText: error,
                        onChanged: (v) {
                          setState(() => _selectedType = v);
                          BlocProvider.of<AddCategoryBloc>(
                            context,
                          ).add(AddCategoryTypeChanged(v));
                        },
                      );
                    },
                  ),
                  AppSpacing.verticalSpaceLarge,
                  Text(
                    'category.icon.label'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalSpaceSmall,
                  BlocBuilder<AddCategoryBloc, AddCategoryState>(
                    buildWhen: (p, c) => p.icon != c.icon,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryIconsGrid(
                            selectedThumbnail: _selectedThumbnail,
                            onThumbnailSelected: (thumbnail) {
                              setState(() {
                                _selectedThumbnail = thumbnail;
                              });
                              BlocProvider.of<AddCategoryBloc>(
                                context,
                              ).add(AddCategoryIconChanged(thumbnail));
                            },
                          ),
                          if (state.icon.displayError != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 6.0,
                                left: 4.0,
                              ),
                              child: Text(
                                'category.validation.iconRequired'.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: AppColors.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  AppSpacing.verticalSpaceMedium,
                  Center(
                    child: BlocBuilder<AddCategoryBloc, AddCategoryState>(
                      builder: (context, state) {
                        final isLoading =
                            state.status ==
                            AddCategoryStatus.submissionInProgress;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: PrimaryButton(
                            text: 'save'.tr(),
                            isLoading: isLoading,
                            onPressed: () {
                              BlocProvider.of<AddCategoryBloc>(
                                context,
                              ).add(const AddCategorySubmitted());
                            },
                          ),
                        );
                      },
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
