import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchina_schedule/model/providers.dart';
import 'package:uchina_schedule/screens/add_screen.dart';
import 'package:uchina_schedule/widgets/todo_widget.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    context.read(todoListProvider.notifier).fetchData().then((_) {
      context.read(isLoading).state = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('予定リスト')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddScreen()));
        },
      ),
      body: Consumer(
        builder: (_, watch, __) {
          final todoList = watch(todoListProvider);
          final _isLoading = watch(isLoading).state;
          return todoList.length == 0
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/bgImage.png'))),
                  child: Text(_isLoading ? '' : '下の+ボタンから予定を追加'),
                )
              : Container(
                  padding: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/bgImage.png'))),
                  child: TodoWidget(todoList: todoList, ctx: context),
                );
        },
      ),
    );
  }
}
