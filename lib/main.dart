import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/views/HomeScreen/home_screen.dart';
import 'package:wordly/views/game.dart';
import 'package:wordly/views/game_over.dart';
import 'package:wordly/views/win_screen.dart';

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
        //  ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => DropDownProvider()),
        ChangeNotifierProvider(create: (context) => GameController()),
        ChangeNotifierProvider(
          create: (context) => WinController(),
          
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Wordly",
        debugShowCheckedModeBanner: false,
        // initialRoute: '/splashscreen',
        // initialRoute: '/winscreen',
        initialRoute: '/gameoverscreen',

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
