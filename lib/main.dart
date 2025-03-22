import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
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

  await Firebase.initializeApp();
  
  // Initialize PostHog before Firebase Crashlytics
  final posthogConfig =
      PostHogConfig('<YOUR_POSTHOG_API_KEY>')
        ..host =
            'https://us.i.posthog.com' // or EU endpoint
        ..captureApplicationLifecycleEvents = true
        ..debug = kDebugMode;
  await Posthog().setup(posthogConfig);

  // 1️⃣ Catches all synchronous Flutter framework errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // 2️⃣ Catches all uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 3️⃣ Catches Dart's Isolate thread errors
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
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Wordly",
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashscreen',
        // initialRoute: '/winscreen',
        // initialRoute: '/gameoverscreen',
        theme: ThemeData(),
        onGenerateRoute: (settings) => onGenerateRoute(settings),
        // routes: {
        //   '/splashscreen': (context)=> SplashScreen(),
        //   '/homescreen': (context) => HomeScreen(),
        //   // '/gamescreen': (context) => GameScreen(),
        //   '/winscreen': (context) => WinScreen(),
        //   '/gameoverscreen': (context) => GameOverScreen(),
        // },
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
