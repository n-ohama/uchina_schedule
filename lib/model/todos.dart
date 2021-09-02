import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uchina_schedule/model/notification_api.dart';
import 'package:uchina_schedule/model/shared_model.dart';
import 'package:uchina_schedule/model/todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _items = [];
  List<Todo> get items => [..._items];

  Future<void> fetchItems() async {
    final todoList = await SharedModel().getData();
    if (todoList.length > 0) {
      todoList.forEach((todo) {
        final todoMap = jsonDecode(todo!);
        final Todo completedTodo = Todo(
          id: todoMap['id'],
          title: todoMap['title'],
          createdAt: DateTime.parse(todoMap['createdAt']),
          notificationId: todoMap['notificationId'],
          scheduleDate: todoMap['scheduleDate'] != null ? DateTime.parse(todoMap['scheduleDate']) : null,
          isNotify: todoMap['scheduleDate'] != null && DateTime.parse(todoMap['scheduleDate']).isAfter(DateTime.now())
              ? todoMap['isNotify']
              : false,
          isFavorite: todoMap['isFavorite'],
        );
        _items.add(completedTodo);
      });
      notifyListeners();
    }
  }

  void _saveToDevice() {
    List<String> todoList = [];
    _items.forEach((todo) {
      final todoMap = {
        'id': todo.id,
        'title': todo.title,
        'createdAt': todo.createdAt.toString(),
        'notificationId': todo.notificationId,
        'scheduleDate': todo.scheduleDate != null ? todo.scheduleDate.toString() : null,
        'isNotify': todo.isNotify,
        'isFavorite': todo.isFavorite,
      };
      todoList.add(jsonEncode(todoMap));
    });
    SharedModel().saveData(todoList);
  }

  void addItem(Todo todo) {
    _items.insert(0, todo);
    notifyListeners();
    _saveToDevice();
  }

  void removeItem(String id) {
    final index = _items.indexWhere((target) => target.id == id);
    final notificationId = _items[index].notificationId;
    if (_items[index].isNotify) {
      NotificationApi.cancelNotification(id: notificationId);
    }
    _items.removeWhere((target) => target.id == id);
    notifyListeners();
    _saveToDevice();
  }

  void updateItem(Todo todo) {
    final index = _items.indexWhere((target) => target.id == todo.id);
    _items[index] = todo;
    notifyListeners();
    _saveToDevice();
  }

  void setCalendar(String id, DateTime scheduleDate) {
    final index = _items.indexWhere((todo) => todo.id == id);
    final Todo newTodo = Todo(
      id: _items[index].id,
      title: _items[index].title,
      createdAt: _items[index].createdAt,
      notificationId: _items[index].notificationId,
      scheduleDate: scheduleDate,
      isNotify: _items[index].isNotify,
      isFavorite: _items[index].isFavorite,
    );
    _items[index] = newTodo;
    notifyListeners();
    _saveToDevice();
  }

  void deleteCalender(String id) {
    final index = _items.indexWhere((todo) => todo.id == id);
    final Todo newTodo = Todo(
      id: _items[index].id,
      title: _items[index].title,
      createdAt: _items[index].createdAt,
      notificationId: _items[index].notificationId,
      scheduleDate: null,
      isNotify: _items[index].isNotify,
      isFavorite: _items[index].isFavorite,
    );
    _items[index] = newTodo;
    notifyListeners();
    _saveToDevice();
  }

  void toggleIsNotify(String id) {
    final index = _items.indexWhere((todo) => todo.id == id);
    final reverseIsNotify = !_items[index].isNotify;
    final Todo newTodo = Todo(
      id: _items[index].id,
      title: _items[index].title,
      createdAt: _items[index].createdAt,
      notificationId: _items[index].notificationId,
      scheduleDate: _items[index].scheduleDate,
      isNotify: reverseIsNotify,
      isFavorite: _items[index].isFavorite,
    );
    _items[index] = newTodo;
    notifyListeners();
    _saveToDevice();
    if (newTodo.scheduleDate != null && reverseIsNotify) {
      NotificationApi.showScheduledNotification(
        id: newTodo.notificationId,
        title: 'ウチナースケジュール',
        body: newTodo.title,
        payload: 'Notification',
        scheduledDate: newTodo.scheduleDate!,
      );
    } else {
      NotificationApi.cancelNotification(id: newTodo.notificationId);
    }
  }

  void toggleIsFavorite(String id) {
    final index = _items.indexWhere((todo) => todo.id == id);
    final reverseIsFavorite = !_items[index].isFavorite;
    final Todo newTodo = Todo(
      id: _items[index].id,
      title: _items[index].title,
      createdAt: _items[index].createdAt,
      notificationId: _items[index].notificationId,
      scheduleDate: _items[index].scheduleDate,
      isNotify: _items[index].isNotify,
      isFavorite: reverseIsFavorite,
    );
    _items[index] = newTodo;
    notifyListeners();
    _saveToDevice();
  }
}
