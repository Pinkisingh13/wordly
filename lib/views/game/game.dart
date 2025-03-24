import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';


import '../../view_model/gameview_model.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
        // Calculate cell size and padding based on screen width
        final isMobile = screenWidth < 600;
        final cellSize = isMobile 
            ? (screenWidth - 100) / 6  // Mobile calculation
            : 60.0;  // Fixed larger size for web

        // Calculate horizontal padding for web to center the grid
        final horizontalPadding = isMobile
            ? 40.0
            : (screenWidth - (5 * cellSize + 4 * 6)) / 2;

        return Consumer<GameProvider>(
          builder:
              (context, controller, child) => Column(
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                
                      horizontal: horizontalPadding,
                  
                      vertical: isMobile ? 15 : 20
                      ),
                    shrinkWrap: true,
                    itemCount: 5*5,
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
                      return Container(
                        // duration: 300.ms, // Animation duration
                        // curve: Curves.easeInCubic, // Animation curve
                        // padding: EdgeInsets.all(10),
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
                                    .scale() // Scale animation
                                    // Shake animation
                                  
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
