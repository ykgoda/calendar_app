import 'package:app_settings/app_settings.dart';
import 'package:calendar_app/common/text.dart';
import 'package:calendar_app/settings/theme_color_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../page/overboard_page.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends ConsumerState<Settings> {
  final bool _value = false;

  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //       vertical: verticalPadding * 2, horizontal: horizontalPadding),
        // color: Colors.white,
        // child: Column(
        //   children: [
        // child:
        SettingsList(sections: [
      SettingsSection(tiles: <SettingsTile>[
        SettingsTile(
          title: const CommonText('通知設定'),
          onPressed: (context) {
            AppSettings.openAppSettings(type: AppSettingsType.security);
          },
        ),
        SettingsTile(
          title: const CommonText('使い方'),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return OverboardPage();
            }));
          },
        ),
        SettingsTile.navigation(
          title: const CommonText('カラー設定'),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return const ThemeColorSettings();
            }));
          },
        ),
      ])
    ]);
    //   SettingItem(
    //     onTap: () {
    //       Navigator.of(context)
    //           .push(MaterialPageRoute(builder: (context) {
    //         return const SettingsContent(
    //           title: '通知設定',
    //           type: SettingsType.toggleSwitch,
    //           settings: [NotificationSettings()],
    //         );
    //       }));
    //     },
    //     titleItem: const CommonText('通知設定'),
    //   ),
    //   SettingItem(
    //       onTap: () {
    //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //           return OverboardPage();
    //         }));
    //       },
    //       titleItem: const CommonText('使い方')),
    //   SettingItem(
    //     onTap: () {
    //       Navigator.of(context)
    //           .push(MaterialPageRoute(builder: (context) {
    //         return const SettingsContent(
    //           title: 'カラー設定',
    //           type: SettingsType.color,
    //           settings: [ColorSettings(), ThemeColorSettings()],
    //         );
    //       }));
    //     },
    //     titleItem: const CommonText('カラー設定'),
    //     contentItem: const Icon(Icons.arrow_forward_ios),
    //   )
    // ],
    // );
  }
}
