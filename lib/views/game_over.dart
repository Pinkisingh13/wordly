import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordly/views/widgets/elevated_button.dart';
import 'package:wordly/views/win_screen.dart';
import 'widgets/word_fact_card.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final systemWord = args?['systemWord']?.toString() ?? 'hello';
    final score = args?['score'] as int? ?? 0;
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
                  StreakAndScoreWidget(title: "Streak", streakOrScore: streak.toString(),),

                  StreakAndScoreWidget(title: "Score", streakOrScore: score.toString(), isSvg: false,),

                  ],),

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

class StreakAndScoreWidget extends StatelessWidget {
  const StreakAndScoreWidget({super.key, required this.title, required this.streakOrScore, this.isSvg = true});

  final String title;
  final String streakOrScore;
  final bool isSvg;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,

            children: [
             isSvg ?  SvgPicture.asset('assets/streak.svg', height: 20) : Text("🏆", style: TextStyle(fontSize: 20),),

              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4B5563),
                ),
              ),
            ],
          ),

          Text(
            streakOrScore,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xffFF6B6B),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickTipContainer extends StatelessWidget {
  const QuickTipContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 70,
      padding: const EdgeInsets.only(top: 12.0, left: 10, right: 3),
      decoration: BoxDecoration(
        color: Color(0xffE5F0FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 7, 69, 156).withAlpha(40),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 10,
        children: [
          // const SizedBox(width: 12),
          // Tip Text
          // Text(
          //   '🧠 Quick Tip: ',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Color(0xff374151),
          //     // fontFamily: 'ComicSans',  // Playful font style
          //   ),
          // ),
          Text(
            GenerateRandomTip.quickTip,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

class GenerateRandomTip {
  static final List<String> quickTips = [
    "🔡 Start Smart: Try words with A, E, O, T, R, N, S first!",
    "🧩 Mix It Up: Use a blend of vowels and consonants for better guesses",

    "🔍 Spot the Patterns: Look for pairs like TH, CH, or common endings like -ING.",

    "🚫 Rule Them Out: Eliminate letters that aren’t in the word — fewer choices, better chances!",

    "📍 Yellow Means Move It: Found a yellow letter? Try placing it in a different spot.",

    "🎯 Start with ‘STARE’ or ‘CRANE’: These are strong starter words!",

    "🧠 Think Like a Word Wizard: Words often have vowels in the middle — test that theory",

    "❌ Don’t Repeat Misses: Avoid reusing letters that already turned gray.",

    "🎨 Color Clues Matter: Green = Correct spot, Yellow = Wrong spot, Gray = Not in the word",

    "💬 Guess Smartly: After finding 2-3 letters, try forming words around them.",
  ];

  static final String quickTip = quickTips[Random().nextInt(quickTips.length)];
}
