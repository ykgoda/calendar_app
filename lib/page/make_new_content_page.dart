import 'package:calendar_app/common/appbar.dart';
import 'package:calendar_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import '../common/text.dart';
import '../type/type.dart';
import '../collections/date_content.dart';

const _sectionMargin = EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16);

class MakeNewContentPage extends ConsumerStatefulWidget {
  const MakeNewContentPage(
      {super.key,
      required this.date,
      required this.addContents,
      required this.updateContents,
      required this.deleteContents,
      required this.isBlank,
      required this.content});

  final Date date;
  final Function addContents;
  final Function updateContents;
  final Function deleteContents;
  final bool isBlank;
  final DateContent content;

  @override
  MakeNewContentPageState createState() => MakeNewContentPageState();
}

class MakeNewContentPageState extends ConsumerState<MakeNewContentPage> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Color selectedColor = Colors.black;
  String selectedColorToString = Colors.black.value.toRadixString(16);
  String text = '';
  List<String> errorList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      startTime = DateTime(widget.date.year, widget.date.month,
          widget.date.date, DateTime.now().hour, DateTime.now().minute);
      endTime = DateTime(widget.date.year, widget.date.month, widget.date.date,
          DateTime.now().hour, DateTime.now().minute);
    });

    if (!widget.isBlank) {
      setState(() {
        startTime = widget.content.startTime;
        endTime = widget.content.endTime;
        selectedColor = Color(int.parse(widget.content.color, radix: 16));
        selectedColorToString = widget.content.color;
        text = widget.content.content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> validateItem() async {
      if (text.isEmpty) {
        setState(() {
          errorList.add('タイトルを入力してください');
        });
      }

      if (startTime.hour > endTime.hour ||
          (startTime.hour == endTime.hour &&
              startTime.minute > endTime.minute)) {
        setState(() {
          errorList.add('終了時刻を開始時刻の後にしてください');
        });
      }
    }

    void showErrorDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: CommonText(
                widget.isBlank ? '作成できません' : '更新できません',
                fontSize: 18,
              ),
              content: Column(
                children: [
                  for (final error in errorList)
                    CommonText(
                      error,
                      overflow: TextOverflow.clip,
                      fontSize: 12,
                    ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      errorList = [];
                    });
                  },
                  child: const Text(
                    '確認',
                  ),
                ),
              ],
            );
          },
          barrierDismissible: false);
    }

    return Scaffold(
        appBar: CommonAppBar(
          widget.isBlank ? '新規作成' : '更新する',
          actions: [
            TextButton(
                onPressed: () async {
                  await validateItem();
                  if (errorList.isNotEmpty) {
                    showErrorDialog();
                    return;
                  }
                  if (widget.isBlank) {
                    final DateContent newContent = DateContent();
                    final setDate = DateTime(
                        widget.date.year, widget.date.month, widget.date.date);
                    final colorToRadixString =
                        selectedColor.value.toRadixString(16);
                    newContent
                      ..content = text
                      ..startTime = startTime
                      ..endTime = endTime
                      ..color = colorToRadixString
                      ..date = setDate;
                    ref
                        .watch(dateContentHandler)
                        .addContent(content: newContent);

                    widget.addContents(newContent);

                    Navigator.pop(context);
                  } else {
                    ref.watch(dateContentHandler).updateContent(
                        startTime: startTime,
                        endTime: endTime,
                        color: selectedColorToString,
                        text: text,
                        content: widget.content);
                    final DateContent newContent = DateContent();
                    final setDate = DateTime(
                        widget.date.year, widget.date.month, widget.date.date);
                    newContent
                      ..content = text
                      ..startTime = startTime
                      ..endTime = endTime
                      ..color = selectedColorToString
                      ..date = setDate;
                    widget.updateContents(newContent);

                    Navigator.pop(context);
                  }
                },
                child: CommonText(widget.isBlank ? '作成' : '更新'))
          ],
        ),
        body: SettingsList(sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                title: TextFormField(
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
            ],
            margin: _sectionMargin,
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                title: const CommonText('カラー'),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('カラーを選択'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: selectedColor,
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
                trailing: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor,
                  ),
                ),
              )
            ],
            margin: _sectionMargin,
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                title: const CommonText('開始時刻'),
                onPressed: (context) {
                  DatePicker.showTimePicker(context,
                      currentTime: DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.date,
                          DateTime.now().hour,
                          DateTime.now().minute),
                      showSecondsColumn: false,
                      locale: LocaleType.jp, onConfirm: (time) {
                    setState(() {
                      startTime = time;
                    });
                  });
                },
                trailing: CommonText(
                    ('${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}')),
              )
            ],
            margin: _sectionMargin,
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                title: const CommonText('終了時刻'),
                onPressed: (context) {
                  DatePicker.showTimePicker(context,
                      currentTime: DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.date,
                          DateTime.now().hour,
                          DateTime.now().minute),
                      showSecondsColumn: false,
                      locale: LocaleType.jp, onConfirm: (time) {
                    setState(() {
                      endTime = time;
                    });
                  });
                },
                trailing: CommonText(
                    ('${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}')),
              ),
            ],
            margin: _sectionMargin,
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                title: const CommonText(
                  '削除する',
                  color: Colors.red,
                ),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const CommonText(
                            'この予定を削除しますか？',
                            fontSize: 18,
                          ),
                          content: const CommonText(
                            'この操作は取り消せません',
                            fontSize: 14,
                            overflow: TextOverflow.clip,
                          ),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                '戻る',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text(
                                '削除',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                ref
                                    .watch(dateContentHandler)
                                    .deleteContent(widget.content);
                                widget.deleteContents(widget.content);
                                Navigator.of(context).popUntil((route) =>
                                    route.settings.name ==
                                    '${widget.date.year}-${widget.date.month}-${widget.date.date}');
                              },
                            )
                          ],
                        );
                      });
                },
              )
            ],
            margin: _sectionMargin,
          ),
        ]));
  }
}
