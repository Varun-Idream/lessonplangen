import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/router/router.dart';

class DrawerItem {
  final String title;
  final Widget icon;
  final Function(BuildContext)? onTap;

  DrawerItem({
    required this.title,
    required this.icon,
    this.onTap,
  });
}

class CustomDrawer extends StatelessWidget {
  final double drawerWidth;
  final Color backgroundColor;
  const CustomDrawer({
    super.key,
    this.drawerWidth = 380,
    this.backgroundColor = ColorConstants.primaryWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const LinearBorder(),
      backgroundColor: backgroundColor,
      width: drawerWidth,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            ...[
              DrawerItem(
                title: "Lesson Plan",
                icon: const AssetSvg(Assets.aiicon),
                onTap: (context) async {
                  sl<AppRouter>().push(LessonPlanRoute());
                  final parentScaffold = Scaffold.of(context);
                  if (parentScaffold.isDrawerOpen) {
                    parentScaffold.closeDrawer();
                  }
                },
              ),
            ].map((item) {
              return ListTile(
                leading: SizedBox(
                  height: 20,
                  width: 20,
                  child: item.icon,
                ),
                title: Text(item.title),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: ColorConstants.primaryBlue,
                ),
                onTap: () {
                  if (item.onTap != null) {
                    item.onTap!(context); // Wrapped with a null check
                  }
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
