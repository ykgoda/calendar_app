import 'package:calendar_app/common/text.dart';
import 'package:calendar_app/type/type.dart';
import 'package:flutter/material.dart';
import '../collections/date_content.dart';

class CommonDateContents extends StatelessWidget {
  const CommonDateContents(
      {super.key, required this.contents, required this.date});

  final List<DateContent> contents;
  final Date date;

  @override
  Widget build(BuildContext context) {
    final length = contents.length > 5 ? 5 : contents.length;
    return Expanded(
        child: Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        for (int i = 0; i < length; i++) ...[
          DateContentIcon(content: contents[i]),
          const SizedBox(
            height: 4,
          )
        ]
      ],
    ));
    // final slicedContents =
    //     contents.length > 3 ? contents.sublist(0, 3) : contents;
    // return Column(
    //   children: [
    //     for (final content in slicedContents)
    //       SizedBox(
    //         height: 24,
    //         width: double.infinity,
    //         child: CommonDateContent(
    //           content: content,
    //           date: date,
    //         ),
    //       )
    //   ],
    // );
  }
}

class DateContentIcon extends StatelessWidget {
  const DateContentIcon({super.key, required this.content});

  final DateContent content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(1.6),
      ),
    );
  }
}

class CommonDateContent extends StatefulWidget {
  const CommonDateContent(
      {super.key,
      required this.content,
      required this.date,
      this.color = Colors.white});
  final DateContent content;
  final Date date;
  final Color? color;

  @override
  CommonDateContentState createState() => CommonDateContentState();
}

class CommonDateContentState extends State<CommonDateContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: CommonText(
          widget.content.content,
          fontSize: 12,
        ),
      ),
    );
  }
}
