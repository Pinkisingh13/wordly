import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordly/utils/helper_function.dart';
import 'package:wordly/view_model/gameview_model.dart';
import 'package:wordly/shared/widgets/elevated_button.dart';
import '../../didyouknow/word_fact_card.dart';

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
    final streak = args?['streak'] as int? ?? 0;
    final listOfSystemWord = systemWord.split("");
    final score = context.watch<GameProvider>().score;

    final width = HelperFunction.width(context);
    final isLargeScreen = width > 900;
    final isMediumScreen = width > 600 && width <= 900;

    return Scaffold(
      // backgroundColor: const Color(0xffF5FFFA),
      appBar: AppBar(
        toolbarHeight: 9,
        // backgroundColor: Colors.black,
        backgroundColor: const Color(0xffE0F4E5),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        bottom: true,

        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: isLargeScreen ? 40 : 20,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffFFE66D),
                    Color(0xff4ECDC4),
                  ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/win_cup.svg',
                          height: isLargeScreen ? 120 : (isMediumScreen ? 100 : 80),
                        ),
                        SizedBox(height: 20),
                        SvgPicture.asset(
                          'assets/you_win.svg',
                          height: isLargeScreen ? 60 : (isMediumScreen ? 50 : 40),
                        ),
                        SizedBox(height: 30),

                        // Word display
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: listOfSystemWord.map((word) {
                            return WordContainerWidget(
                              wordChar: word.toUpperCase(),
                              height: isLargeScreen ? 70 : (isMediumScreen ? 60 : 50),
                              width: isLargeScreen ? 70 : (isMediumScreen ? 60 : 50),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 40),

                        // Win details
                        WinDetailsWidget(
                          score: score.toString(),
                          streak: streak.toString(),
                        ),

                        SizedBox(height: 40),

                        //! Play again button
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isLargeScreen ? 400 : 350,
                          ),
                          child: CustomElevatedButton(
                            gradient: [
                              GradientColor.purple,
                              GradientColor.lightPinkish,
                            ],
                            title: "Play Again!",
                          ),
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Word Fact Card
            WordFactCard(color: GradientColor.purple, word: systemWord),

            // Overlay animation
            if (_showAnimation)
              Positioned(
                top: HelperFunction.height(context) * 0.15,
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
    final width = HelperFunction.width(context);
    final isLargeScreen = width > 900;
    final containerMaxWidth = isLargeScreen ? 500 : width * 0.9;

    return Column(
      children: [
        if (isShowText)
          Text(
            "Amazing Job!",
            style: TextStyle(
              fontSize: isLargeScreen ? 28 : 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (isShowText) SizedBox(height: 16),
        
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: containerMaxWidth.toDouble()),
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
          constraints: BoxConstraints(maxWidth: containerMaxWidth.toDouble()),
          height: 55,
          decoration: BoxDecoration(
            color: Color(0xffE5F9FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Score: $score 🏆",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}