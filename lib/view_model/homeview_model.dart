import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:wordly/data/models/word_detail.dart';
import 'package:wordly/data/models/word_model.dart';
import 'package:wordly/data/services/analytics_service.dart';
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

    // PostHog Tracking
    if (!kIsWeb) {
      AnalyticsService.trackEvent(
        eventName: "category_selected",
        properties: {
          'category_name': category.name,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
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

      // PostHog
      AnalyticsService.trackEvent(
        eventName: "system_word_generated",
        properties: {
          'word': _systemWord ?? "unknown",
          'category': _selectedCategory!.name,
          'word_length': _systemWord!.length,
        },
      );

      FirebaseCrashlytics.instance.log('System word generated: $_systemWord');
      _fetchSystemWordDefinition(_systemWord!);
    } else {
      //PostHog
      AnalyticsService.trackEvent(
        eventName: "Category word is not selected",
        properties: {'category_name': _selectedCategory!.name},
      );

      //Firebase Crashlytics
      FirebaseCrashlytics.instance.log(
        'No words available for category: ${_selectedCategory!.name}',
      );
    }
    debugPrint("system word: $systemWord");
    notifyListeners();
  }

  Future<void> _fetchSystemWordDefinition(String word) async {
    try {

      //PostHog
      AnalyticsService.trackEvent(eventName: "word_definition_fetch_started", properties: {
        'word':word,
        'category': _selectedCategory?.name ?? "unknown",
      });

      debugPrint('Fetching definition for word: $word');
      FirebaseCrashlytics.instance.log('Fetching definition for word: $word');

      wordDetailsList = await _wordService.
      fetchSystemWordDefinition(word);

      AnalyticsService.trackEvent(eventName: 'word_definition_fetch_success', properties: {
          'word': word,
          'definition_count': wordDetailsList.length,
          'first_definition': wordDetailsList.isNotEmpty 
              ? wordDetailsList.first
              : 'none',
        });

      debugPrint(
        'Word definition fetched successfully: ${wordDetailsList.length} entries found.',
      );
      FirebaseCrashlytics.instance.log(
        'Word definition fetched successfully. Entries found: ${wordDetailsList.length}',
      );
    } catch (e, stackTrace) {
      AnalyticsService.trackEvent(eventName: "word_definition_fetch_failed", properties: {
          'word': word,
          'error': e.toString(),
          'stack_trace': stackTrace.toString(),
        });

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
    AnalyticsService.trackEvent(eventName: 'home_provider_reset', properties: {
       'last_category': _selectedCategory?.name ?? "unknow",
        'last_word': _systemWord ?? "",
    });
    debugPrint('Resetting HomeProvider state.');
    FirebaseCrashlytics.instance.log('Resetting HomeProvider state.');
    _selectedCategory = null;
    _systemWord = null;
    notifyListeners();
  }
}
