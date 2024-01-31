import 'package:calendar_app/common/const.dart';
import 'package:calendar_app/common/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum SettingsType { toggleSwitch, color }

class SettingsContent extends ConsumerStatefulWidget {
  const SettingsContent(
      {super.key,
      required this.title,
      required this.type,
      required this.settings});

  final String title;
  final SettingsType type;
  final List<Widget> settings;

  @override
  SettingsContentState createState() => SettingsContentState();
}

class SettingsContentState extends ConsumerState<SettingsContent> {
  final bool _value = false;
  Color? selectedColor;
  String selectedColorToString = '';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonText(widget.title),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding * 2,
              horizontal: horizontalPadding,
            ),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Material(
                //       child: IconButton(
                //           alignment: Alignment.centerLeft,
                //           iconSize: 32.0,
                //           onPressed: () => Navigator.pop(context),
                //           icon: const Icon(Icons.arrow_back)),
                //     ),
                //     CommonText(widget.title),
                //   ],
                // ),
                for (final setting in widget.settings) setting,
                // if (widget.type == SettingsType.toggleSwitch)
                //   SettingItem(
                //     titleItem: const CommonText('通知設定'),
                //     contentItem: CupertinoSwitch(
                //       value: _value,
                //       onChanged: (value) {
                //         setState(() {
                //           _value = value;
                //         });
                //       },
                //     ),
                //   ),
                // if (widget.type == SettingsType.color)
                //   SettingItem(
                //       titleItem: const CommonText('カラー設定'),
                //       contentItem: TextButton(
                //         child: Container(
                //           width: 16,
                //           height: 16,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: ref.watch(colorProvider),
                //           ),
                //         ),
                //         onPressed: () {
                //           showDialog(
                //             context: context,
                //             builder: (context) => AlertDialog(
                //               title: const Text('カラーを選択'),
                //               content: SingleChildScrollView(
                //                 child: BlockPicker(
                //                   pickerColor: ref.watch(colorProvider),
                //                   onColorChanged: (color) {
                //                     ref
                //                         .watch(colorProvider.notifier)
                //                         .updateColor(color);

                //                     // setState(() {
                //                     //   selectedColor = color;
                //                     // });
                //                   },
                //                 ),
                //               ),
                //               actions: <Widget>[
                //                 ElevatedButton(
                //                     onPressed: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: const CommonText('Done'))
                //               ],
                //             ),
                //           );
                //         },
                //       )),
                // TextButton(
                //     onPressed: () async {
                //       print('---heee');
                //       print('---1');
                // await flutterLocalNotificationsPlugin
                //           .resolvePlatformSpecificImplementation<
                //               IOSFlutterLocalNotificationsPlugin>()
                //           ?.requestPermissions(
                //               alert: true, badge: true, sound: true);
                //       print('---2');

                //       var initializationSettingsIOS = DarwinInitializationSettings(
                //         requestAlertPermission: true,
                //         requestBadgePermission: true,
                //         requestSoundPermission: false,
                //         onDidReceiveLocalNotification:
                //             (id, title, body, payload) async {
                //           // your call back to the UI
                //         },
                //       );
                //       var initializationSettings =
                //           InitializationSettings(iOS: initializationSettingsIOS);

                //       flutterLocalNotificationsPlugin.initialize(
                //           initializationSettings, onDidReceiveNotificationResponse:
                //               (NotificationResponse res) {
                //         debugPrint('payload:${res.payload}');
                //       });
                //       var iosChannelSpecifics = const DarwinNotificationDetails();
                //       print('---here');

                //       await flutterLocalNotificationsPlugin.show(
                //         0,
                //         'title',
                //         'body',
                //         NotificationDetails(iOS: iosChannelSpecifics),
                //       );
                //     },
                //     child: const Text('eiuro'))
              ],
            )));
  }
}
