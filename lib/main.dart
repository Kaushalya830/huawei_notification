import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:huawei_push/huawei_push.dart';
// import 'package:test_notification/new.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _size = 1.0;

  Map<String, dynamic> defaultNotification = <String, dynamic>{
    HMSLocalNotificationAttr.TITLE: 'Notification Title',
    HMSLocalNotificationAttr.MESSAGE: 'Notification Message',
    HMSLocalNotificationAttr.TICKER: 'Optional Ticker',
    HMSLocalNotificationAttr.SHOW_WHEN: true,
    // HMSLocalNotificationAttr.LARGE_ICON_URL: 'https://developer.huawei.com/Enexport/sites/default/images/en/Develop/hms/push/push2-tuidedao.png',
    HMSLocalNotificationAttr.LARGE_ICON: 'ic_launcher',
    // The notification small icon should be put under `android/app/res/mipmap` directory.
    HMSLocalNotificationAttr.SMALL_ICON: 'ic_notification',
    HMSLocalNotificationAttr.BIG_TEXT: 'This is a bigText',
    HMSLocalNotificationAttr.SUB_TEXT: 'This is a subText',
    HMSLocalNotificationAttr.COLOR: 'white',
    HMSLocalNotificationAttr.VIBRATE: false,
    HMSLocalNotificationAttr.VIBRATE_DURATION: 1000,
    HMSLocalNotificationAttr.TAG: 'hms_tag',
    HMSLocalNotificationAttr.GROUP_SUMMARY: false,
    HMSLocalNotificationAttr.ONGOING: false,
    HMSLocalNotificationAttr.IMPORTANCE: Importance.MAX,
    HMSLocalNotificationAttr.DONT_NOTIFY_IN_FOREGROUND: false,
    HMSLocalNotificationAttr.AUTO_CANCEL: false,
    HMSLocalNotificationAttr.ACTIONS: <String>[
      'Yes',
      'No',
    ],
    HMSLocalNotificationAttr.INVOKE_APP: false,
    HMSLocalNotificationAttr.DATA: Map<String, dynamic>.from(
      <String, dynamic>{
        'string_val': 'pushkit',
        'int_val': 15,
      },
    ),
    // HMSLocalNotificationAttr.CHANNEL_ID: 'huawei-hms-flutter-push-channel-id', // Please read the Android Documentation before using this param
  };

  String token = '';

  void _localNotification() async {
    try {
      Map<String, dynamic> notification = _constructNotificationMap();
      Map<String, dynamic> response = await Push.localNotification(
        notification,
      );
      /* showResult(
        'localNotification',
        response.toString(),
      ); */
    } catch (e) {
      /* showResult(
        'localNotificationError',
        e.toString(),
      ); */
    }
  }

  Future<void> getToken() async {
    getTokenStream();
    Push.getToken("");
    // final token = await Push.getTokenStream.toString();
    // print(token);
  }

  void getTokenStream() async {
    Push.getIntentStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  void _onTokenEvent(String event) {
    setState(() {
      token = event;
    });
    print("Token event " + token);
  }

  void _onTokenError(Object error) {
    // PlatformException e= error;
    print("TokenErrorEvent: " + error.toString());
  }

  //push listner
  void initPushListening() {
    Push.onMessageReceivedStream
        .listen(_onMessageReceived, onError: _onMessageReceiveError);
  }

  void _onMessageReceived(RemoteMessage remoteMessage) {
    print("Message Received");
    String? data = remoteMessage.getData;
    print(data);
  }

  void _onMessageReceiveError(Object error) {
    print("Message Receive Error: " + error.toString());
  }

  Map<String, dynamic> _constructNotificationMap() {
    Map<String, dynamic> notification = Map<String, dynamic>.from(
      defaultNotification,
    );
    notification[HMSLocalNotificationAttr.TAG] = "tagTextController.text";
    notification[HMSLocalNotificationAttr.TITLE] = "titleTextController.text";
    notification[HMSLocalNotificationAttr.BIG_TEXT] = "bigTextController.text";
    notification[HMSLocalNotificationAttr.SUB_TEXT] = "subTextController.text";
    notification[HMSLocalNotificationAttr.MESSAGE] = "msgTextController.text";
    return notification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        transform: Matrix4.diagonal3Values(_size, _size, 1.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                _localNotification();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blueGrey[100],
                child: const Text('press'),
              ),
            ),

            MaterialButton(
              onPressed: () {
                getToken();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue[200],
                child: const Text('getToken'),
              ),
            ),
            MaterialButton(
              onPressed: () {
                initPushListening();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blueGrey[100],
                child: const Text('start push listening'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
