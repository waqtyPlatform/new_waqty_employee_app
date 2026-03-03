//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:magic/core/api/end_points.dart';
// import 'package:magic/core/services/cache_helper.dart';
// import 'package:magic/core/utils/constant_keys.dart';
// import 'package:magic/features/user/chat/logic/chat_cubit.dart';
//
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//
// class PusherService {
//   static PusherService? _instance;
//   late PusherChannelsFlutter _pusher;
//   BuildContext? context;
//   late int myId;
//
//   factory PusherService(int id ,BuildContext context) {
//     _instance ??= PusherService._(id,context);
//     return _instance!;
//   }
//
//   PusherService._(int id,BuildContext context) {
//     this.context = context;
//     _pusher = PusherChannelsFlutter.getInstance();
//     myId=id;
//   }
//
//   Future<void> initPusher() async {
//     try {
//       await _pusher.init(
//         apiKey: '8c2e1dd2efb8c49df486',
//         cluster: 'eu',
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         onAuthorizer: onAuthorizer,
//       );
//     } catch (e) {
//       print('Error initializing Pusher: $e');
//     }
//   }
//
//   Future<void> subscribeToChannel(String channelName) async {
//     try {
//       print('success subscribing to channel $channelName');
//       await _pusher.subscribe(
//         channelName: channelName,
//       );
//     } catch (e) {
//       print('Error subscribing to channel $channelName: $e');
//     }
//   }
//
//   Future<void> unsubscribeFromChannel(String channelName) async {
//     try {
//       print('success Unsubscribing to channel $channelName');
//       await _pusher.unsubscribe(channelName: channelName);
//     } catch (e) {
//       print('Error unsubscribing from channel $channelName: $e');
//     }
//   }
//
//   void connectPusher() {
//     try {
//       _pusher.connect();
//     } catch (e) {
//       print('Error connecting Pusher: $e');
//     }
//   }
//
//   void disconnectPusher() {
//     try {
//       _pusher.disconnect();
//     } catch (e) {
//       print('Error disconnecting Pusher: $e');
//     }
//   }
//
//   Future<void> triggerEvent(
//       String channelName, String eventName, dynamic data) async {
//     try {
//       await _pusher.trigger(PusherEvent(
//         channelName: channelName,
//         eventName: eventName,
//         data: data,
//       ));
//     } catch (e) {
//       print('Error triggering event on channel $channelName: $e');
//     }
//   }
//
//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     print('Connection state changed: $currentState');
//   }
//
//   void onError(String message, int? code, dynamic e) {
//     print('Error: $message, code: $code, exception: $e');
//   }
//
//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     print('Subscription succeeded on channel $channelName');
//   }
//
//   void onEvent(PusherEvent event) {
//     print('Received event: $event');
//     ChatCubit.get(context).newEvent(myId,event);
//   }
//
//   void onSubscriptionError(String message, dynamic e) {
//     print('Subscription error: $message, exception: $e');
//   }
//
//   void onDecryptionFailure(String event, String reason) {
//     print('Decryption failure on event $event: $reason');
//   }
//
//   void onMemberAdded(String channelName, PusherMember member) {
//     print('Member added to channel $channelName: $member');
//   }
//
//   void onMemberRemoved(String channelName, PusherMember member) {
//     print('Member removed from channel $channelName: $member');
//   }
//
//   Future<dynamic> onAuthorizer(
//       String channelName, String socketId, dynamic options) async {
//     ///
//     var authUrl = "${EndPoints.baseUrl}/api/customers/pusher/auth";
//     try {
//       var result = await http.post(
//         Uri.parse(authUrl),
//         headers: {
//           ConstantKeys.acceptText: ConstantKeys.applicationJson,
//           ConstantKeys.appAuthorization:
//           "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
//         },
//         body: {'socket_id': socketId, 'channel_name': channelName},
//       );
//       var jsonResponse = jsonDecode(result.body);
//       print("Authorization response: $jsonResponse");
//       return jsonResponse;
//     } catch (e) {
//       print("Error during authorization: $e");
//       throw e;
//     }
//   }
// }