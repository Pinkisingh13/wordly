enum FeedbackType {
  bug,
  feature,
  improvement,
  other
}

class FeedbackModel {
  final String id;
  final FeedbackType type;
  final String message;
  final String userEmail;
  final DateTime timestamp;
  final int currentScore;
  final int currentStreak;

  FeedbackModel({
    required this.id,
    required this.type,
    required this.message,
    required this.userEmail,
    required this.timestamp,
    required this.currentScore,
    required this.currentStreak,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'message': message,
      'userEmail': userEmail,
      'timestamp': timestamp.toIso8601String(),
      'currentScore': currentScore,
      'currentStreak': currentStreak,
    };
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      type: FeedbackType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FeedbackType.other,
      ),
      message: json['message'] ?? '',
      userEmail: json['userEmail'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      currentScore: json['currentScore'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}