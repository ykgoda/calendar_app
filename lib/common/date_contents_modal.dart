import 'package:calendar_app/common/text.dart';
import 'package:flutter/material.dart';
import '../type/type.dart';
import '../common/date_content_item.dart';
import '../collections/date_content.dart';

const _verticalPadding = 8.0;
const _horizontalPadding = 16.0;

class CommonDateContentsModal extends StatefulWidget {
  const CommonDateContentsModal({super.key, required this.date});

  final Date date;

  @override
  CommonDateContentsModalState createState() => CommonDateContentsModalState();
}

class CommonDateContentsModalState extends State<CommonDateContentsModal> {
  List<DateContent> contents = [];

  @override
  void initState() {
    super.initState();

    final dateContents = widget.date.contents!;
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

    // final contents =
    //     widget.date.contents!.isNotEmpty ? widget.date.contents : [];
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _verticalPadding * 2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: Row(
                    children: [
                      CommonText(
                        widget.date.month.toString(),
                        fontSize: 32,
                      ),
                      const CommonText(
                        '/',
                        fontSize: 32,
                      ),
                      CommonText(
                        widget.date.date.toString(),
                        fontSize: 32,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CommonText(
                        day,
                        fontSize: 24,
                        color: widget.date.day == 6
                            ? Colors.blue
                            : widget.date.day == 7
                                ? Colors.red
                                : Colors.black,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_outlined),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: _verticalPadding * 2),
                  child: Column(children: [
                    if (contents != null)
                      for (final content in contents) ...{
                        DateContentItem(
                          content: content,
                          date: widget.date,
                          addContents: addContents,
                          updateContents: updateContents,
                          deleteContents: deleteContents,
                        )
                      },
                  ]),
                ))),
                DateContentItem.blank(
                  date: widget.date,
                  content: DateContent(),
                  addContents: addContents,
                  updateContents: updateContents,
                  deleteContents: deleteContents,
                )
              ],
            )));
  }
}
