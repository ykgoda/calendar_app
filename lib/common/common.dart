import 'dart:async';

import 'package:calendar_app/month/month.dart';
import 'package:calendar_app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../collections/date_content.dart';
import 'bottom_navigation_bar.dart';
import 'package:calendar_app/main.dart';

final indexProvider = StateProvider<int>((ref) {
  int selectedIndex = 1;
  return selectedIndex;
});

final loadingProvider = StateProvider((ref) {
  bool isLoading = true;
  return isLoading;
});

class Common extends ConsumerStatefulWidget {
  const Common({super.key});

  @override
  CommonState createState() => CommonState();
}

class CommonState extends ConsumerState<Common> {
  List<DateContent> contents = [];
  bool isLoading = true;

  Widget _returnContents() {
    Timer(const Duration(seconds: 1), () {
      ref.read(dateContentHandler).dateContentStream.listen(_refreshContents);

      () async {
        _refreshContents(await ref.watch(dateContentHandler).getContents());
      }();
      if (contents.isEmpty) {
        Future.delayed(
            Duration.zero,
            () => () async {
                  final initContents =
                      await ref.watch(dateContentHandler).getContents();
                  setState(() {
                    contents
                      ..clear()
                      ..addAll(initContents);
                  });
                }());
      }
      ref.watch(loadingProvider.notifier).state = false;
    });
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
    );
  }

  void _refreshContents(List<DateContent> getContents) {
    if (!mounted) {
      return;
    }

    setState(() {
      contents
        ..clear()
        ..addAll(getContents);
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = ref.watch(yearProvider);
    final month = ref.watch(monthProvider);
    final date = ref.watch(dateProvider);
    final yearValue = ref.watch(yearProvider.notifier);
    final monthValue = ref.watch(monthProvider.notifier);
    final index = ref.watch(indexProvider);

    return Scaffold(
        // children: [
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            index != 2 ? '${year.toString()} 年 ${month.toString()} 月' : '設定',
            style: const TextStyle(fontSize: 16),
          ),
          leading: index != 2
              ? IconButton(
                  onPressed: () {
                    if (month == 1) {
                      yearValue.state--;
                      monthValue.state = 12;
                    } else {
                      monthValue.state--;
                    }
                  },
                  icon: const Icon(Icons.arrow_left),
                )
              : null,
          actions: index != 2
              ? [
                  IconButton(
                      onPressed: () {
                        if (month == 12) {
                          yearValue.state++;
                          monthValue.state = 1;
                        } else {
                          monthValue.state++;
                        }
                      },
                      icon: const Icon(Icons.arrow_right))
                ]
              : null,
        ),
        body: _Content(
            content: ref.watch(loadingProvider)
                ? _returnContents()
                : ref.watch(indexProvider) == 1
                    ? Month(
                        contents: contents,
                      )
                    : const Settings()),
        bottomNavigationBar: const CommonBottomNavigationBar()
        // ],
        );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: content);
  }
}
