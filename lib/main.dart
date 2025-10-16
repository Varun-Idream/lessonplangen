import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/global_bloc_observer.dart';
import 'package:lessonplan/config/config_reader.dart';
import 'package:lessonplan/index.dart';
import 'package:lessonplan/services/injection/getit.dart' as di;
import 'package:lessonplan/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // dependency initilization
  await ConfigReader.initialize();
  await Services.loadServices(); // load Application Services
  Bloc.observer = GlobalBlocObserver(); // Global Bloc Observer
  runApp(const App());
}
