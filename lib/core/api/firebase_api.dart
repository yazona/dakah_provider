import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class FirebaseAPI {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  static Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // await FirebaseMessaging.instance.subscribeToTopic('globalstopic');
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
        badge: true,
        alert: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false);
    initPushNotification();
  }
}
