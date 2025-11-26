import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/presentation/dahsboard/widgets/selection_tiles.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';
import 'package:lessonplan/util/router/router.dart';

GlobalKey scaffoldKey = GlobalKey();

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      // drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxHeight: size.height,
            maxWidth: size.width,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DashboardHeader(),
                SizedBox(
                  width: 180,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: AssetSvg(Assets.iprepLogo),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  "Your AI Powered Assistant",
                  style: TextStyles.textBold32.copyWith(
                    color: ColorConstants.primaryBlack,
                    letterSpacing: 2,
                    fontSize: 42,
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  "For Effortless Learning & Teaching",
                  style: TextStyles.textBold32.copyWith(
                    color: ColorConstants.primaryBlack,
                    letterSpacing: 0,
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectionTiles(
                      title: 'AI Lesson Plan',
                      subText: 'Generate & Manage Lesson Plans',
                      icon: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: ColorConstants.backgroundBlue2,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: AssetSvg(Assets.aiLessonPlan),
                        ),
                      ),
                      callback: () {
                        sl<AppRouter>().push(LessonPlanRoute());
                      },
                    ),
                    const SizedBox(width: 40),
                    SelectionTiles(
                      title: 'AI Assessment',
                      subText: 'Create & Manage Custom Tests',
                      icon: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: ColorConstants.backgroundBlue2,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: AssetSvg(Assets.assessment),
                        ),
                      ),
                      callback: () {
                        sl<AppRouter>().push(AssessmentAIRoute());
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
