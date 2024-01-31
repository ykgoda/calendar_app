import 'dart:async';

import 'package:calendar_app/collections/date_content.dart';
import 'package:calendar_app/main.dart';
import 'package:isar/isar.dart';

import '../settings/notification.dart';

class DateContentHandler {
  DateContentHandler(
    this.isar, {
    this.sync = false,
  }) {
    isar.dateContents.watchLazy().listen((event) async {
      if (!isar.isOpen) {
        return;
      }
      if (_dateContentController.isClosed) {
        return;
      }
      _dateContentController.sink.add(await getContents());
    });
  }

  final Isar isar;

  final bool sync;

  final _dateContentController =
      StreamController<List<DateContent>>.broadcast();
  Stream<List<DateContent>> get dateContentStream =>
      _dateContentController.stream;

  void dispose() {
    _dateContentController.close();
  }

  FutureOr<List<DateContent>> getContents() async {
    if (!isar.isOpen) {
      return [];
    }

    final contents = await isar.dateContents.where().sortByDate().findAll();

    return contents;
  }

  FutureOr<void> addContent({required DateContent content}) {
    if (!isar.isOpen) {
      return Future<void>(() {});
    }

    return isar.writeTxn(() async {
      isar.dateContents.put(content);
    }).then((value) {
      Timer(const Duration(seconds: 3), () {
        flutterLocalNotificationsPlugin.cancelAll();
        _allNotificationsUpdate();
      });
    });
  }

  void _allNotificationsUpdate() async {
    final contents = await isar.dateContents.where().sortByDate().findAll();
    for (final content in contents) {
      if (content.date.year >= DateTime.now().year &&
          content.date.month >= DateTime.now().month &&
          content.date.day >= DateTime.now().day &&
          content.startTime.hour >= DateTime.now().hour &&
          content.startTime.minute >= DateTime.now().minute) {
        notificationSchedule(
            id: content.id,
            body: content.content,
            year: content.date.year,
            month: content.date.month,
            day: content.date.day,
            hour: content.startTime.hour,
            minutes: content.startTime.minute);
      }
      print('---id ${content.id}');
    }
  }

  FutureOr<void> updateContent({
    required DateTime startTime,
    required DateTime endTime,
    required String color,
    required String text,
    required DateContent content,
  }) {
    if (!isar.isOpen) {
      return Future<void>(() {});
    }

    content
      ..content = text
      ..color = color
      ..startTime = startTime
      ..endTime = endTime;

    flutterLocalNotificationsPlugin.cancel(content.id);
    if (content.date.year >= DateTime.now().year &&
        content.date.month >= DateTime.now().month &&
        content.date.day >= DateTime.now().day &&
        content.startTime.hour >= DateTime.now().hour &&
        content.startTime.minute >= DateTime.now().minute) {
      notificationSchedule(
          id: content.id,
          body: content.content,
          year: content.date.year,
          month: content.date.month,
          day: content.date.day,
          hour: content.startTime.hour,
          minutes: content.startTime.minute);
      print('---here');
    }
    print('---id here ${content.id}');
    return isar.writeTxn(() async {
      await isar.dateContents.put(content);
    });
  }

  FutureOr<void> deleteContent(DateContent content) {
    if (!isar.isOpen) {
      return Future<void>(() {});
    }
    flutterLocalNotificationsPlugin.cancel(content.id);
    return isar.writeTxn(() async {
      await isar.dateContents.delete(content.id);
    });
  }
}
