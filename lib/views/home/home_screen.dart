import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wordly/data/services/analytics_service.dart';
import 'package:wordly/utils/helper_function.dart';
import 'package:wordly/utils/snackbar/showcustom_snackbar.dart';
import 'package:wordly/views/home/widgets/game_category_list_widget.dart';
import 'package:wordly/views/game/game.dart';
import 'package:wordly/views/game/widgets/virtual_keyboard.dart';
import 'package:wordly/views/home/widgets/submit_button.dart';
import '../../view_model/gameview_model.dart';
import '../../view_model/homeview_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = HelperFunction.width(context);
    final homeProvider = context.watch<HomeProvider>();
    return Scaffold(
      backgroundColor: Color(0xffE0F4E5),
      appBar: AppBar(
        elevation: 1,
        actionsPadding: EdgeInsets.only(right: 10),
        centerTitle: true,
        title: SvgPicture.asset('assets/wordly_name_logo.svg'),
        backgroundColor: Color(0xffE0F4E5),
      ),
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (BuildContext context, GameProvider value, Widget? child) {
            return Center(
              child: Column(
                children: [
                  GameCategoryContainerList(
                    screenWidth: screenWidth,
                    homeProvider: homeProvider,
                    value: value,
                  ),

                  screenWidth > 600
                      ? Padding(
                        padding: const EdgeInsets.only(right: 100, top: 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: GameScreen()),

                            Expanded(
                              child: VirtualKeyboard(
                                onKeyPressed: (key) {
                                  value.handleChange(key, context);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          GameScreen(),
                          const SizedBox(height: 10),
                          VirtualKeyboard(
                            onKeyPressed: (key) {
                              value.handleChange(key, context);
                            },
                          ),
                        ],
                      ),
                  SizedBox(height: screenWidth > 600 ? 30 : 20),

                  SubmiButton.submitButton("Submit", () {
                    if (value.col == 5) {
                      value.handleChange("submit", context);

                      //Post Hog (Funnel -> game started)

                    } else {
                      CustomSnackBar.showSnackBarSafely(
                        context,
                        "Please Fill the boxes",
                        Colors.red,
                      );
                    }
                  }, screenWidth),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
