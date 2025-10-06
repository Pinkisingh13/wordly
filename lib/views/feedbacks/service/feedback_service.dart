import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wordly/data/services/analytics_service.dart';
import 'package:wordly/views/feedbacks/model/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'user_feedback';

  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      // Add feedback to Firestore
      await _firestore
          .collection(collectionName)
          .doc(feedback.id)
          .set(feedback.toJson());

      // Track analytics
      AnalyticsService.trackEvent(
        eventName: 'feedback_submitted',
        properties: {
          'feedback_type': feedback.type.name,
          'feedback_id': feedback.id,
          'timestamp': feedback.timestamp.toIso8601String(),
        },
      );

      // Log to Crashlytics
      FirebaseCrashlytics.instance.log(
        'Feedback submitted: ${feedback.type.name}',
      );

      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Failed to submit feedback',
      );

      AnalyticsService.trackEvent(
        eventName: 'feedback_submission_failed',
        properties: {
          'error': e.toString(),
          'feedback_type': feedback.type.name,
        },
      );

      return false;
    }
  }

  // Optional: Get all feedback for admin view
  Stream<List<FeedbackModel>> getAllFeedback() {
    return _firestore
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModel.fromJson(doc.data()))
          .toList();
    });
  }
}