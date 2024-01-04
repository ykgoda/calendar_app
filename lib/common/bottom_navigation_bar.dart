import 'package:calendar_app/common/common.dart';
import 'package:flutter/material.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  const CommonBottomNavigationBar({key}) : super(key: key);

  @override
  _CommonBottomNavigationBarState createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext cotnext) {
    return BottomNavigationBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '月'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: '週'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_view_day), label: '日')
    ]);
  }
}
