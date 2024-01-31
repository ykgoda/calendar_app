import 'package:calendar_app/common/text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width = double.infinity,
      this.height = 48,
      this.color = Colors.blue,
      this.fontColor = Colors.white});

  final String text;
  final Function() onTap;
  final double width;
  final double height;
  final Color color;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            foregroundColor: color,
          ),
          child: CommonText(
            text,
            color: Colors.white,
          ),
        ));
  }
}
