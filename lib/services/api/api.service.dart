import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lessonplan/config/config_reader.dart';

class ApiService {
  static String baseURL = "${ConfigReader.config.baseURL}/firebase";
  static String firebaseGetUrl = "$baseURL/call/get";
  static String authorizationToken = ConfigReader.config.authorizationToken;
  static String firebasePostUrl = "$baseURL/call/post";

  static Dio cgfDio = Dio(
    BaseOptions(
      baseUrl: "https://api.crazygoldfish.com",
    ),
  );

  static Future<void> loadService() async {
    try {} catch (e) {
      log('$e');
    }
  }

  static void configureCGF({
    required String token,
  }) async {
    try {
      cgfDio.options.headers['Authorization'] = "Bearer $token";
    } catch (e) {
      log('$e');
      rethrow;
    }
  }
}
