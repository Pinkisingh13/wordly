import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static void trackEvent({
    required String eventName,
    Map<String, Object>? properties,
  }) {
    // Only track on non-web platforms
    if (!kIsWeb) {
      Posthog().capture(
        eventName: eventName,
        properties: properties ?? {},
      );
    }
  }
}