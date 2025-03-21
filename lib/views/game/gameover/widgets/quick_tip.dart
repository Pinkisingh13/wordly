import 'package:flutter/material.dart';
import 'package:wordly/data/models/quick_tip_model.dart';

class QuickTipContainer extends StatelessWidget {
  const QuickTipContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 70,
      padding: const EdgeInsets.only(top: 12.0, left: 10, right: 3),
      decoration: BoxDecoration(
        color: Color(0xffE5F0FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 7, 69, 156).withAlpha(40),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 10,
        children: [
 
          Text(
            GenerateRandomTip.quickTip,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
