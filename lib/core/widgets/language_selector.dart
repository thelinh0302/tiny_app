import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:finly_app/core/widgets/app_alert.dart';

/// Language selector widget for switching between languages
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'language.select'.tr(),
      onSelected: (Locale locale) {
        context.setLocale(locale);
        AppAlert.success(context, 'language.changed'.tr());
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<Locale>>[
            PopupMenuItem<Locale>(
              value: const Locale('en'),
              child: Row(
                children: [
                  const Text('🇬🇧  '),
                  Text('language.english'.tr()),
                  if (context.locale == const Locale('en'))
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('vi'),
              child: Row(
                children: [
                  const Text('🇻🇳  '),
                  Text('language.vietnamese'.tr()),
                  if (context.locale == const Locale('vi'))
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
          ],
    );
  }
}
