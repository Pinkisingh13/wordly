import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordly/data/models/word_detail.dart';
import 'package:wordly/data/models/word_model.dart';

class HomeProvider extends ChangeNotifier {
  Category? _selectedCategory;
  String? _systemWord;
  List<WordDetails> wordDetailsList = [];
  bool isCategoryChange = false;
  Category? get selectedCategory => _selectedCategory;
  String? get systemWord => _systemWord;

  void selectCategory(Category category) {
    _selectedCategory = category;
    _systemWord = null;
    _readSystemWord();
    notifyListeners();
  }

  void _readSystemWord() {
    if (_selectedCategory == null) return;
    print("Calling systemWord");
    final words = wordModel[_selectedCategory!.name];
    if (words != null && words.isNotEmpty) {
      _systemWord = (words..shuffle()).first.toUpperCase();
      _fetchSystemWordDefinition(_systemWord!);
    }
    print("system word: $systemWord");
    notifyListeners();
  }

  Future<void> _fetchSystemWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.dictionaryapi.dev/api/v2/entries/en/${word.toLowerCase()}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        // print("System definition data: $data");

        if (data.isNotEmpty) {
          wordDetailsList =
              data.map((item) => WordDetails.fromJson(item)).toList();

          print(
            "word Details List : ${wordDetailsList[0].meanings[0].definitions[1].example}",
          );

          notifyListeners();
        } else {
          wordDetailsList = [];
          // systemWordDefinition = 'Definition not found.';
        }
      } else {
        wordDetailsList = [];
        // systemWordDefinition = 'Definition not found.';
      }
    } catch (e) {
      // systemWordDefinition = 'Error fetching definition.';
      wordDetailsList = [];
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _selectedCategory = null;
    _systemWord = null;
    notifyListeners();
  }
}