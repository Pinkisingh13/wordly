import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wordly/data/services/analytics_service.dart';
import 'package:wordly/firebase_options.dart';
import 'package:wordly/views/home/home_screen.dart';
import 'package:wordly/views/game/gameover/game_over.dart';
import 'package:wordly/views/game/gamewin/win_screen.dart';

import 'data/datasources/local_data_source.dart';
import 'data/repositories/score_repository.dart';
import 'utils/shared_prefs_helper.dart';
import 'view_model/gameview_model.dart';
import 'view_model/homeview_model.dart';
import 'views/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');
  

  // Initialize Firebase for all platforms
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    final posthogApiKey = dotenv.env['POSTHOG_API_KEY'].toString();
    final posthogHost = dotenv.env['POSTHOG_HOST'].toString();

    final posthogConfig =
        PostHogConfig(posthogApiKey)
          ..host = posthogHost
          ..captureApplicationLifecycleEvents = true
          ..sessionReplayConfig=PostHogSessionReplayConfig()
          ..flushInterval=const Duration(seconds: 10)
          ..flushAt=1
          ..debug = true;
          // ..debug = kDebugMode;
          // ..sessionReplay = true;
    await Posthog().setup(posthogConfig);
  

  /// Error handlers (keep for all platforms)

  // 1️⃣ Catches all synchronous Flutter framework errors
  FlutterError.onError =
      (errorDetails) =>
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);

  // 2️⃣ Catches all uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 3️⃣ Catches Dart's Isolate thread errors
  if (!kIsWeb) {
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }).sendPort,
    );
  }
  AnalyticsService.trackEvent(
    eventName: 'app_launched',
    properties: {'platform': 'Flutter'},
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPrefsHelper = SharedPrefsHelper();
    final localDataSource = LocalDataSource(sharedPrefsHelper);
    final scoreRepository = ScoreRepository(localDataSource);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(
          create: (context) => GameProvider(scoreRepository),
        ),
        ChangeNotifierProvider(create: (context) => WinController()),
      ],
      child: PostHogWidget(
        child: MaterialApp(
          navigatorObservers: [PosthogObserver()],
          navigatorKey: navigatorKey,
          title: "Wordly",
          debugShowCheckedModeBanner: false,
          initialRoute: '/splashscreen',
          theme: ThemeData(),
          onGenerateRoute: (settings) => onGenerateRoute(settings),
        ),
      ),
    );
  }
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/splashscreen':
      return _buildPageRoute(SplashScreen(), settings);

    case '/homescreen':
      return _buildPageRoute(HomeScreen(), settings);

    case '/gameoverscreen':
      return _buildPageRoute(GameOverScreen(), settings);

    case '/winscreen':
      return _buildPageRoute(WinScreen(), settings);

    default:
      return null;
  }
}

PageRouteBuilder _buildPageRoute(Widget screen, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 500), // Smooth duration
  );
}
