// import 'package:flutter/material.dart';

// import 'elevated_button.dart';

// class WordFactCard extends StatefulWidget {
//   const WordFactCard({super.key});

//   @override
//   State<WordFactCard> createState() => _WordFactCardState();
// }

// class _WordFactCardState extends State<WordFactCard> {
//   bool _showFact = false;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [

//         // Icon Button (For 'Did You Know?')
//         Positioned(
//           top: 10,
//           right: 10,
//           child: IconButton(
//             icon: Icon(
//               _showFact ?
//               Icons.close
//               :
//               Icons.chrome_reader_mode_outlined,
//               // Icons.lightbulb_outline,
//               // color: Colors.amber,
//               color: GradientColor.purple,
//               size: 28,
//             ),
//             onPressed: () {
//               setState(() {
//                 _showFact = !_showFact;
//               });
//             },
//           ),
//         ),

//         // Word Fact Card (Revealed on Click)
//         if (_showFact)
//           Positioned(
//             top: 50,
//             right: 0,
//             left: 0,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 400),
//               padding: const EdgeInsets.all(12.0),
//               decoration: BoxDecoration(
//                 color: Colors.yellow.shade300,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.orange.shade200,
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: const Text(
//                 'Did You Know? A "foyer" is an entrance hall in a building, perfect for welcoming guests!',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.brown,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/data/model/word_detail.dart';
import 'package:wordly/views/home/home_screen.dart';

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
    final provider = context.watch<DropDownProvider>();
    return Stack(
      children: [
        // 'Did You Know?' Icon Button
        IconButton(
          // backgroundColor: Colors.blue.shade50,
          icon:
              _showFact
                  ? Icon(Icons.close, size: 40, color: Colors.blue.shade500)
                  : ThreeDQuestionMark(),

          // Icon(
          //   _showFact ? Icons.close : Icons.chrome_reader_mode_outlined,
          //   // color: Colors.amber,
          //   color: widget.color,
          //   size: 40, // Enlarged for better visibility
          // ),
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

class DidYouKnowWordDetail extends StatelessWidget {
  const DidYouKnowWordDetail({super.key, required this.provider});

  final DropDownProvider provider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.wordDetailsList.length,
        itemBuilder: (context, index) {
          final wordDef = provider.wordDetailsList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DidYouKnowDesignContainer(title: "Word", details:  wordDef.word),

              //Extracting ALL THE INFO
              if (wordDef.meanings.isNotEmpty) ...[
                // WORD MEANING
                if (wordDef
                    .meanings
                    .first
                    .definitions
                    .first
                    .definition
                    .isNotEmpty)
                  DidYouKnowDesignContainer(
                    title: "Word",
                    details:
                        " ${wordDef.word.toUpperCase()} : ${wordDef.meanings.first.definitions.first.definition}",
                  ),

                // PART OF SPEECH
                if (wordDef.meanings.first.partOfSpeech.isNotEmpty)
                  DidYouKnowDesignContainer(
                    title: "Part of Speech",
                    details: wordDef.meanings.first.partOfSpeech,
                  ),
                // EXAMPLE
                DidYouKnowDesignContainer(
                  title: "Example",
                  details:
                      wordDef.meanings.first.definitions.first.example.isEmpty
                          ? "No Example Available"
                          : wordDef.meanings.first.definitions.first.example,
                ),

                
                //SYNONYMS
                if (wordDef.meanings.first.synonyms.isNotEmpty)
                  DidYouKnowDesignContainer(
                    title: "Synonyms",
                    details: wordDef.meanings.first.synonyms.take(3).join(", "),
                  ),

                /// ANTONYMS 
                // if (wordDef.meanings.first.antonyms.isNotEmpty)
                DidYouKnowDesignContainer(
                  title: "Antonyms",
                  details:
                      wordDef.meanings.first.antonyms.isEmpty
                          ? "No Antonyms Available"
                          : wordDef.meanings.first.antonyms.take(3).join(", "),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class DidYouKnowDesignContainer extends StatelessWidget {
  const DidYouKnowDesignContainer({
    super.key,
    required this.title,
    required this.details,

    // required this.wordDef,
  });

  // final WordDetails wordDef;
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

class ThreeDQuestionMark extends StatelessWidget {
  const ThreeDQuestionMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 5),
            ],
          ),
        ),
      ),
    );
  }
}
