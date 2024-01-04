import 'package:isar/isar.dart';

part 'date_content.g.dart';

@Collection()
class DateContent {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late String content;
  late DateTime startTime;
  late DateTime endTime;
  late String color;
}
