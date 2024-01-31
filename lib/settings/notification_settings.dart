import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';

import '../common/make_new_content.dart';
import '../common/text.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  NotificationSettingsState createState() => NotificationSettingsState();
}

class NotificationSettingsState extends State<NotificationSettings> {
  bool _value = false;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      onTap: () {},
      titleItem: const CommonText('通知設定'),
      contentItem: CupertinoSwitch(
        value: _value,
        onChanged: (value) async {
//           await flutterLocalNotificationsPlugin
//                       .resolvePlatformSpecificImplementation<
//                           IOSFlutterLocalNotificationsPlugin>()
//                       ?.requestPermissions(
//                           alert: true, badge: true, sound: true);

// var initializationSettingsIOS = DarwinInitializationSettings(
//                     requestAlertPermission: true,
//                     requestBadgePermission: true,
//                     requestSoundPermission: false,
//                     onDidReceiveLocalNotification:
//                         (id, title, body, payload) async {
//                       // your call back to the UI
//                     },
//                   );
//                   var initializationSettings =
//                       InitializationSettings(iOS: initializationSettingsIOS);

//                       flutterLocalNotificationsPlugin.initialize(
//                       initializationSettings, onDidReceiveNotificationResponse:
//                           (NotificationResponse res) {
//                     debugPrint('payload:${res.payload}');
//                   });

//                   var iosChannelSpecifics = const DarwinNotificationDetails();

//                    await flutterLocalNotificationsPlugin.show(
//                     0,
//                     'title',
//                     'body',
//                     NotificationDetails(iOS: iosChannelSpecifics),
//                   );

          AppSettings.openAppSettings(type: AppSettingsType.security);
          setState(() {
            _value = value;
          });
        },
      ),
    );
  }
}
