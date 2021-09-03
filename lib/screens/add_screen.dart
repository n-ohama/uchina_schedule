import 'package:flutter/material.dart';
import 'package:uchina_schedule/model/providers.dart';
import 'package:uchina_schedule/model/shared_model.dart';
import 'package:uchina_schedule/freezed/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (titleController.text.trim().isNotEmpty) {
              final id = await SharedModel().getUniqueId();
              final Todo todo = Todo(
                id: id,
                title: titleController.text,
                create: DateTime.now(),
              );
              context.read(todoListProvider.notifier).addItem(todo);
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: titleController,
          autofocus: true,
          maxLines: 100,
          keyboardType: TextInputType.multiline,
          cursorHeight: 25,
        ),
      ),
    );
  }
}
