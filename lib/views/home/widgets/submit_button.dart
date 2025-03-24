import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class  SubmiButton {

  static Widget _buildButton(String text, VoidCallback? onTap, double screenWidth) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child:
        Container(
          alignment: Alignment.center,
          width: screenWidth > 600 ? 200 : 130,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xff7886C7),
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xffFF6B6B), Color(0xffFF8B94)],
            ),

            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 255, 204, 208),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().scale(duration: 300.ms)
        // .then(delay: 100.ms).shake(),
  );
}

static Widget submitButton(String text, VoidCallback? onTap, double screenWidth) {
  return _buildButton(text, onTap, screenWidth);
}
}
