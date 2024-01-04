import 'package:calendar_app/common/text.dart';
import 'package:flutter/material.dart';
import '../type/type.dart';
import '../collections/date_content.dart';

const _padding = 8.0;

class CommonDateContentsPage extends StatelessWidget {
  const CommonDateContentsPage({super.key, required this.date});

  final Date date;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          children: [
            Row(
              children: [
                CommonText(date.date.toString()),
                CommonText(date.day.toString())
              ],
            ),
            Column(
              children: [
                for (final content in date.contents!) _Content(content: content)
              ],
            )
          ],
        ));
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.content});

  final DateContent content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Row(
        children: [
          Column(
            children: [
              CommonText(
                  '${content.startTime.hour} : ${content.startTime.minute}'),
              const CommonText('|'),
              CommonText('${content.endTime.hour} : ${content.endTime.minute}'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CommonText(content.content),
          )
        ],
      ),
    );
  }
}
