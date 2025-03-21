class WordDetails {
  final String word;
  final List<Meaning> meanings;

  WordDetails({
    required this.word,
    required this.meanings,
  });

  factory WordDetails.fromJson(Map<String, dynamic> json) {
    return WordDetails(
      word: json['word'] ?? '',
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((e) => Meaning.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => Definition.fromJson(e))
              .toList() ??
          [],
      synonyms: List<String>.from(json['synonyms'] ?? []),
      antonyms: List<String>.from(json['antonyms'] ?? []),
    );
  }
}

class Definition {
  final String definition;
  final String example;

  Definition({
    required this.definition,
    required this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
    );
  }
}
