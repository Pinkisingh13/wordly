import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/views/home/home_screen.dart';
import 'package:wordly/views/game/game.dart';
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

        routes: {
          '/splashscreen': (context)=> SplashScreen(),
          '/homescreen': (context) => HomeScreen(),
          '/gamescreen': (context) => GameScreen(),
          '/winscreen': (context) => WinScreen(),
          '/gameoverscreen': (context) => GameOverScreen(),
        },
      ),
    );
  }
}
