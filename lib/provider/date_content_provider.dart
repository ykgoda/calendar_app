import 'package:calendar_app/collections/date_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../collections/date_content_handler.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:path_provider/path_provider.dart';

final dateContentProvider =
    NotifierProvider<DateContentNotifier, Future<List<DateContent>>>(
        DateContentNotifier.new);

class DateContentNotifier extends Notifier<Future<List<DateContent>>> {
  @override
  Future<List<DateContent>> build() async {
    var path = '';
    if (!foundation.kIsWeb) {
      final dir = await getApplicationSupportDirectory();
      path = dir.path;
    }

    final isar = await Isar.open(
      [
        DateContentSchema,
      ],
      directory: path,
    );
    final contents = await DateContentHandler(isar).getContents();
    return contents;
  }
}
