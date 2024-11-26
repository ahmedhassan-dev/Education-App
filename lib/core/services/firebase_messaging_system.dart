import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FireBaseMessagingSystem {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<AuthorizationStatus> getPermissionStatus() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return (await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    ))
        .authorizationStatus;
  }

  static setMessagingInBackGround() {
    FirebaseMessaging.onBackgroundMessage(notificationHandlerForeGround);
  }

  static setMessagingInForeGround() {
    FirebaseMessaging.onMessage.listen(notificationHandlerForeGround);
  }

  static setOnClickMessaging() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("setOnClickMessaging");
      debugPrint(message.data.toString());
      // Log.d("setOnClickMessaging");

      // LayoutCubit cubit =
      //     AppConstants.navigatorKey.currentContext!.read<LayoutCubit>();
      // cubit.changePage(3);
      // AppConstant.navigatorKey.currentState!.context
      //     .go(AppConstant.mainDir, extra: {"notification": true});
    });
  }

  // static Future<void> _notificationHandler(
  //   RemoteMessage message,
  // ) async {
  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'medical.rep', // id
  //     'High Importance Notifications', // title// description
  //     importance: Importance.max,
  //   );

  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);

  //   if (message.notification != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         message.notification.hashCode,
  //         message.notification!.title,
  //         message.notification!.body,
  //         NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               icon: "@mipmap/launcher_icon",
  //               channel.id,
  //               channel.name,
  //               channelDescription: channel.description,
  //               // other properties...
  //             ),
  //             iOS: const DarwinNotificationDetails(
  //               presentAlert: true,
  //             )));
  //   }
  // }
  // foreground
  static Future<void> notificationHandlerForeGround(
    RemoteMessage remoteMessage,
  ) async {
    // debugPrint("Amr");
    // Log.d("setOnClickMessagingsssss");
    // Log.d(remoteMessage.data.toString());
    // Log.d(remoteMessage.notification?.body?.toString() ?? "");
    // Log.d(remoteMessage.notification?.title?.toString() ?? "");

    // AppConstants.navigatorKey.currentContext!.go(
    //   RouteConstants.chat,
    //   extra: {
    //     "order": Orders(),
    //     "remoteMessage": remoteMessage,
    //   },
    // );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'tamra', // id
      'High Importance Notifications', // title// description
      importance: Importance.max,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("launcher_icon");
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    if (remoteMessage.notification != null) {
      flutterLocalNotificationsPlugin.show(
          remoteMessage.notification.hashCode,
          remoteMessage.notification!.title,
          remoteMessage.notification!.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                icon: "launcher_icon",
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // other properties...
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
              )));
    }
  }

//   static Future<void> testNotificaitonLocal() async {
//     debugPrint("Amr");

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'default', // id
//       'High Importance Notifications', // title// description
//       importance: Importance.max,
//     );
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("launcher_icon");
//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//             onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     flutterLocalNotificationsPlugin.show(
//         1,
//         "@",
//         "@",
//         NotificationDetails(
//             android: AndroidNotificationDetails(
//               icon: "launcher_icon",
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               // other properties...
//             ),
//             iOS: const DarwinNotificationDetails(
//               presentAlert: true,
//             )));
//   }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  static void onDidReceiveNotificationResponse(NotificationResponse details) {
    // Log.d("details.notificationResponseType.name");
    // Log.d(details.notificationResponseType.name);
    // if(details.notificationResponseType == NotificationResponseType.selectedNotification){
    //         LayoutCubit cubit =
    //       AppConstant.navigatorKey.currentContext!.read<LayoutCubit>();
    //   cubit.changePage(3);
    //   AppConstant.navigatorKey.currentState!.context
    //       .go(AppConstant.mainDir, extra: {"notification": true});
    // }
  }
}
