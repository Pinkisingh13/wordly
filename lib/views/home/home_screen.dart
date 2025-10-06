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
    final isLargeScreen = screenWidth > 900;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 900;

    return Scaffold(
      // backgroundColor: Color(0xffE0F4E5),
       backgroundColor: const Color(0xffF5FFFA),
      appBar: AppBar(
  elevation: 1,
  actionsPadding: EdgeInsets.only(right: 10),
  centerTitle: true,
  title: SvgPicture.asset('assets/wordly_name_logo.svg'),
  // backgroundColor: Color(0xffE0F4E5),
  backgroundColor: const Color(0xffE0F4E5),
  actions: [
    IconButton(
      icon: Icon(
        Icons.settings_outlined,
        color: Color(0xff00224D),
        size: 28,
      ),
      onPressed: () {
        AnalyticsService.trackEvent(
          eventName: 'settings_opened',
          properties: {
            'from': 'home_screen',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        Navigator.pushNamed(context, '/settingsscreen');
      },
      tooltip: 'Settings',
    ),
  ],
),
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (BuildContext context, GameProvider value, Widget? child) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1400),
                child: isLargeScreen
                    ? _buildLargeScreenLayout(
                        screenWidth, homeProvider, value, context)
                    : _buildMobileLayout(
                        screenWidth, homeProvider, value, context, isMediumScreen),
              ),
            );
          },
        ),
      ),
    );
  }

  // Large screen layout (> 900px) - Side by side
  Widget _buildLargeScreenLayout(
    double screenWidth,
    HomeProvider homeProvider,
    GameProvider value,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          // Categories at top
          GameCategoryContainerList(
            screenWidth: screenWidth,
            homeProvider: homeProvider,
            value: value,
          ),
          SizedBox(height: 30),
          
          // Game and Keyboard side by side
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Game Board
                Expanded(
                  flex: 3,
                  child: Center(child: GameScreen()),
                ),
                
                SizedBox(width: 40),
                
                // Keyboard
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VirtualKeyboard(
                        onKeyPressed: (key) {
                          value.handleChange(key, context);
                        },
                      ),
                      SizedBox(height: 30),
                      SubmiButton.submitButton("Submit", () {
                        if (value.col == 5) {
                          value.handleChange("submit", context);
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile/Tablet layout (≤ 900px) - Stacked vertically
  Widget _buildMobileLayout(
    double screenWidth,
    HomeProvider homeProvider,
    GameProvider value,
    BuildContext context,
    bool isMediumScreen,
  ) {
    return Column(
      children: [
        GameCategoryContainerList(
          screenWidth: screenWidth,
          homeProvider: homeProvider,
          value: value,
        ),
        SizedBox(height: isMediumScreen ? 20 : 10),
        
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GameScreen(),
                SizedBox(height: isMediumScreen ? 20 : 10),
                VirtualKeyboard(
                  onKeyPressed: (key) {
                    value.handleChange(key, context);
                  },
                ),
                SizedBox(height: isMediumScreen ? 30 : 20),
                SubmiButton.submitButton("Submit", () {
                  if (value.col == 5) {
                    value.handleChange("submit", context);
                  } else {
                    CustomSnackBar.showSnackBarSafely(
                      context,
                      "Please Fill the boxes",
                      Colors.red,
                    );
                  }
                }, screenWidth),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}