import 'dart:developer';

import 'package:lessonplan/services/api/api.service.dart';

class Services {
  static Future<void> loadServices() async {
    try {
      await ApiService.loadService(); // Api service initilization
    } catch (e) {
      log('$e');
    }
  }
}
