import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordly/views/HomeScreen/home_screen.dart';
import 'package:wordly/views/widgets/elevated_button.dart';

import 'widgets/word_fact_card.dart';

class WinScreen extends StatefulWidget {
  const WinScreen({super.key});

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool _showAnimation = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final systemWord = args?['systemWord']?.toString() ?? 'hello';
    final score = args?['score'] as int? ?? 0;
    final streak = args?['streak'] as int? ?? 0;

    final listOfSystemWord = systemWord.split("");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffFFE66D),
                    Color(0xff4ECDC4),
                    // Color(0xff45B7D1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SvgPicture.asset('assets/win_cup.svg'),
                  SizedBox(height: 30),
                  SvgPicture.asset('assets/you_win.svg'),
                  SizedBox(height: 35),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...listOfSystemWord.map((word) {
                        return WordContainerWidget(
                          wordChar: word.toUpperCase(),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 48),
                  WinDetailsWidget(
                    score: score.toString(),
                    streak: streak.toString(),
                  ),
                  SizedBox(height: 45),

                  CustomElevatedButton(
                    // gradient: [Color(0xff8458B3), Color(0xffD0A3BF)],
                    gradient: [
                      GradientColor.purple,
                      GradientColor.lightPinkish,
                    ],
                    title: "Play Again! ",
                  ),
                ],
              ),
            ),

            //WORD FACT CARD
            WordFactCard(color: GradientColor.purple, word: systemWord),

            // Overlay animation
            if (_showAnimation)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 0,
                right: 0,
                child: Lottie.asset(
                  "assets/win.json",
                  controller: _animationController,

                  onLoaded: (composition) {
                    _animationController
                      ..duration = composition.duration
                      ..forward().whenComplete(() {
                        setState(() => _showAnimation = false);
                      });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WinController extends ChangeNotifier {
  bool showAni = true;
  void hideAnimation() {
    showAni = false;
    // if (showAni) {
    //   Lottie.asset("assets/win.json", width: 60);
    // }
    notifyListeners();
  }
}

class WordContainerWidget extends StatelessWidget {
  const WordContainerWidget({
    super.key,
    required this.wordChar,
    this.height = 60,
    this.width = 60,
  });
  final double height;
  final double width;
  final String wordChar;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffA8E6CF), Color(0xffDCEDC1)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            wordChar,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,

              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class WinDetailsWidget extends StatelessWidget {
  const WinDetailsWidget({
    super.key,
    required this.score,
    required this.streak,
    this.isShowText = true,
  });

  final String score;
  final String streak;
  final bool isShowText;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        isShowText
            ? Text(
              "Amazing Job!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            )
            : SizedBox(),
        isShowText ? SizedBox(height: 16) : SizedBox(),
        Container(
          alignment: Alignment.center,

          width: width * 0.90,
          height: 55,
          decoration: BoxDecoration(
            color: Color(0xffFFE5E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Winning Streak: $streak 🔥",
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 12),
        Container(
          alignment: Alignment.center,

          width: width * 0.90,
          height: 55,
          decoration: BoxDecoration(
            color: Color(0xffE5F9FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text("Total Wins: $score 🏆", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

// void openLoadingDialogue(String text, String animation, BuildContext context) {
//   showDialog(
//     context: context, //Use Get.overlayContext for overlay dialogs
//     barrierDismissible:
//         false, //The dialog can't be dismissed by tapping outside
//     builder:
//         (_) => PopScope(
//           canPop: false,
//           child: Container(
//             // color: THelperFunctions.isDarkMode(Get.context!)
//             // ? TColors.dark
//             color: Colors.white,
//             width: double.infinity,
//             height: double.infinity,
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//                 TAnimationLoaderWidget(
//                   text: text,
//                   animation: animation,
//                   showAction: true,
//                   onActionPressed: () => stopLoading(context),
//                   actionText: "Go Back",
//                 ),
//               ],
//             ),
//           ),
//         ),
//   );
// }

// /// Stop the currently open loading dialog.
// /// This method does not return anything.
// stopLoading(BuildContext context) {
//   Navigator.of(context).pop();
// }

class TAnimationLoaderWidget extends StatelessWidget {
  const TAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
        const SizedBox(height: 30),
        Text(
          text,
          // style: Theme.of(context).textTheme.bodyMedium,
          style: TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 30,
          // height: TSizes.defaultSpace,
        ),
        showAction
            ? SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(
                  actionText!,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: const Color.fromARGB(255, 182, 182, 182),
                  ),
                ),
              ),
            )
            : const SizedBox(),
      ],
    );
  }
}
