import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:wordly/utils/helper_function.dart';


import '../../view_model/gameview_model.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.title, required this.gradient});

  final String title;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          onPressed: () {
            context.read<GameProvider>().resetGame(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homescreen',
              (route) => false,
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
            child: Container(
              width: HelperFunction.width(context) * 0.70,
              alignment: Alignment.center,

              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ), // Ensures content is padded
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .then(delay: 400.ms)
        .shimmer(
          duration: 1.seconds,
          color: Colors.white.withAlpha((0.2 * 255).toInt()),
        );
     
  }
}



class GradientColor{
  // Gradient 1
  static Color orange = Color(0xffFF6B6B);
  static Color pink = Color(0xffFF8B94);

  // Geadient 2
  static Color purple = Color(0xff8458B3);
  static Color lightPinkish = Color(0xffD0A3BF);
}