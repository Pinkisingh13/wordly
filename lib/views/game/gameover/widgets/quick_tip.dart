import 'package:flutter/material.dart';
import 'package:wordly/data/models/quick_tip_model.dart';

class QuickTipContainer extends StatelessWidget {
  const QuickTipContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Responsive width
      constraints: BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(16),
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
      child: Text(
        GenerateRandomTip.quickTip,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xff4B5563),
        ),
      ),
    );
  }
}