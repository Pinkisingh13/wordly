import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    FirebaseCrashlytics.instance.log('Category selected: ${category.name}');
    _readSystemWord();
    notifyListeners();
  }

  void _readSystemWord() {
    if (_selectedCategory == null) {
      FirebaseCrashlytics.instance.log(
        'No category selected when reading system word.',
      );
      return;
    }
    final words = wordModel[_selectedCategory!.name];
    if (words != null && words.isNotEmpty) {
      _systemWord = (words..shuffle()).first.toUpperCase();
      FirebaseCrashlytics.instance.log('System word generated: $_systemWord');
      _fetchSystemWordDefinition(_systemWord!);
    } else {
      FirebaseCrashlytics.instance.log(
        'No words available for category: ${_selectedCategory!.name}',
      );
    }
    debugPrint("system word: $systemWord");
    notifyListeners();
  }

  Future<void> _fetchSystemWordDefinition(String word) async {
    try {
      debugPrint('Fetching definition for word: $word');
      FirebaseCrashlytics.instance.log('Fetching definition for word: $word');
      wordDetailsList = await _wordService.fetchSystemWordDefinition(word);
      debugPrint(
        'Word definition fetched successfully: ${wordDetailsList.length} entries found.',
      );
      FirebaseCrashlytics.instance.log(
        'Word definition fetched successfully. Entries found: ${wordDetailsList.length}',
      );
    } catch (e, stackTrace) {
      debugPrint('Error fetching word definition: $e');
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error fetching word definition',
      );
    }
    notifyListeners();
  }

  void reset() {

    debugPrint('Resetting HomeProvider state.');
    FirebaseCrashlytics.instance.log('Resetting HomeProvider state.');
    _selectedCategory = null;
    _systemWord = null;
    notifyListeners();
  }
}
