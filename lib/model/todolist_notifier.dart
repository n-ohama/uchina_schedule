import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchina_schedule/freezed/todo.dart';
import 'package:uchina_schedule/model/notification_api.dart';
import 'package:uchina_schedule/model/shared_model.dart';

class TodolistNotifier extends StateNotifier<List<Todo>> {
  TodolistNotifier() : super([]);

  void addItem(Todo todo) {
    state = [todo, ...state];
    _save();
  }

  void deleteItem(Todo todo) {
    if (todo.notify) {
      NotificationApi.cancelNotification(id: todo.id);
    }
    state = state.where((_todo) => _todo.id != todo.id).toList();
    _save();
  }

  void updateItem(int id, String title) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(title: title) else todo
    ];
    _save();
  }

  void toggleFavorite(int id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(favorite: !todo.favorite) else todo
    ];
    _save();
  }

  void changeSchedule(int id, DateTime? schedule) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(schedule: schedule) else todo
    ];
    _save();
  }

  void toggleNotify(int id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(notify: !todo.notify) else todo
    ];
    _save();
    final i = state.indexWhere((todo) => todo.id == id);
    if (state[i].notify) {
      NotificationApi.showScheduledNotification(
        id: state[i].id,
        title: 'ウチナースケジュール',
        body: state[i].title,
        payload: 'Notification',
        scheduledDate: state[i].schedule!,
      );
    } else {
      NotificationApi.cancelNotification(id: state[i].id);
    }
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('myData') ?? [];
    if (data.length > 0) {
      state = data.map((e) {
        final todo = jsonDecode(e);

        if (todo['schedule'] != null) {
          final schedule = DateTime.parse(todo['schedule']);
          if (schedule.isBefore(DateTime.now())) {
            todo['notify'] = false;
          }
        }

        return Todo(
          id: todo['id'],
          title: todo['title'],
          create: DateTime.parse(todo['create']),
          schedule: todo['schedule'] == null ? null : DateTime.parse(todo['schedule']),
          notify: todo['notify'],
          favorite: todo['favorite'],
        );
      }).toList();
    }
  }

  void _save() {
    final todoList = state.map((e) {
      final todo = e.toJson();
      todo['create'] = todo['create'].toString();
      if (todo['schedule'] != null) todo['schedule'] = todo['schedule'].toString();
      return jsonEncode(todo);
    }).toList();
    SharedModel().saveData(todoList);
  }
}
