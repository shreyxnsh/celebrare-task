import 'package:celebrare/HomePage.dart';
import 'package:celebrare/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // status bar color
    statusBarColor: Color(0xff0f837b), 
  ));
  
  runApp(const MaterialApp(
    home: Main(),
    debugShowCheckedModeBanner: false,
  ));

  
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
