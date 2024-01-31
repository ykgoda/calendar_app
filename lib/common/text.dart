import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonText extends ConsumerWidget {
  const CommonText(this.text,
      {super.key,
      this.fontSize = 24,
      this.color,
      this.overflow = TextOverflow.ellipsis});

  final String text;
  final double? fontSize;
  final Color? color;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          decoration: TextDecoration.none,
          color: color ?? ref.watch(colorProvider)),
      overflow: overflow,
    );
  }
}
