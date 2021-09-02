import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/model/todo.dart';
import 'package:uchina_schedule/model/todos.dart';

class MyCard extends StatelessWidget {
  const MyCard({required this.todoList, required this.index});

  final List<Todo> todoList;
  final int index;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final todo = todoList[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
      child: Material(
        elevation: 1,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: _width,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: todo.isFavorite ? Colors.teal[100] : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<Todos>(context, listen: false).toggleIsFavorite(todo.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.star_outline_rounded, color: Colors.black45),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Text(todo.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16), maxLines: 1)),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: todo.scheduleDate != null ? 4 : 16),
                      child: Row(
                        children: [
                          Icon(Icons.settings_suggest_outlined, size: 16, color: Colors.teal),
                          SizedBox(width: 4),
                          Text('日付'),
                        ],
                      ),
                    ),
                    onLongPress: () {
                      deleteSchedule(context, todo.scheduleDate, todo.id);
                    },
                    onTap: () async {
                      setSchedule(context, todo.scheduleDate, todo.id);
                    },
                  ),
                ],
              ),
              if (todo.scheduleDate != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        todo.scheduleDate != null ? '${DateFormat('MM月dd日 : HH時mm分').format(todo.scheduleDate!)}' : '',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (todo.scheduleDate != null)
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    todo.isNotify ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text('通知'),
                                ],
                              ),
                            ),
                            onTap: () {
                              toggleNotify(context, todo.scheduleDate, todo.id);
                            },
                          ),
                        // SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleNotify(BuildContext context, DateTime? schedule, String id) {
    if (schedule!.isAfter(DateTime.now())) {
      Provider.of<Todos>(context, listen: false).toggleIsNotify(id);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('通知を設定するため'),
          content: Text('日付を現在より後の日付に設定してください'),
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
  }

  void deleteSchedule(BuildContext context, DateTime? schedule, String id) {
    if (schedule != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('日付の削除'),
          content: Text('このスケジュールの日付を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<Todos>(context, listen: false).deleteCalender(id);
                Navigator.of(context).pop();
              },
              child: Text('削除'),
            ),
          ],
        ),
      );
    }
  }

  void setSchedule(BuildContext context, DateTime? schedule, String id) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      locale: const Locale("ja"),
      initialDate: schedule ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: schedule != null ? TimeOfDay(hour: schedule.hour, minute: schedule.minute) : TimeOfDay.now(),
      );

      if (time != null) {
        final pickedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        Provider.of<Todos>(context, listen: false).setCalendar(id, pickedDateTime);
      }
    }
  }
}
