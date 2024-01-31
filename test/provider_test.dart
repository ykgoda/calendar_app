import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  // Provider

  // StateProvider
  test('year provider', () async {
    final year = DateTime.now().year;
    final container = ProviderContainer(overrides: [
      yearProvider.overrideWith((ref) => year),
    ]);
    addTearDown(container.dispose);

    expect(container.read(yearProvider), year);
  });

  test('month provider', () async {
    final month = DateTime.now().month;
    final container = ProviderContainer(overrides: [
      monthProvider.overrideWith((ref) => month),
    ]);
    addTearDown(container.dispose);

    expect(container.read(monthProvider), month);
  });

  test('date provider', () async {
    final date = DateTime.now().day;
    final container = ProviderContainer(overrides: [
      dateProvider.overrideWith((ref) => date),
    ]);
    addTearDown(container.dispose);

    expect(container.read(dateProvider), date);
  });

  // StateNotifierProvider
  test('theme color provider', () async {
    final container = ProviderContainer(overrides: [
      themeColorProvider.overrideWith((ref) => ThemeColorState(Colors.blue)),
    ]);
    expect(container.read(themeColorProvider), Colors.blue);
  });
}
