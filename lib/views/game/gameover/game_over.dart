import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wordly/shared/widgets/elevated_button.dart';
import 'package:wordly/views/game/gameover/widgets/quick_tip.dart';
import 'package:wordly/utils/helper_function.dart';
import 'package:wordly/view_model/gameview_model.dart';
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

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 9),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),

          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFFE5F1), Color(0xffE5F0FF)],
            ),
          ),

          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Image.asset(
                    'assets/sad_emoji_two.png',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "Oops! Not This Time! ",
                    style: TextStyle(
                      color: Color(0xffFF6B6B),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      "Don't worry! Every try makes you smarter!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff4B5563),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),

                  Container(
                    width: width * 0.8,
                    height: 100,
                    padding: EdgeInsets.only(top: 10),
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
                      // mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        Text(
                          "The current word was: ",
                          style: TextStyle(
                            color: Color(0xff4B5563),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...listOfSystemWord.map((word) {
                              return WordContainerWidget(
                                wordChar: word.toUpperCase(),
                                height: 40,
                                width: 40,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 30,
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

                  SizedBox(height: 20),
                  CustomElevatedButton(
                    title: "Try Again ",
                    gradient: [GradientColor.orange, GradientColor.pink],
                  ),

                  SizedBox(height: 20),
                  QuickTipContainer(),
                ],
              ),

              WordFactCard(word: systemWord, color: Colors.amber),

              // DESIGN STAR
              // Blue circle with bounce effect
              Positioned(
                top: height * 0.10,
                child: SvgPicture.asset(
                  'assets/blue_circle.svg',
                  height: 30,
                  width: 30,
                ),
              ),

              //Pink Circle
              Positioned(
                right: width * 0.1,
                // bottom: height * 0.3,
                top: height * 0.2,
                child: SvgPicture.asset(
                  'assets/pink_circle.svg',
                  height: 40,
                  width: 40,
                ),
              ),
              Positioned(
                left: 0,
                top: height * 0.57,
                child: SvgPicture.asset(
                  'assets/star_two.svg',
                  height: 20,
                  width: 20,
                ),
              ),

              // Shaking peach circle
              Positioned(
                left: width * 0.6,
                bottom: height * 0.15,
                child: SvgPicture.asset('assets/peach_circle.svg', height: 100),
              ),

              Positioned(
                top: height * 0.10,
                right: width * 0.10,
                child: SvgPicture.asset(
                  'assets/singlestar.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
