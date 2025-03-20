// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordly/views/HomeScreen/home_screen.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.select<GameController, int>(
      (controller) => controller.score,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Score :",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "$score",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // ),
      ],
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
            // Calculate cell size based on screen width
        final screenWidth = constraints.maxWidth;
        final cellSize = screenWidth < 600 
            ? (screenWidth - 100) / 6  // For mobile
            : 40.0;  // Max size for web
        return Consumer<GameController>(
          builder:
              (context, controller, child) => Column(
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      // horizontal: 50, 
                       horizontal: screenWidth < 600 ? 50 : screenWidth /2.60,
                      // vertical: 15,
                      vertical: screenWidth < 600 ? 15 : 20
                      ),
                    shrinkWrap: true,
                    itemCount: controller.gameBoard.length * 5,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      // mainAxisExtent: 40,
                      mainAxisExtent: cellSize ,
                      // mainAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 5;
                      int col = index % 5;
                      final String cellValue = controller.gameBoard[row][col];
                      return AnimatedContainer(
                        duration: 300.ms, // Animation duration
                        curve: Curves.easeInCubic, // Animation curve

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Color(0xffA78BFA),
                            width: 2,
                          ),
                          color:
                              controller.isElseChecking
                                  ? controller.cellColors[row][col]
                                  : Colors.transparent,
                        ),

                        alignment: Alignment.center,

                        child:
                            cellValue.isNotEmpty
                                ? Text(
                                      controller.gameBoard[row][col],
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                    .animate() // Looping animation
                                    .scale(duration: 100.ms) // Scale animation
                                    // Shake animation
                                    .flip(
                                      duration: 100.ms,
                                      direction: Axis.horizontal,
                                      perspective: 50,
                                    )
                                : SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
        );
      },
    );
  }
}

void showCustomSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
    ),
  );
}

void showSnackBarSafely(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  if (context.mounted) {
    showCustomSnackBar(context, message, backgroundColor);
  }
}
