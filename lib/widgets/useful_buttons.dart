import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/model/todo.dart';
import 'package:uchina_schedule/model/todos.dart';

class UsefulButtons extends StatelessWidget {
  const UsefulButtons({
    Key? key,
    required this.todoList,
    required this.index,
  }) : super(key: key);

  final List<Todo> todoList;
  final int index;

  @override
  Widget build(BuildContext context) {
    final todo = todoList[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            todo.scheduleDate == null
                ? ''
                : '${DateFormat('MM月dd日 : HH時mm分').format(todo.scheduleDate!)}',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.settings_suggest_outlined, size: 16),
                  SizedBox(width: 4),
                  Text('日付'),
                ],
              ),
              onLongPress: () {
                if (todo.scheduleDate != null) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('日付の削除'),
                      content: Text('この予定の日付を削除しますか？'),
                      actions: [
                        TextButton(
                          child: Text('キャンセル'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        TextButton(
                          child: Text('削除'),
                          onPressed: () {
                            Provider.of<Todos>(context, listen: false).deleteCalender(todo.id);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              onPressed: () async {
                final DateTime? scheduledDate = todo.scheduleDate;
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: scheduledDate ?? now,
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: DateTime(now.year + 2),
                );

                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: scheduledDate != null
                        ? TimeOfDay(
                            hour: scheduledDate.hour,
                            minute: scheduledDate.minute,
                          )
                        : TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    final pickedDateTime = DateTime(pickedDate.year, pickedDate.month,
                        pickedDate.day, pickedTime.hour, pickedTime.minute);

                    Provider.of<Todos>(context, listen: false).setCalendar(todo.id, pickedDateTime);
                  }
                }
              },
            ),
            SizedBox(width: 8),
            TextButton(
              child: Row(
                children: [
                  todo.isNotify
                      ? Icon(
                          Icons.check_box,
                          color: Colors.teal,
                          size: 20,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.black45,
                          size: 20,
                        ),
                  SizedBox(width: 4),
                  Text('通知'),
                ],
              ),
              onPressed: () {
                if (todo.scheduleDate != null && todo.scheduleDate!.isAfter(DateTime.now())) {
                  Provider.of<Todos>(context, listen: false).toggleIsNotify(todo.id);
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('通知を設定するため'),
                      content:
                          Text(todo.scheduleDate == null ? '日付を設定してください' : '日付を現在より後の日付に設定してください'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}
