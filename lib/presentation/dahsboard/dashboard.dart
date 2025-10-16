import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/dahsboard/widgets/drawer.dart';
import 'package:lessonplan/presentation/dahsboard/widgets/header.dart';

GlobalKey scaffoldKey = GlobalKey();

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DashboardHeader(),
            ],
          ),
        ),
      ),
    );
  }
}
