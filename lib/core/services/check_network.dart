import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

ConnectivityResult? source = ConnectivityResult.none;
MyConnectivity connectivity = MyConnectivity.instance;

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  static Connectivity connectivity = Connectivity();
  static StreamController<Map<String, bool>> controller =
      StreamController.broadcast();

  static Stream<Map<String, bool>> get myStream => controller.stream;

  static Future<void> initialise() async {
    final List<ConnectivityResult> result = await (connectivity
        .checkConnectivity());
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) async {
      debugPrint("onConnectivity Changed changed");
      debugPrint(result[0].toString());
      _checkStatus(result);
    });
  }

  static Future<bool> refreshStatus() async {
    final List<ConnectivityResult> result = await (connectivity
        .checkConnectivity());
    _checkStatus(result);
    return isOnline();
  }

  static void _checkStatus(List<ConnectivityResult> result) async {
    final filteredResult = result.where((item) {
      return item != ConnectivityResult.none;
    }).toList();
    final bool isOnline = filteredResult.isNotEmpty;
    source = isOnline ? filteredResult.first : ConnectivityResult.none;
    debugPrint(isOnline.toString());
    controller.sink.add({"result": isOnline});
  }

  void disposeStream() => controller.close();

  static bool isOnline() => source != ConnectivityResult.none;
}
