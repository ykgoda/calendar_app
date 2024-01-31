import 'package:calendar_app/common/text.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar(String text, {super.key, List<Widget>? actions})
      : super(
            title: CommonText(text),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: actions);
  // CommonAppBar({super.key, required this.text});

  // final String text;

  // Widget build(BuildContext context) {
  //   return AppBar(
  //     title: CommonText(text),
  //     backgroundColor: Colors.white,
  //     foregroundColor: Colors.black,
  //   );
  // }
}
