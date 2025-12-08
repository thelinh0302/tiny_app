import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';

/// Default seed categories used by pages until hooked to real data.
const List<CategoryData> defaultCategories = <CategoryData>[
  CategoryData(
    title: 'Food',
    iconAsset: AppImages.food,
    backgroundColor: AppColors.mainGreen,
  ),
  CategoryData(
    title: 'Car',
    iconAsset: AppImages.savingsCar,
    backgroundColor: AppColors.mainGreen,
  ),
  CategoryData(
    title: 'Salary',
    iconAsset: AppImages.salary,
    backgroundColor: AppColors.mainGreen,
  ),
];
