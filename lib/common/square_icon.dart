import 'package:flutter/material.dart';

import 'text.dart';

class SquareIcon extends StatelessWidget {
  const SquareIcon({super.key, required this.color, this.text});

  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return text != null
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              CommonText(
                text!,
                fontSize: 16,
              ),
            ],
          )
        : Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          );
  }
}
