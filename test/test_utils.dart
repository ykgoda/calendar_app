import 'dart:ffi';

import 'package:calendar_app/collections/date_content.dart';
import 'package:calendar_app/collections/date_content_handler.dart';
import 'package:calendar_app/collections/settings.dart';
import 'package:calendar_app/collections/settings_handler.dart';
import 'package:calendar_app/common/const.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

import 'mock.dart';

class TestUtils {
  late Isar isar;
  late Provider<DateContentHandler> dateContentHandler;
  late Provider<SettingsHandler> settingsHandler;
  StateNotifierProvider<ThemeColorState, MaterialColor>? themeColorProvider;

  Future<void> main() async {
    // WidgetsFlutterBinding.ensureInitialized();

    final name = Random().nextInt(pow(2, 32) as int);
    final evacuation = HttpOverrides.current;
    HttpOverrides.global = null;
    await Isar.initializeIsarCore(
      download: true,
    );
    HttpOverrides.global = evacuation;
    final dir = Directory(
      path.join(
        Directory.current.path,
        '.dart_tool',
        'test',
        'application_support_$name',
      ),
    );
    await dir.create(recursive: true);
    isar = await Isar.open(
      [
        DateContentSchema,
        SettingsSchema,
      ],
      directory: dir.path,
    );
    dateContentHandler = Provider((ref) {
      final handler = DateContentHandler(isar);
      return handler;
    });

    settingsHandler = Provider((ref) {
      final handler = SettingsHandler(isar);
      return handler;
    });
    final color = await SettingsHandler(isar).getSettings();
    int index = 0;
    if (color != null) {
      index = color.themeColorIndex;
    }

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // onDidReceiveLocalNotification: on  DidReceiveLocalNotification,
    );

    // for test code
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    final flnp = FlutterLocalNotificationsPlugin();
    flnp.initialize(
      const InitializationSettings(
        iOS: initializationSettingsDarwin,
        android: initializationSettingsAndroid,
      ),
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));

    runApp(ProviderScope(
      overrides: [
        dateContentHandler.overrideWith((ref) => DateContentHandler(isar)),
      ],
      child: const MyApp(),
    ));
  }

  Future<void> setUp() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final evacuation = HttpOverrides.current;
    HttpOverrides.global = null;

    final isarLibraryDir = Directory(
      path.join(
        Directory.current.path,
        '.dart_tool',
        'test',
        'isar_core_library',
        Isar.version,
      ),
    );
    if (!isarLibraryDir.existsSync()) {
      await isarLibraryDir.create(recursive: true);
    }

    await Isar.initializeIsarCore(
      libraries: <Abi, String>{
        Abi.current(): path.join(
          isarLibraryDir.path,
          Abi.current().localName,
        ),
      },
      download: true,
    );
    HttpOverrides.global = evacuation;
    PathProviderPlatform.instance = MockPathProviderPlatform();
    final dir = await getApplicationSupportDirectory();
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    isar = await Isar.open(
      [DateContentSchema, SettingsSchema],
      directory: dir.path,
    );

    final themeColorProvider =
        StateNotifierProvider<ThemeColorState, MaterialColor>(
            (ref) => ThemeColorState(themeColorList[0]));

    dateContentHandler = Provider((ref) => DateContentHandler(isar));
    settingsHandler = Provider((ref) => SettingsHandler(isar));

    setDateContentDB();
  }

  Future<void> tearDown() async {
    if (isar.isOpen == true) {
      await isar.close(deleteFromDisk: true);
    }
    final dir = await getApplicationSupportDirectory();
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  Future<void> setDateContentDB() async {
    final DateContent content = DateContent();
    content
      ..id = 0
      ..color = ''
      ..content = 'aaa'
      ..date = DateTime.now()
      ..startTime = DateTime.now()
      ..endTime = DateTime.now();
    return isar.writeTxn(() async {
      await isar.dateContents.put(content);
    });
  }
}

extension on Abi {
  String get localName {
    switch (Abi.current()) {
      case Abi.androidArm:
      case Abi.androidArm64:
      case Abi.androidIA32:
      case Abi.androidX64:
        return 'libisar.so';
      case Abi.macosArm64:
      case Abi.macosX64:
        return 'libisar.dylib';
      case Abi.linuxX64:
        return 'libisar.so';
      case Abi.windowsArm64:
      case Abi.windowsX64:
        return 'isar.dll';
      default:
        // ignore: only_throw_errors
        throw 'Unsupported processor architecture "${Abi.current()}".'
            'Please open an issue on GitHub to request it.';
    }
  }
}
