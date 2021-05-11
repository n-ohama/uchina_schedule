import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListModel extends ChangeNotifier {
  List<TodoList> todoList = [];
  String updateTitle;
  String myUid;
  // String userEmail;

  // Future<void> getUserEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   this.userEmail = prefs.getString('email') ?? 'noEmail';
  // }

  // Future<void> signOut() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('firebaseUid');
  //   await FirebaseAuth.instance.signOut();
  // }

  Future<void> getTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate =
        DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    this.myUid = prefs.getString('uid') ?? 'noUid';
    if (this.myUid == 'noUid') {
      await prefs.setString('uid', formattedDate);
      this.myUid = prefs.getString('uid');
      print(this.myUid);
    }

    final snapshots = FirebaseFirestore.instance
        .collection('users')
        .doc(this.myUid)
        .collection('todos')
        .orderBy('createdAt')
        .snapshots();
    snapshots.listen((snapshot) {
      final fireTodoList = snapshot.docs.map((doc) => TodoList(doc)).toList();
      this.todoList = fireTodoList;
      notifyListeners();
    });
  }

  Future<void> deleteTodo(String todoDocumentId) async {
    final selectedTodo =
        todoList.singleWhere((e) => e.documentReference.id == todoDocumentId);
    selectedTodo.isDone = true;
    notifyListeners();
    final deleteItem = FirebaseFirestore.instance
        .collection('users')
        .doc(this.myUid)
        .collection('todos')
        .doc(todoDocumentId);
    final DocumentSnapshot deleteItemArray = await deleteItem.get();
    final int deleteNotificationId = deleteItemArray.data()['notificationId'];
    await deleteItem.delete();
    await FlutterLocalNotificationsPlugin().cancel(deleteNotificationId);
  }

  Future<void> updateTodo(todoDocumentId) async {
    final updateTodo = FirebaseFirestore.instance
        .collection('users')
        .doc(this.myUid)
        .collection('todos')
        .doc(todoDocumentId);
    await updateTodo.update({"title": updateTitle});
    updateTitle = null;
  }
}

class TodoList {
  TodoList(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    this.title = doc.data()['title'];
    this.alertDate = doc.data()['alertDate'];
  }

  String title;
  bool isDone = false;
  Timestamp alertDate;
  DocumentReference documentReference;
}
