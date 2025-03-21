
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StreakAndScoreWidget extends StatelessWidget {
  const StreakAndScoreWidget({
    super.key,
    required this.title,
    required this.streakOrScore,
    this.isSvg = true,
  });

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
              isSvg
                  ? SvgPicture.asset('assets/streak.svg', height: 20)
                  : Text("🏆", style: TextStyle(fontSize: 20)),

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


