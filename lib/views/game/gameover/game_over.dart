import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wordly/shared/widgets/elevated_button.dart';
import 'package:wordly/utils/helper_function.dart';
import 'package:wordly/view_model/gameview_model.dart';
import 'package:wordly/views/game/gameover/widgets/quick_tip.dart';
import 'package:wordly/views/game/gamewin/win_screen.dart';

import '../../didyouknow/word_fact_card.dart';
import 'widgets/streakandscore.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = HelperFunction.width(context);
    final height = HelperFunction.height(context);
    final score = context.watch<GameProvider>().score;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final systemWord = args?['systemWord']?.toString() ?? 'hello';
    final streak = args?['streak'] as int? ?? 0;
    final listOfSystemWord = systemWord.split("");

    // Responsive sizing
    final isLargeScreen = width > 900;
    final isMediumScreen = width > 600 && width <= 900;

    final double imageSize = isLargeScreen ? 250 : (isMediumScreen ? 200 : 180);
    final double titleFontSize = isLargeScreen ? 36 : (isMediumScreen ? 32 : 28);
    final double subtitleFontSize = isLargeScreen ? 18 : 16;
    final double containerMaxWidth = isLargeScreen ? 500 : (isMediumScreen ? 400 : width * 0.9);

    return Scaffold(
      backgroundColor: const Color(0xffF5FFFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffE0F4E5),
        toolbarHeight: 9,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: isLargeScreen ? 40 : 20,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20), // Add padding here
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Important!
                      children: [
                        Image.asset(
                          'assets/sad_emoji_two.png',
                          height: imageSize,
                          width: imageSize,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Oops! Not This Time!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffFF6B6B),
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          constraints: BoxConstraints(maxWidth: containerMaxWidth),
                          child: Text(
                            "Don't worry! Every try makes you smarter!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff4B5563),
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        //! Word display
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: containerMaxWidth,
                            minHeight: 100, // Reduced from 120
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16, // Reduced from 20
                            vertical: 16, // Reduced from 20
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 13,
                                spreadRadius: -5,
                                color: Color.fromARGB(30, 0, 0, 0),
                              ),
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 6,
                                spreadRadius: -4,
                                color: Color.fromARGB(30, 0, 0, 0),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "The current word was:",
                                style: TextStyle(
                                  color: Color(0xff4B5563),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 12), // Reduced from 15
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: listOfSystemWord.map((word) {
                                  return WordContainerWidget(
                                    wordChar: word.toUpperCase(),
                                    height: isLargeScreen ? 50 : 50,
                                    width: isLargeScreen ? 50 : 50,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20), // Reduced from 24

                        //! Streak and Score
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            StreakAndScoreWidget(
                              title: "Streak",
                              streakOrScore: streak.toString(),
                            ),
                            StreakAndScoreWidget(
                              title: "Score",
                              streakOrScore: score.toString(),
                              isSvg: false,
                            ),
                          ],
                        ),

                        SizedBox(height: 20), // Reduced from 24

                        // Button
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isLargeScreen ? 400 : 350,
                          ),
                          child: CustomElevatedButton(
                            title: "Try Again",
                            gradient: [
                              GradientColor.orange,
                              GradientColor.pink,
                            ],
                          ),
                        ),

                        SizedBox(height: 20), // Reduced from 24

                        // Quick tip
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isLargeScreen ? 500 : 380,
                          ),
                          child: QuickTipContainer(),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              WordFactCard(word: systemWord, color: Colors.amber),

              // Decorative elements (only on large screens)
              if (isLargeScreen) ...[
                Positioned(
                  top: height * 0.10,
                  left: 40,
                  child: SvgPicture.asset(
                    'assets/blue_circle.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
                Positioned(
                  right: 40,
                  top: height * 0.2,
                  child: SvgPicture.asset(
                    'assets/pink_circle.svg',
                    height: 40,
                    width: 40,
                  ),
                ),
                Positioned(
                  left: 40,
                  top: height * 0.57,
                  child: SvgPicture.asset(
                    'assets/star_two.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
                Positioned(
                  right: 60,
                  bottom: height * 0.15,
                  child: SvgPicture.asset(
                    'assets/peach_circle.svg',
                    height: 100,
                  ),
                ),
                Positioned(
                  top: height * 0.10,
                  right: 100,
                  child: SvgPicture.asset(
                    'assets/singlestar.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}