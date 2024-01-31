import 'package:calendar_app/type/type.dart';
import 'package:flutter/material.dart';

const horizontalPadding = 16.0;
const verticalPadding = 8.0;

const listItemPadding = 24.0;

const List<MaterialColor> themeColorList = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.grey
];

const List<Holiday> holidayByDateList = [
  Holiday(holiday: '元日', month: 1, date: 1),
  Holiday(holiday: '建国記念の日', month: 2, date: 11),
  Holiday(holiday: '天皇誕生日', month: 2, date: 23),
  Holiday(holiday: '昭和の日', month: 4, date: 29),
  Holiday(holiday: '憲法記念日', month: 5, date: 3),
  Holiday(holiday: 'みどりの日', month: 5, date: 4),
  Holiday(holiday: 'こどもの日', month: 5, date: 5),
  Holiday(holiday: '山の日', month: 8, date: 11),
  Holiday(holiday: '文化の日', month: 11, date: 3),
  Holiday(holiday: '勤労感謝の日', month: 11, date: 23),
];

const List<HolidayCondition> holidayByConditionList = [
  HolidayCondition(holiday: '成人の日', month: 1, number: 2, weekday: 1),
  HolidayCondition(holiday: '海の日', month: 7, number: 3, weekday: 1),
  HolidayCondition(holiday: '敬老の日', month: 9, number: 3, weekday: 1),
  HolidayCondition(holiday: 'スポーツの日', month: 10, number: 2, weekday: 1),
];

const Map<int, Holiday> holidaySpringList = {
  2023: Holiday(holiday: '春分の日', month: 3, date: 21),
  2024: Holiday(holiday: '春分の日', month: 3, date: 20),
  2025: Holiday(holiday: '春分の日', month: 3, date: 20),
  2026: Holiday(holiday: '春分の日', month: 3, date: 20),
  2027: Holiday(holiday: '春分の日', month: 3, date: 21),
};

const Map<int, Holiday> holidayAutumnList = {
  2023: Holiday(holiday: '秋分の日', month: 9, date: 23),
  2024: Holiday(holiday: '秋分の日', month: 9, date: 22),
  2025: Holiday(holiday: '秋分の日', month: 9, date: 23),
  2026: Holiday(holiday: '秋分の日', month: 9, date: 20),
  2027: Holiday(holiday: '秋分の日', month: 9, date: 21),
};
