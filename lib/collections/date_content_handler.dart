import 'dart:async';

import 'package:calendar_app/collections/date_content.dart';
import 'package:isar/isar.dart';

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
    });
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
    return isar.writeTxn(() async {
      await isar.dateContents.put(content);
    });
  }

  FutureOr<void> deleteContent(DateContent content) {
    if (!isar.isOpen) {
      return Future<void>(() {});
    }
    return isar.writeTxn(() async {
      await isar.dateContents.delete(content.id);
    });
  }
}
