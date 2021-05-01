import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/addTodo/addTodo_page.dart';
import 'package:uchina_schedule/list/list_model.dart';

class ListPage extends StatelessWidget {
  String formattedDate(DateTime date) {
    return '${date.month}月${date.day}日${date.hour}時${date.minute}分';
  }

  final TextEditingController _updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..getTodoList(),
      child: Consumer<ListModel>(builder: (context, model, child) {
        final todoList = model.todoList;
        // IconButton(
        //   icon: Icon(Icons.logout),
        //   onPressed: () {
        //     model.signOut();
        //   },
        // ),

        final List _items = [
          'HELP',
          'SIGNOUT',
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text('予定リスト🍜'),
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) => _items
                    .map(
                      (item) => PopupMenuItem(
                        child: Text(item),
                        value: item,
                      ),
                    )
                    .toList(),
                onSelected: (item) {
                  if (item == 'HELP')
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Help Me'),
                        actions: [
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    );
                  if (item == 'SIGNOUT') model.signOut();
                },
              ),
            ],
          ),
          body: todoList.length == 0
              ? Container(
                  alignment: Alignment.center,
                  child: Text('No List'),
                )
              : Container(
                  padding: EdgeInsets.only(top: 8),
                  child: ListView.separated(
                    itemBuilder: (context, index) => Slidable(
                      child: ListTile(
                        title: Text(todoList[index].title),
                        subtitle: Text(
                            formattedDate(todoList[index].alertDate.toDate())),
                      ),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'EDIT',
                          color: Colors.black45,
                          icon: Icons.more_horiz,
                          onTap: () {
                            _updateController.text = '';
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('予定内容の変更'),
                                content: TextFormField(
                                  controller: _updateController,
                                  onChanged: (value) =>
                                      model.updateTitle = value,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black54,
                                    ),
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop('dialog'),
                                    child: Text('キャンセル'),
                                  ),
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () async {
                                      if (_updateController.text == '' ||
                                          model.updateTitle == null) return;
                                      await model.updateTodo(
                                          todoList[index].documentReference.id);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconSlideAction(
                          caption: 'DELETE',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => model
                              .deleteTodo(todoList[index].documentReference.id),
                        )
                      ],
                    ),
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.black45),
                    itemCount: todoList.length,
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTodoPage(),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
