import 'dart:developer';

import 'package:lessonplan/services/api/api.service.dart';
import 'package:lessonplan/services/hive_service.dart';

class Services {
  static Future<void> loadServices() async {
    try {
      await ApiService.loadService(); // Api service initilization
      await HiveService.init(); // Hive service initialization
    } catch (e) {
      log('$e');
    }
  }
}
