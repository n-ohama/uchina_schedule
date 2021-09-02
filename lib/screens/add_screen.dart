import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/model/shared_model.dart';
import 'package:uchina_schedule/model/todo.dart';
import 'package:uchina_schedule/model/todos.dart';
import 'package:uuid/uuid.dart';

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
              final notificationId = await SharedModel().getUniqueId();
              final Todo todo = Todo(
                id: Uuid().v1(),
                title: titleController.text,
                createdAt: DateTime.now(),
                notificationId: notificationId,
              );
              Provider.of<Todos>(context, listen: false).addItem(todo);
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: TextField(
          controller: titleController,
          autofocus: true,
          maxLines: 100,
          keyboardType: TextInputType.multiline,
          cursorHeight: 25,
          // decoration: InputDecoration(
          //   hintText: 'スケジュール',
          //   labelText: 'スケジュール',
          //   border: OutlineInputBorder(),
          // ),
        ),
      ),
    );
  }
}

// Stack(
//   children: [
//     Align(
//       alignment: Alignment.topCenter,
//       child: Text(
//         'スケジュール',
//         style: TextStyle(
//           color: Theme.of(context).primaryColor,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     Align(
//       alignment: Alignment.topRight,
//       child: IconButton(
//         icon: Icon(Icons.close),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//     ),
//   ],
// ),