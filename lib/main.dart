import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/views/home/home_screen.dart';
import 'package:wordly/views/game/game_over.dart';
import 'package:wordly/views/game/win_screen.dart';

import 'view_model/gameview_model.dart';
import 'view_model/homeview_model.dart';
import 'views/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(
          create: (context) => WinController(), 
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Wordly",
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashscreen',
        // initialRoute: '/winscreen',
        // initialRoute: '/gameoverscreen',
        theme: ThemeData() ,
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
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500), // Smooth duration
  );
}