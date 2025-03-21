// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordly/main.dart';
import 'package:wordly/data/model/word_detail.dart';
import 'package:wordly/data/model/word_model.dart';
import 'package:wordly/views/home/widgets/game_category_list_widget.dart';
import 'package:wordly/views/game/game.dart';
import 'package:wordly/views/game/widgets/virtual_keyboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dropDownProvider = context.watch<DropDownProvider>();
    return Scaffold(
      backgroundColor: Color(0xffE0F4E5),
      appBar: AppBar(
        elevation: 1,
        actionsPadding: EdgeInsets.only(right: 10),
        centerTitle: true,
        title: SvgPicture.asset('assets/wordly_name_logo.svg'),
        backgroundColor: Color(0xffE0F4E5),
      ),
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (BuildContext context, GameController value, Widget? child) {
            return Center(
              child: Column(
                children: [
                  GameCategoryList(screenWidth: screenWidth, dropDownProvider: dropDownProvider, value:value),

                  screenWidth > 600
                      ? Padding(
                        padding: const EdgeInsets.only(right: 100, top: 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: GameScreen()),

                            Expanded(
                              child: VirtualKeyboard(
                                onKeyPressed: (key) {
                                  value.handleChange(key, context);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          GameScreen(),
                          const SizedBox(height: 10),
                          VirtualKeyboard(
                            onKeyPressed: (key) {
                              value.handleChange(key, context);
                            },
                          ),
                        ],
                      ),
                  SizedBox(height: screenWidth > 600 ? 30 : 20),

                  _buildButton(
                    "Submit",

                    value.isGameOver
                        ? null
                        : () {
                          if (value.col == 5) {
                            value.handleChange("submit", context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Fill all 5 boxes before submitting!",
                                ),
                              ),
                            );
                          }
                        },
                    screenWidth,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



class CategoryContainerWidget extends StatelessWidget {
  const CategoryContainerWidget({
    super.key,
    required this.isGameActive,
    required this.isSelected,
    required this.category,
  });

  final bool isGameActive;
  final bool isSelected;
  final Category category;

  CategoryStyle get style => categoryStyles[category]!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow overflow of Lottie animation
      children: [
        // Main Container
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: style.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isGameActive
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xffE0F4E5),
              // isSelected
              //     ? const Color(0xff00224D)
              //     : const Color(0xffE0F4E5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50, child: style.image),
              const SizedBox(height: 12),
              Text(
                style.name.toUpperCase(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isGameActive ? Colors.black54 : const Color(0xff00224D),
                ),
              ),
            ],
          ),
        ),

        // Lottie Animation (Positioned outside the container)
        if (isSelected)
          Positioned(
            top: -17, // Adjust to position outside the container
            right: -17, // Adjust to position outside the container

            child: Lottie.asset(
              'assets/tick_two.json',
              height: 55, // Adjust size as needed
              width: 55,
              repeat: false,
              animate: true,

              options: LottieOptions(enableApplyingOpacityToLayers: true),
            ),
          ),
      ],
    );
  }
}

Widget _buildButton(String text, VoidCallback? onTap, double screenWidth) {
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
        ).animate().scale(duration: 300.ms).then(delay: 100.ms).shake(),
  );
}

class DropDownProvider extends ChangeNotifier {
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

class GameController extends ChangeNotifier {
  bool isGameStart = false;
  int score = 0;
  int streak = 0;
  int row = 0;
  int col = 0;
  bool isElseChecking = false;

  List<List<String>> gameBoard = List.generate(
    5,
    (index) => List.filled(5, ""),
  );

  List<List<Color>> cellColors = List.generate(
    5,
    (_) => List.filled(5, Colors.transparent),
  );

  //score increment
  void incrementScoreAndStreak() {
    score++;
    streak++;
    notifyListeners();
  }

  void resetStreak() {
    streak = 0;
    notifyListeners();
  }

  //Word Validation
  Future<bool?> isvalidWord(String word) async {
    try {
      print("Calling api");
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );

      print("api called");
      print(response.body);

      if (response.statusCode == 200) {
        print(response.statusCode);
        return true;
      } else if (response.statusCode == 404) {
        print("response is 404");
        return false;
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String get systemWord => _getSystemWord();

  String _getSystemWord() {
    final provider = _dropDownProvider;
    if (provider == null || provider.systemWord == null) {
      throw Exception("System word not initialized");
    }
    return provider.systemWord!;
  }

  DropDownProvider? get _dropDownProvider {
    try {
      return navigatorKey.currentContext?.read<DropDownProvider>();
    } catch (_) {
      return null;
    }
  }

  bool isGameOver = false;

  // Add in GameController
  bool get isGameActive => isGameStart || isGameOver;

  Future<void> handleChange(String key, BuildContext context) async {
    if (isGameOver || row >= 5) return;
    if (_dropDownProvider?.systemWord == null) {
      showSnackBarSafely(context, "Please Choose Category.!", Colors.red);
      return;
    }
    print(systemWord);

    isGameStart = true;
    if (key.length == 1 && RegExp(r'^[A-Z]$').hasMatch(key)) {
      if (col < 5) {
        gameBoard[row][col] = key;
        col++;
        print("col: $col");
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

  void submitWord(BuildContext context) async {
    if (_dropDownProvider?.systemWord == null) {
      showSnackBarSafely(
        context,
        "System word is not initialized!",
        Colors.red,
      );
      return;
    }
    String userWord = gameBoard[row].join();

    final isvalid = await isvalidWord(userWord.toLowerCase());

    if (isvalid != null && isvalid) {
      // Reset colors for current row
      cellColors[row] = List.filled(5, Colors.transparent);

      if (userWord == systemWord) {
        isElseChecking = true;
        for (int i = 0; i < 5; i++) {
          cellColors[row][i] = Color(0xffAAD174);
        }

        incrementScoreAndStreak();
        moveToWinScreen(context);
        isGameStart = false;
        isGameOver = true;
      } else {
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
      for (int i = 0; i < 5; i++) {
        gameBoard[row][i] = '';
      }
      col = 0; // Reset the column pointer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ You guessed wrong word! Try again.")),
      );
      notifyListeners();

      return;
    }

    // Move to the next row for the next attempt
    if (!isGameOver) {
      if (row < 4) {
        row++;
        print("increasing row: $row");
        col = 0;
      } else {
        isGameOver = true;
        isGameStart = false;
        resetStreak();
        moveToGameOverScreen(context);
      }
    }

    notifyListeners();
  }

  void resetGame(BuildContext context) {
    row = 0;
    col = 0;
    // score = 0;
    cellColors = List.generate(5, (_) => List.filled(5, Colors.transparent));
    gameBoard = List.generate(5, (_) => List.filled(5, ""));
    isGameOver = false;
    isGameStart = false;
    context.read<DropDownProvider>().reset();
    notifyListeners();
  }

  void moveToWinScreen(BuildContext context) {
    final arguments = {
      'systemWord': systemWord,
      'score': score,
      'streak': streak,
    };
    Navigator.pushReplacementNamed(
      context,
      '/winscreen',
      arguments: arguments, // Pass the system word as an argument
    );

    resetGame(context);
  }

  void moveToGameOverScreen(BuildContext context) {
    final arguments = {
      'systemWord': systemWord,
      'score': score,
      'streak': streak,
    };
    Navigator.pushReplacementNamed(
      context,
      '/gameoverscreen',
      arguments: arguments, // Pass the system word as an argument
    );

    resetGame(context);
  }
}
