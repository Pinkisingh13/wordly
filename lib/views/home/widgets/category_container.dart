import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/word_model.dart';

class CategoryContainerWidget extends StatelessWidget {
  const CategoryContainerWidget({
    super.key,
    required this.isGameActive,
    required this.isSelected,
    required this.category,
  });

  final bool isGameActive;
  final bool isSelected;
  final Category category;

  CategoryStyle get style => categoryStyles[category]!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow overflow of Lottie animation
      children: [
        // Main Container
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: style.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isGameActive
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xffE0F4E5),
              // isSelected
              //     ? const Color(0xff00224D)
              //     : const Color(0xffE0F4E5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50, child: style.image),
              const SizedBox(height: 12),
              Text(
                style.name.toUpperCase(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isGameActive ? Colors.black54 : const Color(0xff00224D),
                ),
              ),
            ],
          ),
        ),

        // Lottie Animation (Positioned outside the container)
        if (isSelected)
          Positioned(
            top: -17, // Adjust to position outside the container
            right: -17, // Adjust to position outside the container

            child: Lottie.asset(
              'assets/tick_two.json',
              height: 55, // Adjust size as needed
              width: 55,
              repeat: false,
              animate: true,
             

              options: LottieOptions(enableApplyingOpacityToLayers: true, ),
            ),
          ),
      ],
    );
  }
}