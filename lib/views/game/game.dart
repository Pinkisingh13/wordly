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
        
        // Responsive cell sizing
        final double cellSize;
        final double spacing;
        final double fontSize;
        
        if (screenWidth > 900) {
          // Large screens (desktop)
          cellSize = 70.0;
          spacing = 8.0;
          fontSize = 28.0;
        } else if (screenWidth > 600) {
          // Medium screens (tablet)
          cellSize = 60.0;
          spacing = 6.0;
          fontSize = 24.0;
        } else {
          // Small screens (mobile)
          cellSize = (screenWidth - 100) / 6;
          spacing = 6.0;
          fontSize = 23.0;
        }

        return Consumer<GameProvider>(
          builder: (context, controller, child) => Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 25,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisExtent: cellSize,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 5;
                  int col = index % 5;
                  final String cellValue = controller.gameBoard[row][col];
                  
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xffA78BFA),
                        width: 2,
                      ),
                      color: controller.isElseChecking
                          ? controller.cellColors[row][col]
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: cellValue.isNotEmpty
                        ? Text(
                            cellValue,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ).animate().scale()
                        : SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}