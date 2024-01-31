import 'dart:io';

import 'package:calendar_app/collections/date_content.dart';
import 'package:calendar_app/collections/settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' as foundation;

Future<Isar> isarSettings() async {
  var path = '';
  if (!foundation.kIsWeb) {
    final evacuation = HttpOverrides.current;
    HttpOverrides.global = null;
    await Isar.initializeIsarCore(
      download: true,
    );
    HttpOverrides.global = evacuation;
    final dir = await getApplicationSupportDirectory();
    path = dir.path;
  }

  final isar = await Isar.open(
    [
      DateContentSchema,
      SettingsSchema,
    ],
    directory: path,
  );
  return isar;
}
