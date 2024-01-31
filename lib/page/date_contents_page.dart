import 'package:calendar_app/common/const.dart';
import 'package:calendar_app/common/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/appbar.dart';
import '../type/type.dart';
import '../collections/date_content.dart';
import 'make_new_content_page.dart';

class DateContentsPage extends StatefulWidget {
  const DateContentsPage({super.key, required this.date});

  final Date date;

  @override
  DateContentsPageState createState() => DateContentsPageState();
}

class DateContentsPageState extends State<DateContentsPage> {
  List<DateContent> contents = [];

  @override
  void initState() {
    super.initState();

    final dateContents = widget.date.contents;
    contents
      ..clear()
      ..addAll(dateContents);
  }

  void addContents(DateContent content) {
    setState(() {
      contents.insert(0, content);
    });
  }

  void updateContents(DateContent newContent) {
    setState(() {
      contents
          .map((content) => content.id == newContent.id ? newContent : content);
    });
  }

  void deleteContents(DateContent deleteContent) {
    setState(() {
      contents.removeWhere((content) => content.id == deleteContent.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final day = switch (widget.date.day) {
      1 => '月',
      2 => '火',
      3 => '水',
      4 => '木',
      5 => '金',
      6 => '土',
      7 => '日',
      _ => '',
    };
    final slicedContents =
        contents.length > 8 ? contents.sublist(0, 8) : contents;

    // final contents =
    //     widget.date.contents!.isNotEmpty ? widget.date.contents : [];
    return Scaffold(
        appBar: CommonAppBar(
          '${widget.date.month}/${widget.date.date}($day)の予定',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                  onPressed: contents.length == 8
                      ? null
                      : () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MakeNewContentPage(
                              date: widget.date,
                              addContents: addContents,
                              updateContents: updateContents,
                              deleteContents: deleteContents,
                              isBlank: true,
                              content: DateContent(),
                            );
                          }));
                        },
                  child: contents.length == 8
                      ? const Text(
                          '作成',
                          style: TextStyle(fontSize: 24),
                        )
                      : const CommonText('作成')),
            )
          ],
        ),
        body: CupertinoPageScaffold(
            child: contents.isNotEmpty
                ? CupertinoScrollbar(
                    child: CupertinoListSection.insetGrouped(
                        children: <CupertinoListTile>[
                        for (final content in slicedContents) ...{
                          CupertinoListTile(
                            title: CommonText(content.content),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  '${content.startTime.hour.toString().padLeft(2, '0')} : ${content.startTime.minute.toString().padLeft(2, '0')}',
                                  fontSize: 12,
                                ),
                                const CommonText(
                                  '|',
                                  fontSize: 12,
                                ),
                                CommonText(
                                  '${content.endTime.hour.toString().padLeft(2, '0')} : ${content.endTime.minute.toString().padLeft(2, '0')}',
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            trailing: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Color(int.parse(content.color, radix: 16)),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: verticalPadding),
                            leadingSize: 56.0,
                            onTap: content.color ==
                                    Colors.white.value.toRadixString(16)
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return MakeNewContentPage(
                                        date: widget.date,
                                        addContents: addContents,
                                        updateContents: updateContents,
                                        deleteContents: deleteContents,
                                        isBlank: false,
                                        content: content,
                                      );
                                    }));
                                  },
                          )
                        }
                      ]))
                : const SizedBox.shrink()));
  }
}
