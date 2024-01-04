import 'package:calendar_app/common/text.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../type/type.dart';
import '../common/make_new_content.dart';
import '../collections/date_content.dart';

const _verticalPadding = 8.0;
const _horizontalPadding = 16.0;

class DateContentItem extends ConsumerWidget {
  const DateContentItem(
      {super.key,
      required this.content,
      required this.date,
      required this.addContents,
      required this.updateContents,
      required this.deleteContents,
      this.isBlank = false});

  const DateContentItem.blank(
      {super.key,
      required this.content,
      required this.date,
      required this.addContents,
      required this.updateContents,
      required this.deleteContents,
      this.isBlank = true});

  final DateContent content;
  final Date date;
  final Function addContents;
  final Function updateContents;
  final Function deleteContents;
  final bool isBlank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MakeNewContent(
                date: date,
                addContents: addContents,
                updateContents: updateContents,
                isBlank: isBlank,
                content: content,
              );
            })),
        child: ColoredBox(
            color: Colors.white,
            // color: Color(int.parse(content.color, radix: 16)),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: _verticalPadding, horizontal: _horizontalPadding),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                          // An action can be bigger than the others.
                          spacing: 2,
                          flex: 1,
                          onPressed: (context) {
                            ref
                                .watch(dateContentHandler)
                                .deleteContent(content);
                            deleteContents(content);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '削除',
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                    ],
                  ),
                  child: Container(
                      height: 108.0,
                      decoration: BoxDecoration(
                          border: isBlank
                              ? Border.all(
                                  color: const Color.fromRGBO(0, 0, 0, 0.1))
                              : Border.all(
                                  color: const Color.fromRGBO(0, 0, 0, 0.5)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      padding: const EdgeInsets.symmetric(
                          vertical: _verticalPadding,
                          horizontal: _horizontalPadding),
                      child: isBlank
                          ? const Align(
                              child: CommonText('追加する'),
                            )
                          : Row(
                              children: [
                                Column(
                                  children: [
                                    CommonText(
                                        '${content.startTime.hour} : ${content.startTime.minute}'),
                                    const CommonText('|'),
                                    CommonText(
                                        '${content.endTime.hour} : ${content.endTime.minute}'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: _verticalPadding,
                                      horizontal: _horizontalPadding * 2),
                                  child: CommonText(content.content),
                                )
                              ],
                            )),
                ))));
  }
}
