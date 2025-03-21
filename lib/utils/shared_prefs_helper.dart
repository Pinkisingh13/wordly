import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _scoreKey = 'score';

  Future<int> loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0;
  }

  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreKey, score);
  }
}