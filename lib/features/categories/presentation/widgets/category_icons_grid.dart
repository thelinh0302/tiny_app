import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_icons_bloc.dart';

/// Grid of category icons driven by [CategoryIconsBloc].
///
/// The parent provides the currently selected thumbnail URL and a callback
/// that will be invoked when the user selects a new icon.
class CategoryIconsGrid extends StatelessWidget {
  const CategoryIconsGrid({
    super.key,
    required this.selectedThumbnail,
    required this.onThumbnailSelected,
  });

  final String? selectedThumbnail;
  final ValueChanged<String> onThumbnailSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryIconsBloc, CategoryIconsState>(
      builder: (context, state) {
        if (state is CategoryIconsLoadInProgress ||
            state is CategoryIconsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoryIconsLoadFailure) {
          return Center(
            child: Text(
              'Failed to load icons',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.errorColor),
            ),
          );
        }

        if (state is CategoryIconsLoadSuccess && state.icons.isEmpty) {
          return Center(
            child: Text(
              'No icons available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        if (state is CategoryIconsLoadSuccess) {
          final icons = state.icons;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.verticalSmall,
              crossAxisSpacing: AppSpacing.horizontalSmall,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              final icon = icons[index];
              final isSelected = selectedThumbnail == icon.thumbnailUrl;

              return GestureDetector(
                onTap: () => onThumbnailSelected(icon.thumbnailUrl),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.mainGreen
                            : AppColors.mainGreen.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.mainGreen : AppColors.white,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: _buildThumbnail(icon.thumbnailUrl),
                ),
              );
            },
          );
        }

        // Fallback (should not normally be reached)
        return const SizedBox.shrink();
      },
    );
  }
}

Widget _buildThumbnail(String url) {
  final lower = url.toLowerCase();
  if (lower.endsWith('.svg')) {
    return SvgPicture.network(url, fit: BoxFit.contain);
  }
  return Image.network(url, fit: BoxFit.contain);
}
