import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/view_model/homeview_model.dart';

import 'widgets/three_d_icon.dart';
import 'widgets/word_detail.dart';


class WordFactCard extends StatefulWidget {
  const WordFactCard({super.key, required this.color, required this.word});
  final Color color;
  final String word;

  @override
  State<WordFactCard> createState() => _WordFactCardState();
}

class _WordFactCardState extends State<WordFactCard> {
  bool _showFact = false;

  void _toggleFact() {
    setState(() => _showFact = !_showFact);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Stack(
      children: [
     
        IconButton(
   
          icon:
              _showFact
                  ? Icon(Icons.close, size: 40, color: Colors.blue.shade500)
                  : ThreeDQuestionMark(),

          onPressed: _toggleFact,
        ),

        // Overlay with Animated Fact Container
        if (_showFact)
          GestureDetector(
            onTap: _toggleFact,
            child: Container(
              width: double.infinity,

              // color: Color(0xffF8F9FF),
              color: Colors.transparent,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  // width: 300,
                  margin: EdgeInsets.all(20),
                  height: 500,
                  decoration: BoxDecoration(
                    // color: Colors.yellow.shade300,
                    color: Colors.yellow.shade200,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        spacing: 6,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Color(0xffFF6B6B), size: 20),

                          Text(
                            'Did You Know?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFF6B6B),
                            ),
                          ),
                          Icon(Icons.star, color: Color(0xffFF6B6B), size: 20),
                        ],
                      ),
                      SizedBox(height: 8),
                      provider.wordDetailsList.isEmpty
                          ? const Text(
                            'No fact available for this word. Try submitting a valid word!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          )
                          : DidYouKnowWordDetail(provider: provider),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class DidYouKnowDesignContainer extends StatelessWidget {
  const DidYouKnowDesignContainer({
    super.key,
    required this.title,
    required this.details,
  });

  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      // width: 120,
      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xffF5FFFA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decorationThickness: 3,
              decorationStyle: TextDecorationStyle.wavy,
              decorationColor: Color(0xff4ECDC4),
              decoration: TextDecoration.underline,
              color: Color(0xffFF6B6B),
            ),
          ),
          Text(
            details,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

