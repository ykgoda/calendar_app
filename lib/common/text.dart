import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText(this.text,
      {super.key, this.fontSize = 24, this.color = Colors.black});

  final String text;
  final double? fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize, decoration: TextDecoration.none, color: color),
    );
  }
}
