import 'package:lessonplan/util/constants/constants.dart';

AppType getAppType(String type) {
  switch (type) {
    case 'standalone':
      return AppType.standalone;
    case 'serverclient':
      return AppType.serverclient;
    case 'online':
      return AppType.online;
    default:
      return AppType.standalone;
  }
}