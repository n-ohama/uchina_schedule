import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class AddTodoModel extends ChangeNotifier {
  DateTime selectDate = DateTime.now();
  TimeOfDay selectTime = TimeOfDay.now();
  String title;
  int _uniqueNum;

  // firestoreに予定を追加する
  Future<void> notificationAndAddData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myUid = prefs.getString('firebaseUid');

    _uniqueNum = (prefs.getInt('uniqueNum') ?? 0) + 1;
    prefs.setInt('uniqueNum', _uniqueNum);
    final justNow = DateTime.now();

    DateTime scheduledDateTime = DateTime(selectDate.year, selectDate.month,
            selectDate.day, selectTime.hour, selectTime.minute, justNow.second)
        .add(Duration(seconds: 5));

    if (scheduledDateTime.isBefore(justNow))
      scheduledDateTime = justNow.add(Duration(seconds: 5));

    tz.TZDateTime tzScheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.getLocation('Asia/Tokyo'));
    // print(tzScheduledDate);

    try {
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        _uniqueNum,
        title,
        'Local Notification',
        tzScheduledDate,
        NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      print(e);
    }

    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('todos');

    await collection
        .add({
          'title': title,
          'createdAt': DateTime.now(),
          'notificationId': _uniqueNum,
          'alertDate': DateTime(selectDate.year, selectDate.month,
              selectDate.day, selectTime.hour, selectTime.minute)
        })
        .then((value) => null)
        .catchError((error) => print("Failed to add todo: $error"));
  }
}
