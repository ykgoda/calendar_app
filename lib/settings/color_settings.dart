import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../common/text.dart';
import '../main.dart';

class ColorSettings extends ConsumerWidget {
  const ColorSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsList(sections: [
      SettingsSection(tiles: <SettingsTile>[
        SettingsTile(
          title: const CommonText('文字カラー設定'),
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('文字カラーを選択'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: ref.watch(colorProvider),
                    onColorChanged: (color) {
                      ref.watch(colorProvider.notifier).updateColor(color);
                    },
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const CommonText(
                        'Done',
                        color: Colors.black,
                      ))
                ],
              ),
            );
          },
          trailing: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ref.watch(colorProvider),
            ),
          ),
        ),
        SettingsTile(
          title: const CommonText('テーマカラー設定'),
          onPressed: (context) {
            //  showDialog(
            //   context: context,
            //   builder: (_) {
            //     return const Dialog(
            //         child: Padding(
            //       padding: EdgeInsetsDirectional.symmetric(
            //           vertical: verticalPadding * 2,
            //           horizontal: horizontalPadding),
            //       child: ThemeColorDialog(),
            //     ));
            //   });
          },
          trailing: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ref.watch(themeColorProvider),
            ),
          ),
        )
      ])
    ]);
  }
}

// class ColorSettings extends ConsumerStatefulWidget {
//   const ColorSettings({super.key});

//   @override
//   ColorSettingsState createState() => ColorSettingsState();
// }

// class ColorSettingsState extends ConsumerState<ColorSettings> {
//   @override
//   Widget build(BuildContext context) {
//     return SettingItem(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('文字カラーを選択'),
//             content: SingleChildScrollView(
//               child: BlockPicker(
//                 pickerColor: ref.watch(colorProvider),
//                 onColorChanged: (color) {
//                   ref.watch(colorProvider.notifier).updateColor(color);
//                 },
//               ),
//             ),
//             actions: <Widget>[
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const CommonText(
//                     'Done',
//                     color: Colors.black,
//                   ))
//             ],
//           ),
//         );
//       },
//       titleItem: const CommonText('文字カラー設定'),
//       contentItem: Container(
//         width: 16,
//         height: 16,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: ref.watch(colorProvider),
//         ),
//       ),
//     );
//   }
// }
