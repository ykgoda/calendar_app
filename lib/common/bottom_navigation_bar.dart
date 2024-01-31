import 'package:calendar_app/common/common.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonBottomNavigationBar extends ConsumerStatefulWidget {
  const CommonBottomNavigationBar({key}) : super(key: key);

  @override
  CommonBottomNavigationBarState createState() =>
      CommonBottomNavigationBarState();
}

class CommonBottomNavigationBarState
    extends ConsumerState<CommonBottomNavigationBar> {
  // int selectedIndex = 1;
  // int selectedIndex = 1;

  // @override
  // void initState() {
  //   super.initState();

  //   selectedIndex = ref.watch(indexProvider);
  // }

  void onTap(int index) {
    if (index == 0) {
      ref.watch(yearProvider.notifier).state = DateTime.now().year;
      ref.watch(monthProvider.notifier).state = DateTime.now().month;
      ref.watch(dateProvider.notifier).state = DateTime.now().day;
    } else {
      ref.watch(indexProvider.notifier).state = index;
      // setState(() {
      //   selectedIndex = index;
      // });
    }
  }

  @override
  Widget build(BuildContext cotnext) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.shortcut), label: '今日'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'カレンダー'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定')
      ],
      currentIndex: ref.watch(indexProvider),
      onTap: onTap,
    );
  }
}
