import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/const.dart';
import '../common/text.dart';
import '../main.dart';

class ThemeColorSettings extends ConsumerWidget {
  const ThemeColorSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const CommonText('テーマカラー設定'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: CupertinoPageScaffold(
            child: CupertinoListSection(
          children: <CupertinoListTile>[
            CupertinoListTile(
              title: const CommonText('ライトブルー'),
              trailing: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColorList[0],
                ),
              ),
              onTap: () {
                ref
                    .watch(themeColorProvider.notifier)
                    .updateThemeColor(themeColorList[0]);
                ref.watch(settingsHandler).updateSettings(index: 0);
                Navigator.of(context).pop();
              },
            ),
            CupertinoListTile(
              title: const CommonText('レッド'),
              trailing: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColorList[1],
                ),
              ),
              onTap: () {
                ref
                    .watch(themeColorProvider.notifier)
                    .updateThemeColor(themeColorList[1]);
                ref.watch(settingsHandler).updateSettings(index: 1);
                Navigator.of(context).pop();
              },
            ),
            CupertinoListTile(
              title: const CommonText('ライトグリーン'),
              trailing: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColorList[2],
                ),
              ),
              onTap: () {
                ref
                    .watch(themeColorProvider.notifier)
                    .updateThemeColor(themeColorList[2]);
                ref.watch(settingsHandler).updateSettings(index: 2);
                Navigator.of(context).pop();
              },
            ),
            CupertinoListTile(
              title: const CommonText('グレー'),
              trailing: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColorList[3],
                ),
              ),
              onTap: () {
                ref.watch(themeColorProvider.notifier).updateThemeColor(
                      themeColorList[3],
                    );
                ref.watch(settingsHandler).updateSettings(index: 3);

                Navigator.of(context).pop();
              },
            ),
          ],
        )));
  }
}

// class ThemeColorSettings extends ConsumerStatefulWidget {
//   const ThemeColorSettings({super.key});

//   @override
//   ThemeColorSettingsState createState() => ThemeColorSettingsState();
// }

// class ThemeColorSettingsState extends ConsumerState<ThemeColorSettings> {
//   @override
//   Widget build(BuildContext context) {
//     return SettingItem(
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (_) {
//               return const Dialog(
//                   child: Padding(
//                 padding: EdgeInsetsDirectional.symmetric(
//                     vertical: verticalPadding * 2,
//                     horizontal: horizontalPadding),
//                 child: ThemeColorDialog(),
//               ));
//             });
//       },
//       titleItem: const CommonText('テーマカラー設定'),
//       contentItem: Container(
//         width: 16,
//         height: 16,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: ref.watch(themeColorProvider),
//         ),
//       ),
//     );
//   }
// }

// class ThemeColorDialog extends ConsumerStatefulWidget {
//   const ThemeColorDialog({super.key});

//   @override
//   ThemeColorDialogState createState() => ThemeColorDialogState();
// }

// class ThemeColorDialogState extends ConsumerState<ThemeColorDialog> {
//   int? selectedIndex;
//   MaterialColor materialColor = Colors.blue;

//   @override
//   Widget build(BuildContext context) {
//     final List<SelectorItem> selectorItemList = [
//       SelectorItem(
//         title: 'レッド',
//         content:
//             const ColorContainer(isMaterial: true, materialColor: Colors.red),
//         index: 0,
//         onSelect: () {
//           setState(() {
//             selectedIndex = 0;
//             materialColor = Colors.red;
//           });
//         },
//         isSelected: selectedIndex == 0,
//       ),
      // SelectorItem(
//         title: 'ライトブルー',
//         content:
//             const ColorContainer(isMaterial: true, materialColor: Colors.blue),
//         index: 1,
//         onSelect: () {
//           setState(() {
//             selectedIndex = 1;
//             materialColor = Colors.blue;
//           });
//         },
//         isSelected: selectedIndex == 1,
//       ),
//       SelectorItem(
//         title: 'グリーン',
//         content:
//             const ColorContainer(isMaterial: true, materialColor: Colors.green),
//         index: 2,
//         onSelect: () {
//           setState(() {
//             selectedIndex = 2;
//             materialColor = Colors.green;
//           });
//         },
//         isSelected: selectedIndex == 2,
//       ),
//       SelectorItem(
//         title: 'ライトブルー',
//         content:
//             const ColorContainer(isMaterial: true, materialColor: Colors.blue),
//         index: 3,
//         onSelect: () {
//           setState(() {
//             selectedIndex = 3;
//             materialColor = Colors.blue;
//           });
//         },
//         isSelected: selectedIndex == 3,
//       ),
//     ];

//     return Column(
//       children: [
//         const CommonText('テーマカラーを選択'),
//         const SizedBox(
//           height: 16,
//         ),
//         Column(
//           children: [
//             for (final item in selectorItemList) ...[
//               item,
//               const SizedBox(
//                 height: 16,
//               )
//             ]
//           ],
//         ),
//         TextButton(
//             onPressed: () {
//               ref
//                   .watch(themeColorProvider.notifier)
//                   .updateThemeColor(materialColor);
//               Navigator.of(context).pop();
//             },
//             child: const CommonText('Done')),
//       ],
//     );
//   }
// }

// class SelectorItem extends StatelessWidget {
//   const SelectorItem(
//       {super.key,
//       required this.title,
//       required this.content,
//       required this.index,
//       required this.onSelect,
//       this.isSelected = false});

//   final String title;
//   final Widget content;
//   final int index;
//   final Function onSelect;
//   final bool isSelected;
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       style: OutlinedButton.styleFrom(
//           side: BorderSide(
//               color: isSelected
//                   ? Colors.black
//                   : const Color.fromRGBO(223, 223, 223, 1))),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//             vertical: verticalPadding, horizontal: horizontalPadding),
//         child:
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           CommonText(
//             title,
//             color: Colors.black,
//           ),
//           content,
//         ]),
//       ),
//       onPressed: () {
//         onSelect();
//       },
//     );
//   }
// }

// class ColorContainer extends StatelessWidget {
//   const ColorContainer(
//       {super.key, this.color, this.isMaterial = false, this.materialColor});

//   final Color? color;
//   final bool? isMaterial;
//   final MaterialColor? materialColor;

//   @override
//   Widget build(BuildContext context) {
//     return color != null
//         ? Container(
//             width: 16,
//             height: 16,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: color,
//             ),
//           )
//         : isMaterial == true && materialColor != null
//             ? Container(
//                 width: 16,
//                 height: 16,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: materialColor,
//                 ),
//               )
//             : const SizedBox.shrink();
//   }
// }
