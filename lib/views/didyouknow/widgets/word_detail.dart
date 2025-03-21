import 'package:flutter/material.dart';
import 'package:wordly/view_model/homeview_model.dart';

import '../word_fact_card.dart';

class DidYouKnowWordDetail extends StatelessWidget {
  const DidYouKnowWordDetail({super.key, required this.provider});

  final HomeProvider provider;

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
              DidYouKnowDesignContainer(title: "Word", details:  wordDef.word),

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
