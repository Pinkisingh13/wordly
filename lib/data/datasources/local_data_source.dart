import 'package:wordly/utils/shared_prefs_helper.dart';


class LocalDataSource {

  final SharedPrefsHelper sharedPrefsHelper;

  LocalDataSource(this.sharedPrefsHelper);

  Future<int> getScore() => sharedPrefsHelper.loadScore();

  Future<void> saveScore(int score) => sharedPrefsHelper.saveScore(score);
}