import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchina_schedule/freezed/todo.dart';
import 'package:uchina_schedule/model/todolist_notifier.dart';

final todoListProvider = StateNotifierProvider<TodolistNotifier, List<Todo>>(
  (ref) => TodolistNotifier(),
);

final isLoading = StateProvider((ref) => true);
