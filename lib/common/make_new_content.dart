import 'package:calendar_app/common/text.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../type/type.dart';
import '../collections/date_content.dart';

class MakeNewContent extends ConsumerStatefulWidget {
  const MakeNewContent(
      {super.key,
      required this.date,
      required this.addContents,
      required this.updateContents,
      required this.isBlank,
      required this.content});

  final Date date;
  final Function addContents;
  final Function updateContents;
  final bool isBlank;
  final DateContent content;

  @override
  MakeNewContentState createState() => MakeNewContentState();
}

class MakeNewContentState extends ConsumerState<MakeNewContent> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Color? selectedColor;
  String selectedColorToString = '';
  String text = '';

  final contents = <DateContent>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration.zero,
        () => () async {
              final getContents =
                  await ref.watch(dateContentHandler).getContents();
              final dateContents = getContents
                  .where((content) =>
                      content.date.year == widget.date.year &&
                      content.date.month == widget.date.month &&
                      content.date.day == widget.date.date)
                  .toList();
              setState(() {
                contents.addAll(dateContents);
              });
            }());

    if (!widget.isBlank) {
      setState(() {
        startTime = widget.content.startTime;
        endTime = widget.content.endTime;
        // selectedColor = Color(int.parse(widget.content.color, radix: 16));
        selectedColor = Colors.white;
        selectedColorToString = widget.content.color;
        text = widget.content.content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ColoredBox(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Material(
                      child: IconButton(
                          alignment: Alignment.centerLeft,
                          iconSize: 32.0,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                    ),
                    CommonText(widget.isBlank ? '新規作成' : '更新する'),
                  ],
                ),
                Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: _verticalPadding,
                          horizontal: _horizontalPadding),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'タイトル',
                        ),
                        initialValue: text,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                      ),
                    )),
                SettingItem(
                    titleItem: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('カラーを選択'),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: selectedColor ?? Colors.black,
                                  onColorChanged: (color) {
                                    setState(() {
                                      selectedColor = color;
                                      selectedColorToString =
                                          color.value.toRadixString(16);
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const CommonText('Done'))
                              ],
                            ),
                          );
                        },
                        child: const Text('カラー')),
                    contentItem: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedColor ?? Colors.black,
                      ),
                    )),
                SettingItem(
                  titleItem: TextButton(
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            currentTime: DateTime.now(),
                            showSecondsColumn: false,
                            locale: LocaleType.jp, onConfirm: (time) {
                          setState(() {
                            startTime = time;
                          });
                        });
                      },
                      child: Text(startTime.toString() == 'null'
                          ? '開始時間'
                          : ('${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'))),
                ),
                SettingItem(
                    titleItem: TextButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        currentTime: DateTime.now(),
                        showSecondsColumn: false,
                        locale: LocaleType.jp, onConfirm: (time) {
                      setState(() {
                        endTime = time;
                      });
                    });
                  },
                  child: Text(endTime.toString() == 'null'
                      ? '終了時間'
                      : ('${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}')),
                )),
                widget.isBlank
                    ? SettingItem(
                        titleItem: TextButton(
                        child: const Text('作成する'),
                        onPressed: () {
                          final DateContent newContent = DateContent();
                          final setDate = DateTime(widget.date.year!,
                              widget.date.month!, widget.date.date!);
                          newContent
                            ..content = text
                            ..startTime = startTime
                            ..endTime = endTime
                            ..color = selectedColorToString
                            ..date = setDate;
                          ref
                              .watch(dateContentHandler)
                              .addContent(content: newContent);

                          setState(() {
                            contents.add(newContent);
                          });
                          widget.addContents(newContent);
                          // Navigator.popUntil(context, (route) => route.isFirst);
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            Navigator.pop(context);
                          });
                        },
                      ))
                    : SettingItem(
                        titleItem: TextButton(
                        child: const Text('更新する'),
                        onPressed: () {
                          ref.watch(dateContentHandler).updateContent(
                              startTime: startTime,
                              endTime: endTime,
                              color: selectedColorToString,
                              text: text,
                              content: widget.content);
                          final DateContent newContent = DateContent();
                          final setDate = DateTime(widget.date.year!,
                              widget.date.month!, widget.date.date!);
                          newContent
                            ..content = text
                            ..startTime = startTime
                            ..endTime = endTime
                            ..color = selectedColorToString
                            ..date = setDate;
                          widget.updateContents(newContent);
                        },
                      )),
                if (contents.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final content = contents[index];
                        return CommonText(content.content);
                      },
                      itemCount: contents.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  )
              ],
            )));
  }
}

const _horizontalPadding = 8.0;
const _verticalPadding = 16.0;

class SettingItem extends StatelessWidget {
  const SettingItem({super.key, required this.titleItem, this.contentItem});

  final Widget titleItem;
  final Widget? contentItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(4.0)),
            child: Column(children: [
              // Expanded(
              Row(children: [
                titleItem,
                const SizedBox(
                  width: 16,
                ),
                contentItem ?? const SizedBox.shrink(),
              ]),
              // )
            ])));
  }
}
