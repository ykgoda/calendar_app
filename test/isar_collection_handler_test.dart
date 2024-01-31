import 'dart:ffi';

import 'package:calendar_app/collections/date_content_handler.dart';
import 'package:calendar_app/collections/settings_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  final utils = TestUtils();
  setUp(utils.setUp);
  tearDown(utils.tearDown);

  test('date content handler', () async {
    final handler = DateContentHandler(utils.isar);
    final container = ProviderContainer(
        overrides: [utils.dateContentHandler.overrideWith((ref) => handler)]);
    expect(container.read(utils.dateContentHandler), handler);
  });

  test('settings handler', () async {
    final handler = SettingsHandler(utils.isar);
    final container = ProviderContainer(
        overrides: [utils.settingsHandler.overrideWith((ref) => handler)]);
    expect(container.read(utils.settingsHandler), handler);
  });
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
