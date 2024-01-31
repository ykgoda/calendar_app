import '../collections/date_content.dart';

class Date {
  Date(
      {required this.year,
      required this.month,
      required this.date,
      required this.day,
      required this.contents,
      this.isHoliday = false});

  final int year;
  final int month;
  final int date;
  final int day; // 曜日
  final List<DateContent> contents;
  bool isHoliday;
}

class Holiday {
  const Holiday(
      {required this.holiday, required this.month, required this.date});

  final String holiday;
  final int month;
  final int date;
}

class HolidayCondition {
  const HolidayCondition({
    required this.holiday,
    required this.month,
    required this.number,
    required this.weekday,
  });

  final String holiday;
  final int month;
  final int number;
  final int weekday;
}

// class DateContent {
//   const DateContent(
//       {required this.content, required this.startTime, required this.endTime});

//   final String content;
//   final DateTime startTime;
//   final DateTime endTime;
// }
