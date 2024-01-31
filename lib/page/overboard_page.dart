import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

class OverboardPage extends StatelessWidget {
  final pages = [
    PageModel(
      imageAssetPath: 'assets/home_screen.jpeg',
      title: '月ごとにカレンダーを表示できます',
      body: 'シンプルで使いやすいです',
      color: const Color(0xFF0097A7),
      titleColor: Colors.black,
      bodyColor: Colors.black,
    ),
    PageModel(
      imageAssetPath: 'assets/date_content.jpeg',
      title: '日ごとに予定を追加できます',
      body: '一覧で確認できるので分かりやすいです',
      color: const Color(0xFF536DFE),
      titleColor: Colors.black,
      bodyColor: Colors.black,
    ),
    PageModel(
      imageAssetPath: 'assets/color_settings.jpeg',
      title: 'カラーを変更可能',
      body: '自分好みのカレンダーにできます',
      color: const Color(0xFF9B90BC),
      titleColor: Colors.black,
      bodyColor: Colors.black,
    ),
  ];

  OverboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OverBoard(
            pages: pages,
            finishCallback: () {
              Navigator.of(context).pop();
            }));
  }
}
