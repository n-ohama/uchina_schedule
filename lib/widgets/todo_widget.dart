import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:uchina_schedule/freezed/todo.dart';
import 'package:uchina_schedule/model/providers.dart';
import 'package:uchina_schedule/screens/detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoWidget extends StatelessWidget {
  final List<Todo> todoList;
  final BuildContext ctx;
  TodoWidget({required this.todoList, required this.ctx});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (_, i) {
        final todo = todoList[i];
        return Slidable(
          actionPane: SlidableBehindActionPane(),
          child: InkWell(
            onTap: () {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => DetailScreen(todo: todo)));
            },
            child: Padding(
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
                    color: todo.favorite ? Colors.teal[100] : null,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.read(todoListProvider.notifier).toggleFavorite(todo.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Icon(Icons.star_outline_rounded, color: Colors.black45),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                              child: Text(todo.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16), maxLines: 1)),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: todo.schedule != null ? 4 : 16),
                              child: Row(
                                children: [
                                  Icon(Icons.settings_suggest_outlined, size: 16, color: Colors.teal),
                                  SizedBox(width: 4),
                                  Text('日付'),
                                ],
                              ),
                            ),
                            onLongPress: () {
                              if (todo.schedule == null) return;
                              showDialog(
                                  context: context,
                                  builder: (_ctx) => AlertDialog(content: Text('日付を削除しますか？'), actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(_ctx).pop();
                                            },
                                            child: Text('キャンセル')),
                                        TextButton(
                                            onPressed: () {
                                              context.read(todoListProvider.notifier).changeSchedule(todo.id, null);
                                              Navigator.of(_ctx).pop();
                                            },
                                            child: Text('削除')),
                                      ]));
                            },
                            onTap: () async {
                              final now = DateTime.now();
                              final date = await showDatePicker(
                                context: context,
                                locale: const Locale("ja"),
                                initialDate: todo.schedule ?? now,
                                firstDate: DateTime(now.year, now.month, now.day),
                                lastDate: DateTime(now.year + 2),
                              );

                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: todo.schedule != null
                                      ? TimeOfDay(hour: todo.schedule!.hour, minute: todo.schedule!.minute)
                                      : TimeOfDay.now(),
                                );

                                if (time != null) {
                                  final finalDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                                  context.read(todoListProvider.notifier).changeSchedule(todo.id, finalDate);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      if (todo.schedule != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                todo.schedule != null ? '${DateFormat('MM月dd日 : HH時mm分').format(todo.schedule!)}' : '',
                                style: TextStyle(color: Colors.black38, fontSize: 12),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (todo.schedule != null)
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            todo.notify ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                                            color: Colors.teal,
                                            size: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text('通知'),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      context.read(todoListProvider.notifier).toggleNotify(todo.id);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: '削除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    content: Text('スケジュールを削除しますか？'),
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
                          context.read(todoListProvider.notifier).deleteItem(todo);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
