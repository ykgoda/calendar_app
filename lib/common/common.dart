import 'package:calendar_app/month/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottom_navigation_bar.dart';
import 'package:calendar_app/main.dart';

class Common extends ConsumerWidget {
  const Common({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(yearProvider);
    final month = ref.watch(monthProvider);
    final date = ref.watch(dateProvider);

    return Column(
      children: [
        AppBar(
          title: Text(
            '${year.toString()} 年 ${month.toString()} 月',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Expanded(
          child: _Content(content: Month()),
        ),
        const CommonBottomNavigationBar()
      ],
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
