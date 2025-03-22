import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static void trackEvent({
    required String eventName,
    Map<String, Object>? properties,
  }) {
    Posthog().capture(
      eventName: eventName,
      properties: properties ?? {},
    );
  }
}
