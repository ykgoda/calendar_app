import 'package:calendar_app/collections/date_content.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/date_content_provider.dart';
import '../type/type.dart';
import '../common/card.dart';

class Month extends ConsumerStatefulWidget {
  const Month({super.key});

  @override
  MonthState createState() => MonthState();
}

class MonthState extends ConsumerState<Month> {
  List<DateContent> contents = [];
  bool init = false;

  @override
  void initState() {
    super.initState();
    ref.read(dateContentHandler).dateContentStream.listen(_refreshContents);

    () async {
      _refreshContents(await ref.watch(dateContentHandler).getContents());
    }();
    if (contents.isEmpty) {
      Future.delayed(
          Duration.zero,
          () => () async {
                final initContents =
                    await ref.watch(dateContentHandler).getContents();
                setState(() {
                  contents
                    ..clear()
                    ..addAll(initContents);
                });
              }());
    }
  }

  void _refreshContents(List<DateContent> getContents) {
    if (!mounted) {
      return;
    }

    setState(() {
      contents
        ..clear()
        ..addAll(getContents);
    });
  }

  @override
  Widget build(BuildContext context) {
    final getContents = ref.watch(dateContentProvider);
    final year = ref.watch(yearProvider);
    final month = ref.watch(monthProvider);
    final date = ref.watch(dateProvider);
    final firstDay = DateTime(year, month, 1).weekday;
    final lastDate =
        DateTime(year, month + 1, 1).add(const Duration(days: -1)).day;
    final lastDay =
        DateTime(year, month + 1, 1).add(const Duration(days: -1)).weekday;
    final firstWeekCount = 7 - firstDay;
    final weekCount = (lastDate - firstWeekCount) ~/ 7.truncate();
    final prevMonthLastDate =
        DateTime(year, month, 1).add(const Duration(days: -1)).day;
    final lastWeekCount = lastDate - (firstWeekCount + (7 * weekCount));
    final List<Date> monthData = [];
    final prevMountCount = 7 - firstWeekCount;
    final nextMonthCount = 7 - lastWeekCount;
    final rowCount = (prevMountCount +
            firstWeekCount +
            (7 * weekCount) +
            lastWeekCount +
            nextMonthCount) /
        7;

    List<DateContent> getDateContents(
        {required int year, required int month, required int date}) {
      final dateContets = contents
          .where((content) =>
              content.date.year == year &&
              content.date.month == month &&
              content.date.day == date)
          .toList();
      return dateContets ?? [];
    }

    // if (firstWeekCount == 7) {
    //   for (int i = 0; i < 7; i++) {
    //     if (month == 1) {
    //       monthData.insert(
    //           0,
    //           Date(
    //               year: year - 1,
    //               month: 12,
    //               date: prevMonthLastDate - i,
    //               day: 7 - i,
    //               contents: getDateContents(
    //                   year: year - 1, month: 12, date: prevMonthLastDate - i)));
    //     } else {
    //       monthData.insert(
    //           0,
    //           Date(
    //               year: year,
    //               month: month - 1,
    //               date: prevMonthLastDate - i,
    //               day: 7 - i,
    //               contents: getDateContents(
    //                   year: year,
    //                   month: month - 1,
    //                   date: prevMonthLastDate - i)));
    //     }
    //   }
    // }

    if (firstWeekCount != 7) {
      for (int i = 0; i < 7 - firstWeekCount; i++) {
        if (month == 1) {
          monthData.insert(
              0,
              Date(
                  year: year - 1,
                  month: 12,
                  date: prevMonthLastDate - i,
                  day: firstDay - (i + 1) == 0 ? 7 : firstDay - (i + 1),
                  contents: []));
        } else {
          monthData.insert(
              0,
              Date(
                  year: year,
                  month: month - 1,
                  date: prevMonthLastDate - i,
                  day: firstDay - (i + 1) == 0 ? 7 : firstDay - (i + 1),
                  contents: []));
        }
      }
    }

    for (int i = 1; i <= firstWeekCount; i++) {
      monthData.add(Date(
          year: year,
          month: month,
          date: i,
          day: firstDay + i - 1,
          contents: getDateContents(year: year, month: month, date: i)));
    }

    for (int i = 1 + firstWeekCount; i <= 7 * weekCount + firstWeekCount; i++) {
      final day = ((i - firstWeekCount - 1) % 7) == 0
          ? 7
          : (i - firstWeekCount - 1) % 7;
      monthData.add(Date(
          year: year,
          month: month,
          date: i,
          day: day,
          contents: getDateContents(year: year, month: month, date: i)));
    }

    for (int i = firstWeekCount + (7 * weekCount) + 1; i <= lastDate; i++) {
      monthData.add(Date(
          year: year,
          month: month,
          date: i,
          day: (i - (firstWeekCount + (7 * weekCount)) - 1) == 0
              ? 7
              : (i - (firstWeekCount + (7 * weekCount)) - 1),
          contents: []));
    }
    if (lastWeekCount != 7) {
      for (int i = 1; i <= 7 - lastWeekCount; i++) {
        if (month == 12) {
          monthData.add(Date(
              year: year + 1,
              month: 1,
              date: i,
              day: lastWeekCount + i - 1,
              contents: []));
        } else {
          monthData.add(Date(
              year: year,
              month: month + 1,
              date: i,
              day: lastWeekCount + i - 1,
              contents: []));
        }
      }
    }

    // if (lastWeekCount == 7) {
    //   for (int i = 1; i <= 7; i++) {
    //     if (month == 12) {
    //       monthData.add(
    //           Date(year: year + 1, month: 1, date: i, day: i, contents: []));
    //     } else {
    //       monthData.add(Date(
    //           year: year, month: month + 1, date: i, day: i, contents: []));
    //     }
    //   }
    // }
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '日',
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '月',
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '火',
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '水',
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '木',
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '金',
                ),
              ),
              Expanded(
                child: CommonCard(
                  height: 40,
                  text: '土',
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          // SizedBox(
          //   height: 32,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: Container(
          //             height: 32,
          //             decoration: BoxDecoration(
          //               border: Border.all(
          //                   color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //             ),
          //             child: const Align(
          //               child: CommonText(
          //                 'Sun',
          //                 fontSize: 16,
          //               ),
          //             )),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border:
          //                 Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          //           ),
          //           child: const CommonText(
          //             'Sun',
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          for (int i = 1; i <= rowCount; i++)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int u = 1; u <= 7; u++)
                    Expanded(
                        child: CommonCard(
                      date: monthData[(7 * (i - 1)) + u - 1],
                      text: monthData[(7 * (i - 1)) + u - 1].date.toString(),
                    ))
                ],
              ),
            ),
        ],
      ),
    );
  }
}
