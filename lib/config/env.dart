import 'dart:io';
// import 'package:lessonplan/util/constants/constants.dart';

import 'config_reader.dart';

enum AppEnvironment { debug, profile, release }

final class Environment {
  static String dataBasePATH = "";
  static String currentDirectory = Directory.current.path;

  static Future<void> loadEnvironment() async {
    await ConfigReader.initialize(); // Default Debug Config is Loaded
  }
}
