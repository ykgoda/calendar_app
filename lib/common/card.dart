import 'package:flutter/material.dart';
import '../type/type.dart';
import '../common/text.dart';
import '../common/date_contents.dart';
import 'date_contents_modal.dart';

class CommonCard extends StatelessWidget {
  const CommonCard(
      {super.key,
      this.date,
      this.height,
      required this.text,
      this.color = Colors.black});

  final Date? date;
  final double? height;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    onTap() {
      showDialog(
          context: context,
          builder: (_) {
            return Dialog.fullscreen(
              child: CommonDateContentsModal(
                date: date!,
              ),
            );
          });
    }

    return Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
        ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 6, horizontal: 4)),
          ),
          onPressed: date != null ? onTap : () {},
          child: Column(children: [
            // Row(
            //   children: [
            CommonText(
              text,
              fontSize: 16,
              color: color,
            ),
            // Padding(
            //     padding: const EdgeInsets.only(left: 2),
            //     child: CommonText(
            //       day,
            //       fontSize: 8,
            //       color: date.day == 6
            //           ? Colors.blue
            //           : date.day == 7
            //               ? Colors.red
            //               : Colors.black,
            //     ))
            //   ],
            // ),
            if (date != null && date!.contents != null)
              CommonDateContents(
                contents: date!.contents!,
                date: date!,
              ),
          ]),
        ));
  }
}
