import 'dart:async';

import 'package:calendar_app/collections/settings.dart';
import 'package:isar/isar.dart';

class SettingsHandler {
  SettingsHandler(this.isar, {this.sync = false}) {
    isar.settings.watchLazy().listen((event) async {
      if (!isar.isOpen) {
        return;
      }
      if (_settingsController.isClosed) {
        return;
      }
      final settings = await getSettings();
      if (settings != null) {
        _settingsController.sink.add(settings);
      }
    });
  }

  final Isar isar;

  final bool sync;

  final _settingsController = StreamController<Settings>.broadcast();
  Stream<Settings> get settingsStream => _settingsController.stream;

  void dispose() {
    _settingsController.close();
  }

  Future<Settings?> getSettings() async {
    if (!isar.isOpen) {
      print('---return');
      return Settings();
    }

    final settings = isar.settings.get(0);
    final f = await isar.settings.get(0);
    if (f != null) {
      print('---get ${f.themeColorIndex}');
    }
    return settings;
  }

  Future<void> updateSettings({required int index}) async {
    if (!isar.isOpen) {
      return Future<void>(() {});
    }

    final initSettings = Settings();
    initSettings.themeColorIndex = 0;

    final settings = await getSettings() ?? initSettings;
    settings.themeColorIndex = index;
    return isar.writeTxn(() async {
      print('---settings $settings');
      await isar.settings.put(settings);
    });
  }
}
