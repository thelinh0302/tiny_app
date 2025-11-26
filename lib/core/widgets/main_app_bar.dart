import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/notification_button.dart';

/// Reusable main AppBar used across feature pages.
///
/// Features:
/// - Optional back button that uses Navigator.maybePop()
/// - Centered localized title
/// - Right-side notification button with customizable handler
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final bool showBackButton;
  final VoidCallback? onNotificationPressed;

  const MainAppBar({
    super.key,
    required this.titleKey,
    this.showBackButton = true,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBackButton
              ? BackButton(
                color: AppColors.white,
                onPressed: () => Navigator.of(context).maybePop(),
              )
              : null,
      centerTitle: true,
      title: Text(
        titleKey.tr(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.mainGreen,
      elevation: 0,
      actions: [NotificationButton(onPressed: onNotificationPressed)],
    );
  }
}
