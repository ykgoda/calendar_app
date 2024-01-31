import 'package:calendar_app/common/text.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../type/type.dart';
import '../collections/date_content.dart';
import 'button.dart';
import 'const.dart';

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
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Material(
                                child: Ink(
                                  color: Colors.white,
                                  child: IconButton(
                                    // alignment: Alignment.centerLeft,
                                    iconSize: 32.0,
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back_ios),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child:
                                  CommonText(widget.isBlank ? '新規作成' : '更新する'),
                            ),
                          ],
                        )),
                    Material(
                      type: MaterialType.transparency,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: verticalPadding * 2),
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
                      ),
                    ),
                    SettingItem(
                        onTap: () {
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
                        titleItem: const CommonText('カラー'),
                        contentItem: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedColor ?? Colors.black,
                          ),
                        )),
                    SettingItem(
                      onTap: () {
                        DatePicker.showTimePicker(context,
                            currentTime: DateTime.now(),
                            showSecondsColumn: false,
                            locale: LocaleType.jp, onConfirm: (time) {
                          setState(() {
                            startTime = time;
                          });
                        });
                      },
                      titleItem: const CommonText('開始時間'),
                      titleFlex: 7,
                      contentItem: CommonText(startTime.toString() == 'null'
                          ? ''
                          : ('${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}')),
                    ),
                    SettingItem(
                      onTap: () {
                        DatePicker.showTimePicker(context,
                            currentTime: DateTime.now(),
                            showSecondsColumn: false,
                            locale: LocaleType.jp, onConfirm: (time) {
                          setState(() {
                            endTime = time;
                          });
                        });
                      },
                      titleItem: const CommonText('終了時間'),
                      titleFlex: 7,
                      contentItem: CommonText(startTime.toString() == 'null'
                          ? ''
                          : ('${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}')),
                    ),
                    widget.isBlank
                        ? PrimaryButton(
                            onTap: () {
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
                            text: '作成する',
                          )
                        : PrimaryButton(
                            onTap: () {
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
                            text: '更新する',
                          ),
                    // if (contents.isNotEmpty)
                    //   Expanded(
                    //     child: ListView.builder(
                    //       itemBuilder: (context, index) {
                    //         final content = contents[index];
                    //         return CommonText(content.content);
                    //       },
                    //       itemCount: contents.length,
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //     ),
                    //   )
                  ],
                ))));
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.onTap,
    required this.titleItem,
    this.contentItem,
    this.titleFlex = 8,
  });

  final Function() onTap;
  final Widget titleItem;
  final Widget? contentItem;
  final int titleFlex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.only(bottom: verticalPadding * 2),
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromRGBO(0, 0, 0, 0.5)),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Column(children: [
                  // Expanded(
                  Row(children: [
                    Expanded(
                      flex: titleFlex,
                      child: titleItem,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 10 - titleFlex,
                      child: contentItem ?? const SizedBox.shrink(),
                    ),
                  ]),
                  // )
                ]))));
  }
}
