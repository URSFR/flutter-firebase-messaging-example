import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'env/env.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  String FCMToken = "";

  initializeFCM(){
    listenToMessages();
    receiveMessage();
  }

  listenToMessages() async {
    FCMToken = (await FirebaseMessaging.instance.getToken())!;

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      // This callback is fired at each app startup and whenever a new token is generated.
      print("MY TOKEN $fcmToken");

      FCMToken = fcmToken;
    })
        .onError((err) {
      print(err);
      // Error getting token.
    });
  }

  sendMessage({required String textMessage}) async {
    final url = 'https://fcm.googleapis.com/fcm/send';

    var response =
    await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=${Env.serverKey}",
        },
        body: jsonEncode(<String, dynamic>{
          "data":<String, dynamic>{
            "click_action": 'FLUTTER_NOTIFICATION_CLICK',
            "status":"done",
            "body": textMessage,
            "title": "NOTIFICATION",
          },
          "notification": {
            "title": "NOTIFICATION",
            "text": textMessage,
            // "sound": "default",
            // "color": "#990000",
          },
          "priority": "high",
          // "to" can be to a topic or a FCM Token
          "to": FCMToken,
        }));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  receiveMessage() async {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //HERE DETECTS THE MESSAGE SO YOU CAN INSERT A NOTIFICATION, IN THIS EXAMPLE WE USE GET.SNACKBAR()
      print('Got a message whilst in the foreground!');

      if (message.data.isNotEmpty) {

        print(message.data);

        //HERE
        Get.snackbar("NOTIFICATION", message.data["body"]);
      }
    });
  }


}

