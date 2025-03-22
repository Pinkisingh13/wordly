import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/data/services/word_services.dart';
import 'package:wordly/main.dart';
import 'package:wordly/utils/snackbar/showcustom_snackbar.dart';
import 'package:wordly/view_model/homeview_model.dart';

import '../data/repositories/score_repository.dart';

class GameProvider extends ChangeNotifier {
  //Variables
  bool isGameStart = false;
  bool isGameOver = false;
  int _score = 0;
  int _streak = 0;
  int row = 0;
  int col = 0;
  bool isElseChecking = false;
  final ScoreRepository scoreRepository;

  // Call loadScore when the provider is initialized
  GameProvider(this.scoreRepository) {
    loadScore();
  }

  // Getters
  String get systemWord => _getSystemWord();
  int get score => _score;
  int get streak => _streak;

  List<List<String>> gameBoard = List.generate(
    5,
    (index) => List.filled(5, ""),
  );

  List<List<Color>> cellColors = List.generate(
    5,
    (_) => List.filled(5, Colors.transparent),
  );

  // Load score from SharedPreferences
  Future<void> loadScore() async {
    try {
      _score = await scoreRepository.getScore();
      FirebaseCrashlytics.instance.log("Score loaded successfully: $_score");
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);

      FirebaseCrashlytics.instance.log('Failed to load score. Error: $e');
    }
    notifyListeners();
  }

  //score increment
  void incrementScoreAndStreak() {
    _score++;
    _streak++;
    FirebaseCrashlytics.instance.log(
      'Score incremented to $_score and streak is $_streak',
    );
    scoreRepository.saveScore(_score);
    notifyListeners();
  }

  // Reset Streak
  void resetStreak() {
    _streak = 0;
    notifyListeners();
  }

  // Word Validation
  Future<bool?> isvalidWord(String word) async {
    return await WordService.checkIsValidWord(word);
  }

  // Get system Word
  HomeProvider? get _homeProvider {
    try {
      return navigatorKey.currentContext?.read<HomeProvider>();
    } catch (_) {
      return null;
    }
  }

  String _getSystemWord() {
    final provider = _homeProvider;
    if (provider == null || provider.systemWord == null) {
      throw Exception("System word not initialized");
    }
    return provider.systemWord!;
  }

  // Add in GameController
  bool get isGameActive => isGameStart || isGameOver;

  Future<void> handleChange(String key, BuildContext context) async {
    if (isGameOver || row >= 5) return;
    if (_homeProvider?.systemWord == null) {
      CustomSnackBar.showSnackBarSafely(
        context,
        "Please Choose Category.!",
        Colors.red,
      );
      return;
    }
    debugPrint(systemWord);

    isGameStart = true;
    if (key.length == 1 && RegExp(r'^[A-Z]$').hasMatch(key)) {
      if (col < 5) {
        gameBoard[row][col] = key;
        col++;
      }
    } else if (key == '❌') {
      if (col > 0) {
        col--;
        gameBoard[row][col] = '';
      }
    } else if (col == 5 && key == "submit") {
      submitWord(context);
    }
    notifyListeners();
  }

  // Submit Word Logic
  void submitWord(BuildContext context) async {
    // If System Word is Null
    try {
      if (_homeProvider?.systemWord == null) {
        FirebaseCrashlytics.instance.log('System word not initialized.');
        CustomSnackBar.showSnackBarSafely(
          context,
          "System word is not initialized!",
          Colors.red,
        );
        return;
      }

      String userWord = gameBoard[row].join();
      FirebaseCrashlytics.instance.log('User submitted word: $userWord');

      final isvalid = await isvalidWord(userWord.toLowerCase());
      FirebaseCrashlytics.instance.log('Is Word Valid: $isvalid');

      if (isvalid != null && isvalid) {
        // Reset colors for current row
        cellColors[row] = List.filled(5, Colors.transparent);

        if (userWord == systemWord) {
          isElseChecking = true;
          for (int i = 0; i < 5; i++) {
            cellColors[row][i] = Color(0xffAAD174);
          }
          FirebaseCrashlytics.instance.log(
            'User guessed the correct word: $userWord',
          );
          incrementScoreAndStreak();
          moveToWinScreen(context);
          isGameStart = false;
          isGameOver = true;
        } else {
          FirebaseCrashlytics.instance.log(
            'User guessed incorrectly: $userWord',
          );
          isElseChecking = true;
          cellColors[row] = List.filled(5, Color(0xff7F7D89));

          List<bool> correctPosition = List.filled(5, false);
          List<bool> matchedInSystemWord = List.filled(5, false);

          // Step 2a: Mark correct letters in correct positions
          for (int i = 0; i < 5; i++) {
            if (userWord[i] == systemWord[i]) {
              cellColors[row][i] = Color(0xffAAD174);
              correctPosition[i] = true;
              matchedInSystemWord[i] = true;
            }
          }

          // Step 2b: Mark correct letters in wrong positions
          for (int i = 0; i < 5; i++) {
            if (!correctPosition[i]) {
              for (int j = 0; j < 5; j++) {
                if (!matchedInSystemWord[j] && userWord[i] == systemWord[j]) {
                  cellColors[row][i] = Color(0xffF5CD47);
                  matchedInSystemWord[j] = true;
                  break;
                }
              }
            }
          }
        }
      } else {
        FirebaseCrashlytics.instance.log('Invalid word submission: $userWord');
        for (int i = 0; i < 5; i++) {
          gameBoard[row][i] = '';
        }
        col = 0;
        CustomSnackBar.showSnackBarSafely(
          context,
          "Not A Valid Word",
          Colors.red,
        );
        notifyListeners();

        return;
      }

      // Move to the next row for the next attempt
      if (!isGameOver) {
        if (row < 4) {
          row++;
          col = 0;
        } else {
          FirebaseCrashlytics.instance.log('Game Over: Max attempts reached.');
          isGameOver = true;
          isGameStart = false;
          resetStreak();

          moveToGameOverScreen(context);
        }
      }
    } on Exception catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      FirebaseCrashlytics.instance.log('Error occurred in submitWord(): $e');
    }

    notifyListeners();
  }

  // Reset Game
  void resetGame(BuildContext context) {
    row = 0;
    col = 0;
    cellColors = List.generate(5, (_) => List.filled(5, Colors.transparent));
    gameBoard = List.generate(5, (_) => List.filled(5, ""));
    isGameOver = false;
    isGameStart = false;
    FirebaseCrashlytics.instance.log('Game has been reset.');
    context.read<HomeProvider>().reset();
    notifyListeners();
  }

  // Move to Win Screen
  void moveToWinScreen(BuildContext context) {
    final arguments = {'systemWord': systemWord, 'streak': streak};
    Navigator.pushReplacementNamed(context, '/winscreen', arguments: arguments);
    FirebaseCrashlytics.instance.log('Moving to Win Screen.');
  }

  // Move to Game Over Screen
  void moveToGameOverScreen(BuildContext context) {
    final arguments = {'systemWord': systemWord, 'streak': streak};
    Navigator.pushReplacementNamed(
      context,
      '/gameoverscreen',
      arguments: arguments,
    );
    FirebaseCrashlytics.instance.log('Moving to Game over screen.');
  }
}
