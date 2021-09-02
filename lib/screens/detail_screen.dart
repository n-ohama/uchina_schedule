import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/model/todos.dart';
import 'package:uchina_schedule/model/todo.dart';

class DetailScreen extends StatefulWidget {
  final Todo todo;
  DetailScreen({required this.todo});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    final _titleController = TextEditingController(text: todo.title);
    return Scaffold(
      appBar: AppBar(
        title: Text('編集'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) {
              // 削除のダイアログ
            } else {
              final Todo newtodo = Todo(
                id: todo.id,
                title: _titleController.text,
                createdAt: todo.createdAt,
                notificationId: todo.notificationId,
                scheduleDate: todo.scheduleDate,
                isNotify: todo.isNotify,
                isFavorite: todo.isFavorite,
              );
              if (_titleController.text != todo.title) {
                Provider.of<Todos>(context, listen: false).updateItem(newtodo);
              }
            }

            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: TextField(
          controller: _titleController,
          maxLines: 100,
          keyboardType: TextInputType.multiline,
          cursorHeight: 25,
        ),
      ),
    );
  }
}
