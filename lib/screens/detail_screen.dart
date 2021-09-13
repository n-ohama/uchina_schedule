import 'package:flutter/material.dart';
import 'package:uchina_schedule/freezed/todo.dart';
import 'package:uchina_schedule/model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            // if (_titleController.text.trim().isEmpty)
            if (_titleController.text != todo.title) {
              context.read(todoListProvider.notifier).updateItem(todo.id, _titleController.text);
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
