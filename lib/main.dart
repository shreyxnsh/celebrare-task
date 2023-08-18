import 'package:celebrare/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Main(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const Homepage();
  }
}
