// import 'dart:convert';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:magic/core/services/local_notification_service.dart';
//
//
// class FirebaseNotificationService {
//   static final _firebaseMessage = FirebaseMessaging.instance;
//
//
//
//   static Future init() async {
//     await _firebaseMessage.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     await getDeviceToken();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(' on message  onMessage onMessage onMessage onMessage');
//       debugPrint("on Tap on Tap on Tap on Tap onMessage  ${message.data}");
//
//       if (!Platform.isIOS) {
//         LocalNotificationService.showNotification(
//           title: message.notification!.title.toString(),
//           body: message.notification!.body.toString(),
//           // payload: {
//           //   'navigate': 'true',
//           //   'click_action': message.data['click_action'].toString(),
//           //   'receiveId':
//           //   jsonDecode(message.data['details'].toString())['receiveId'],
//           //   'orderId':
//           //   jsonDecode(message.data['details'].toString())['orderId'],
//           //   'name': jsonDecode(message.data['details'].toString())['name'],
//           //   'phone': jsonDecode(message.data['details'].toString())['phone'],
//           //   'image': jsonDecode(message.data['details'].toString())['image'],
//           // },
//         );
//       }
//
//       // if (message.data['type'].toString() == 'chat') {
//       //   LocalNotificationService.awesomeNotifications
//       //       .incrementGlobalBadgeCounter();
//       //   notificationCount++;
//       //   ButtonBarHomeCubit.get(NinjaApp.navigatorKey.currentContext)
//       //       .changeState();
//       // }
//
//       // if (message.notification != null &&
//       //     NinjaApp.navigatorKey.currentContext != null) {
//       //   // if (message.notification!.body.toString().contains("وصل طلب جديد")) {
//       //   //   HomeProviderCubit.get(NinjaApp.navigatorKey.currentContext!)
//       //   //       .getHomeProviderData();
//       //   // }
//       // }
//     });
//
//     _firebaseMessage.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         // _navigateToBlackScreen(message.data);
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       debugPrint(
//           "on Tap on Tap on Tap on Tap onMessageOpenedApp  ${message.data}");
//       // if (message.notification != null &&
//       //     NinjaApp.navigatorKey.currentContext != null) {
//       //   _navigateToBlackScreen(message.data);
//       // }
//     });
//   }
//
//   static Future<String> getDeviceToken() async {
//     String? token = await _firebaseMessage.getToken();
//     if (token == null) return "";
//     print("token $token");
//     return token;
//   }
//
//   // static void _navigateToBlackScreen(Map<String, dynamic> data) {
//   //   print("object12212121212112");
//   //   // var cc=data['details'].toString();
//   //   // print(cc);
//   //   // // cc['name']
//   //   // var c2 = jsonDecode(data['details'].toString())['receiveId'];
//   //   // print(c2);
//   //   //
//   //   // print("object12212121212112weewewewwewe");
//   //
//   //   // if (data['click_action'] == "send_chat") {
//   //   //
//   //   //   // PusherService(NinjaApp.navigatorKey.currentContext!).initPusher();
//   //   //
//   //   //   // ChatCubit.get(NinjaApp.navigatorKey.currentContext!).clearChatData();
//   //   //   // ChatCubit.get(NinjaApp.navigatorKey.currentContext!).getAllMessages(
//   //   //   //     int.tryParse(jsonDecode(data['details'].toString())['orderId'].toString())??0,
//   //   //   //     int.tryParse(jsonDecode(data['details'].toString())['receiveId'].toString())??0);
//   //   //   //
//   //   //
//   //   //
//   //   //   // NinjaApp.navigatorKey.currentContext!
//   //   //   //     .pushNamed(Routes.chatDetailsScreen, arguments: {
//   //   //   //   'myId': AuthenticationCubit.get(NinjaApp.navigatorKey.currentContext!)
//   //   //   //       .userInfo!
//   //   //   //       .data
//   //   //   //       .id,
//   //   //   //   'receiveId': jsonDecode(data['details'].toString())['receiveId'],
//   //   //   //   'orderId': jsonDecode(data['details'].toString())['orderId'],
//   //   //   //   'name': jsonDecode(data['details'].toString())['name'],
//   //   //   //   'phone': jsonDecode(data['details'].toString())['phone'],
//   //   //   //   'image': EndPoints.getImageFromApi(jsonDecode(data['details'].toString())['image']),
//   //   //   // });
//   //   // }
//   //   // else if (data['click_action'] == "USER_CONFIRMED") {
//   //   //   ButtonBarHomeCubit.get(NinjaApp.navigatorKey.currentContext)
//   //   //       .changeIndex(0);
//   //   //   NinjaApp.navigatorKey.currentContext!
//   //   //       .pushNamed(Routes.buttonBarHomeScreen);
//   //   // }
//   //   // else if (data['click_action'] == "NINJA_APPROVED") {
//   //   //   ButtonBarHomeCubit.get(NinjaApp.navigatorKey.currentContext)
//   //   //       .changeIndex(2);
//   //   //   NinjaApp.navigatorKey.currentContext!
//   //   //       .pushNamed(Routes.buttonBarHomeScreen);
//   //   // }
//   //   // else if (data['click_action'] == "NINJA_ACCOUNT_APPROVED" ||
//   //   //     data['click_action'] == "NINJA_ACCOUNT_REJECTED" ||
//   //   //     data['click_action'] == "DATA_ERROR" ||
//   //   //     data['click_action'] == "NEW_ORDER_FOR_NINJA" ||
//   //   //     data['click_action'] == "user-canceled-order") {
//   //   //   ButtonBarProviderCubit.get(NinjaApp.navigatorKey.currentContext)
//   //   //       .changeIndex(0);
//   //   //   NinjaApp.navigatorKey.currentContext!
//   //   //       .pushNamed(Routes.buttonBarProviderScreen);
//   //   // }
//   //   // else if (data['click_action'] == "NINJA_CONFIRMED" ||
//   //   //     data['click_action'] == "sendOrderHour") {
//   //   //   ButtonBarProviderCubit.get(NinjaApp.navigatorKey.currentContext)
//   //   //       .changeIndex(2);
//   //   //   NinjaApp.navigatorKey.currentContext!
//   //   //       .pushNamed(Routes.buttonBarProviderScreen);
//   //   // }
//   // }
// }