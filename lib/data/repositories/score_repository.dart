import '../datasources/local_data_source.dart';

class ScoreRepository {
  final LocalDataSource localDataSource;

  ScoreRepository(this.localDataSource);

  Future<int> getScore() => localDataSource.getScore();

  Future<void> saveScore(int score) => localDataSource.saveScore(score);
}
