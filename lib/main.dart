// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';

import 'package:uchina_schedule/list/list_page.dart';

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Local_Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TimeOfDay selectTime;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final iOS = IOSInitializationSettings();
    final initAndroid = AndroidInitializationSettings('app_icon');
    final initSettings = InitializationSettings(iOS: iOS, android: initAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
    initUid();
  }

  Future<void> initUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? 'noUid';
    final uuidInstance = Uuid();
    final String uuid = uuidInstance.v4();
    if (uid == 'noUid') {
      await prefs.setString('uid', uuid);
    }
  }

  // ignore: missing_return
  Future onSelectNotification(String payload) {
    if (payload != null) {
      print(payload);
    }
  }

  Future<void> printTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? 'noUid';
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    // return ListPage();
    return Scaffold(
      appBar: AppBar(
        title: Text('hoge'),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text('Check prefsUid'),
            onPressed: () => printTest(),
          ),
        ),
      ),
    );
    // return MultiProvider(
    //   providers: [
    //     Provider<MainModel>(
    //       create: (_) => MainModel(FirebaseAuth.instance),
    //     ),
    //     StreamProvider(
    //       create: (context) => context.read<MainModel>().authStateChanges,
    //     )
    //   ],
    //   child: AuthCheckWrapper(),
    // );
  }
}

// class AuthCheckWrapper extends StatelessWidget {
//   _setPrefItems(String key, String value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User>();

//     if (firebaseUser != null) {
//       _setPrefItems('firebaseUid', firebaseUser.uid);
//       _setPrefItems('firebaseEmail', firebaseUser.email);
//       return ListPage();
//     }
//     return LoginPage();
//   }
// }

// class MainModel {
//   final FirebaseAuth _firebaseAuth;
//   MainModel(this._firebaseAuth);

//   Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
// }
