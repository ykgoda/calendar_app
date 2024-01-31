import 'dart:io';
import 'dart:math';

import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final name = Random().nextInt(pow(2, 32) as int);

  @override
  Future<String> getApplicationSupportPath() async {
    return Directory(
      path.join(
        Directory.current.path,
        '.dart_tool',
        'test',
        'application_support_$name',
      ),
    ).path;
  }
}
