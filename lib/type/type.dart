import '../collections/date_content.dart';

class Date {
  const Date({this.year, this.month, this.date, this.day, this.contents});

  final int? year;
  final int? month;
  final int? date;
  final int? day; // 曜日
  final List<DateContent>? contents;
}

// class DateContent {
//   const DateContent(
//       {required this.content, required this.startTime, required this.endTime});

//   final String content;
//   final DateTime startTime;
//   final DateTime endTime;
// }
