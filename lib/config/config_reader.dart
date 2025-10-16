import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'configmodel.dart';
import 'env.dart';

abstract class ConfigReader {
  static Config _config = const Config();
  static Config get config => _config;

  static Future<void> initialize({
    AppEnvironment env = AppEnvironment.debug,
  }) async {
    try {
      String configString;
      switch (env) {
        case AppEnvironment.debug:
          configString =
              await rootBundle.loadString('configuration/debug.json');
          break;
        case AppEnvironment.profile:
          configString =
              await rootBundle.loadString('configuration/profile.json');
          break;
        case AppEnvironment.release:
          configString =
              await rootBundle.loadString('configuration/release.json');
          break;
      }
      _config = Config.fromJSON(json: json.decode(configString));
    } catch (e) {
      log('$e');
    }
  }
}
