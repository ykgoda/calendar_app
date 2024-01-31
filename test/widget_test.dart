import 'package:calendar_app/collections/date_content.dart';
import 'package:calendar_app/common/card.dart';
import 'package:calendar_app/common/common.dart';
import 'package:calendar_app/common/const.dart';
import 'package:calendar_app/common/square_icon.dart';
import 'package:calendar_app/main.dart';
import 'package:calendar_app/month/month.dart';
import 'package:calendar_app/page/date_contents_page.dart';
import 'package:calendar_app/page/make_new_content_page.dart';
import 'package:calendar_app/settings/settings.dart';
import 'package:calendar_app/type/type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_ui/settings_ui.dart';

void main() {
  Future<void> initApp(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          themeColorProvider
              .overrideWith((ref) => ThemeColorState(themeColorList[0])),
          loadingProvider.overrideWith((ref) => true)
        ],
        child: const MyApp(),
      ));
    });

    await tester.pumpAndSettle();
  }

  testWidgets('Common screen test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          themeColorProvider
              .overrideWith((ref) => ThemeColorState(themeColorList[0])),
          loadingProvider.overrideWith((ref) => true)
        ],
        child: const MyApp(),
      ));
    });

    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((widget) => widget is AppBar), findsOneWidget);

    expect(
        find.byWidgetPredicate(
            (widget) => widget is Container && widget.color == Colors.black),
        findsOneWidget);

    expect(find.byWidgetPredicate((widget) => widget is BottomNavigationBar),
        findsOneWidget);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(Common));
    ref.read(loadingProvider.notifier).state = false;
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((widget) => widget is Month), findsOneWidget);

    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '日'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '月'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '火'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '水'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '木'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '金'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CommonCard && widget.text == '土'),
        findsOneWidget);

    ref.read(yearProvider.notifier).state = 2024;
    ref.read(monthProvider.notifier).state = 1;
    ref.read(dateProvider.notifier).state = 1;
    await tester.pumpAndSettle();

    // expect common card(day of week and date)
    expect(find.byWidgetPredicate((widget) => widget is CommonCard),
        findsNWidgets(42));
  });

  testWidgets('month screen test', (tester) async {
    DateContent content = DateContent();
    content.date = DateTime(2024, 1, 1);
    final List<DateContent> contents = [content, content, content];
    await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: Month(contents: contents))));
    await tester.pumpAndSettle();

    // expect icon of date content
    expect(
        find.byWidgetPredicate(
            (widget) => widget is SquareIcon && widget.text == '3'),
        findsOneWidget);

    // expect token of today
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Container &&
            widget.decoration ==
                const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue)),
        findsOneWidget);
  });

  testWidgets('appbar test', (tester) async {
    await initApp(tester);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(Common));
    ref.read(loadingProvider.notifier).state = false;
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((widget) =>
            widget is AppBar &&
            widget.leading != null &&
            widget.actions != null &&
            widget.title != null),
        findsOneWidget);
  });

  testWidgets('bottom navigation bar test', (tester) async {
    await initApp(tester);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(Common));
    ref.read(loadingProvider.notifier).state = false;
    await tester.pumpAndSettle();

    ref.read(yearProvider.notifier).state = 2024;
    ref.read(monthProvider.notifier).state = 12;
    ref.read(dateProvider.notifier).state = 1;
    await tester.pumpAndSettle();

    final goTodayButton = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.shortcut);
    await tester.tap(goTodayButton);
    await tester.pumpAndSettle();

    expect(ref.read(yearProvider), DateTime.now().year);
    expect(ref.read(monthProvider), DateTime.now().month);
    expect(ref.read(dateProvider), DateTime.now().day);

    // test of appbar title
    expect(find.text('${DateTime.now().year} 年 ${DateTime.now().month} 月'),
        findsOneWidget);
  });

  testWidgets('settings screen test', (tester) async {
    await initApp(tester);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(Common));
    ref.read(loadingProvider.notifier).state = false;
    await tester.pumpAndSettle();

    ref.read(indexProvider.notifier).state = 2;
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((widget) => widget is Settings), findsOneWidget);

    // text of appbar and bottom navigation bar
    expect(find.text('設定'), findsNWidgets(2));

    expect(find.byWidgetPredicate((widget) => widget is SettingsTile),
        findsNWidgets(3));

    expect(find.text('通知設定'), findsOneWidget);
    expect(find.text('使い方'), findsOneWidget);
    expect(find.text('カラー設定'), findsOneWidget);

    await tester.tap(find.text('カラー設定'));
    await tester.pumpAndSettle();

    expect(find.text('テーマカラー設定'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is CupertinoListTile),
        findsNWidgets(4));
    expect(find.text('ライトブルー'), findsOneWidget);
    expect(find.text('レッド'), findsOneWidget);
    expect(find.text('ライトグリーン'), findsOneWidget);
    expect(find.text('グレー'), findsOneWidget);
  });

  testWidgets('date content page screen test', (tester) async {
    await initApp(tester);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(Common));
    ref.read(loadingProvider.notifier).state = false;
    await tester.pumpAndSettle();

    await tester.tap(find.byWidgetPredicate(
        (widget) => widget is CommonCard && widget.text == '15'));
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((widget) => widget is DateContentsPage),
        findsOneWidget);
    expect(find.text('作成'), findsOneWidget);
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final weekday = DateTime(year, month, 15).weekday;
    final weekdayToString = switch (weekday) {
      1 => '月',
      2 => '火',
      3 => '水',
      4 => '木',
      5 => '金',
      6 => '土',
      7 => '日',
      _ => '',
    };

    final appBarTitle = '$month/15($weekdayToString)の予定';
    expect(find.text(appBarTitle), findsOneWidget);
  });

  testWidgets('make new content screen test', (tester) async {
    final DateContent content = DateContent();
    content
      ..id = 0
      ..content = 'test'
      ..startTime = DateTime(2024, 1, 15, 12, 30)
      ..endTime = DateTime(2024, 1, 15, 13, 30)
      ..color = ''
      ..date = DateTime(2024, 1, 15);
    final List<DateContent> contents = [content];
    await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
            home: DateContentsPage(
      date: Date(year: 2024, month: 1, date: 15, day: 1, contents: contents),
    ))));
    await tester.pumpAndSettle();

    expect(find.text('作成'), findsOneWidget);
    await tester.tap(find.text('作成'));
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((widget) => widget is MakeNewContentPage),
        findsOneWidget);
    expect(find.text('新規作成'), findsOneWidget);
    expect(find.text('作成'), findsOneWidget);

    expect(find.byWidgetPredicate((widget) => widget is SettingsSection),
        findsNWidgets(4));
  });
}
