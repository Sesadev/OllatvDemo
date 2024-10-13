import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollatv/app/ui/chat_screen.dart';
import 'package:ollatv/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OllaTv',
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {ChatScreen.routeName:(context) => ChatScreen()},
    );
  }
}




