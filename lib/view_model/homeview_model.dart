import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordly/data/models/word_detail.dart';
import 'package:wordly/data/models/word_model.dart';
import 'package:wordly/data/services/word_services.dart';

class HomeProvider extends ChangeNotifier {
  Category? _selectedCategory;
  String? _systemWord;
   final WordService _wordService = WordService();
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
    final words = wordModel[_selectedCategory!.name];
    if (words != null && words.isNotEmpty) {
      _systemWord = (words..shuffle()).first.toUpperCase();
      _fetchSystemWordDefinition(_systemWord!);
    }
    debugPrint("system word: $systemWord");
    notifyListeners();
  }

  Future<void> _fetchSystemWordDefinition(String word) async {
    wordDetailsList = await _wordService.fetchSystemWordDefinition(word);  
    notifyListeners();
  }

  void reset() {
    _selectedCategory = null;
    _systemWord = null;
    notifyListeners();
  }
}