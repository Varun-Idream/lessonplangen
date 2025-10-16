import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

import 'services/injection/getit.dart';
import 'util/router/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // Application Root
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        routerConfig: sl<AppRouter>().config(),
        theme: ThemeData(
          fontFamily: "Inter",
          colorSchemeSeed: ColorConstants.primaryBlue,
        ),
      );
  }
}
