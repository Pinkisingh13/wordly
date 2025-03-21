import 'package:flutter/material.dart';

import '../../../data/model/word_model.dart';
import '../home_screen.dart';

class GameCategoryList extends StatelessWidget {
  const GameCategoryList({
    super.key,
    required this.screenWidth,
    required this.dropDownProvider,
    required this.value
  });

  final double screenWidth;
  final DropDownProvider dropDownProvider;
  final GameController value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10),
      height: 120,
    
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final isSelected =
              dropDownProvider.selectedCategory == category;
          final isGameActive =
              value.isGameStart || value.isGameOver;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap:
                  isGameActive
                      ? null
                      : () {
                        dropDownProvider.selectCategory(category);
                      },
              child: CategoryContainerWidget(
                isGameActive: isGameActive,
                isSelected: isSelected,
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }
}