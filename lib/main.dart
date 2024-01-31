import 'package:calendar_app/collections/isar_settings.dart';
import 'package:calendar_app/common/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'collections/date_content_handler.dart';
import 'collections/settings_handler.dart';
import 'common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final dateProvider = StateProvider<int>((ref) {
  final date = DateTime.now().day;
  return date;
});
final monthProvider = StateProvider<int>((ref) {
  final month = DateTime.now().month;
  return month;
});
final yearProvider = StateProvider<int>((ref) {
  final year = DateTime.now().year;
  return year;
});

final colorProvider =
    StateNotifierProvider<ColorState, Color>((ref) => ColorState());

class ColorState extends StateNotifier<Color> {
  ColorState() : super(Colors.black);

  void updateColor(Color color) {
    state = color.withOpacity(0.8);
  }
}

final themeColorProvider =
    StateNotifierProvider<ThemeColorState, MaterialColor>(
        (ref) => ThemeColorState(themeColorList[0]));

class ThemeColorState extends StateNotifier<MaterialColor> {
  ThemeColorState(MaterialColor color) : super(color);

  void updateThemeColor(MaterialColor color) {
    state = color;
  }
}

// final colorProvider = StateProvider<Color>((ref) {
//   Color color = Colors.black;
//   return color;
// });

late Provider<DateContentHandler> dateContentHandler;
late Provider<SettingsHandler> settingsHandler;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await isarSettings();
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

  final flnp = FlutterLocalNotificationsPlugin();
  flnp.initialize(
    const InitializationSettings(
      iOS: initializationSettingsDarwin,
    ),
  );
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));

  runApp(ProviderScope(
    overrides: [
      themeColorProvider
          .overrideWith((ref) => ThemeColorState(themeColorList[index])),
      dateContentHandler.overrideWith((ref) => DateContentHandler(isar)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        primarySwatch: ref.watch(themeColorProvider),
      ),
      home: const Common(),
    );
  }
}
