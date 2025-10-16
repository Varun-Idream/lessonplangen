import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  static Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult
        .any((result) => result != ConnectivityResult.none);
  }

  static Stream<bool> isConnected() async* {
    yield await checkInternet();
    yield* Connectivity().onConnectivityChanged.map((connectivityResult) {
      return connectivityResult
          .any((result) => result != ConnectivityResult.none);
    });
  }
}