import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/addTodo/addTodo_model.dart';

class AddTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTodoModel>(
      create: (_) => AddTodoModel(),
      child: InsideAddTodo(),
    );
  }
}

class InsideAddTodo extends StatelessWidget {
  final TextEditingController _todoTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodoModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(title: Text('New Schedule')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _todoTitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "予定の内容",
                ),
                onChanged: (value) {
                  model.title = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                focusNode: FocusNode(),
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Date",
                ),
                onTap: () async {
                  final DateTime _selectDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                  );

                  if (_selectDate != null) {
                    _dateController.text = DateFormat.yMd().format(_selectDate);
                    model.selectDate = _selectDate;
                  }
                },
                readOnly: true,
              ),
              SizedBox(height: 16),
              TextField(
                focusNode: FocusNode(),
                controller: _timeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Time",
                ),
                onTap: () async {
                  final TimeOfDay _selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (_selectTime != null) {
                    _timeController.text = formatDate(
                        DateTime(
                            2021, 04, 26, _selectTime.hour, _selectTime.minute),
                        [hh, ':', nn, " ", am]).toString();
                    model.selectTime = _selectTime;
                  }
                },
                readOnly: true,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (model.title == null) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('予定の内容がないです。'),
                  content: Text('予定の内容を記入してください'),
                  actions: [
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog'),
                    ),
                  ],
                ),
              );
              return;
            }
            await model.notificationAndAddData();
            Navigator.pop(context);
          },
          label: Text('追加する'),
          icon: Icon(Icons.cloud),
          backgroundColor: Colors.deepOrange,
        ),
      );
    });
  }
}
