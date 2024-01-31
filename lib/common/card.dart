import 'package:calendar_app/main.dart';
import 'package:calendar_app/page/date_contents_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../type/type.dart';
import '../common/text.dart';
import 'square_icon.dart';

class CommonCard extends ConsumerWidget {
  const CommonCard(
      {super.key,
      this.date,
      this.height,
      required this.text,
      this.color = Colors.black,
      this.backgroundColor = Colors.white,
      this.isToday = false,
      this.isHoliday = false});

  final Date? date;
  final double? height;
  final String text;
  final Color color;
  final Color backgroundColor;
  final bool isToday;
  final bool isHoliday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onTap() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            return DateContentsPage(date: date!);
          },
          settings: RouteSettings(
              name: '${date!.year}-${date!.month}-${date!.date}')));
      // showDialog(
      //     context: context,
      //     builder: (_) {

      //       return Dialog.fullscreen(
      //         child: CommonDateContentsModal(
      //           date: date!,
      //         ),
      //       );
      //     });
    }

    return Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          color: backgroundColor,
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
            isToday
                ? Container(
                    // color: Colors.blue,
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ref.watch(themeColorProvider)),
                    child: CommonText(
                      text,
                      fontSize: 16,
                      color: date != null && date!.day == 6
                          ? Colors.blue
                          : date != null && (date!.day == 7 || date!.isHoliday)
                              ? Colors.red
                              : color,
                    ),
                  )
                : Container(
                    // color: Colors.blue,
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: CommonText(
                      text,
                      fontSize: 16,
                      color: date != null && date!.day == 6
                          ? Colors.blue
                          : date != null && (date!.day == 7 || date!.isHoliday)
                              ? Colors.red
                              : color,
                    ),
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
            if (date != null && date!.contents.isNotEmpty) ...[
              // SquareIcon(color: date!.contents![0].color,),
              const SizedBox(height: 8),
              SquareIcon(
                color: date!.isHoliday
                    ? Colors.red
                    : Color(int.parse(date!.contents.first.color, radix: 16)),
                text: date!.contents.length.toString(),
              ),
            ]

            // CommonDateContents(
            //   contents: date!.contents!,
            //   date: date!,
            // ),
          ]),
        ));
  }
}
