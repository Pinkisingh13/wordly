import 'package:flutter/material.dart';
import 'package:wordly/view_model/homeview_model.dart';
import 'package:wordly/views/home/widgets/category_container.dart';

import '../../../data/models/word_model.dart';
import '../../../view_model/gameview_model.dart';

class GameCategoryContainerList extends StatelessWidget {
  const GameCategoryContainerList({
    super.key,
    required this.screenWidth,
    required this.homeProvider,
    required this.value
  });

  final double screenWidth;
  final HomeProvider homeProvider;
  final GameProvider value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenWidth > 600 ? 5 : 10),
      height: 120,
    
      child: ListView.builder(
        
        itemCount: Category.values.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final isSelected =
              homeProvider.selectedCategory == category;
          final isGameActive =
              value.isGameStart || value.isGameOver;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap:
                  isGameActive
                      ? null
                      : () {
                        homeProvider.selectCategory(category);
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