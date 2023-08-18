import 'package:celebrare/shapes/circle.dart';
import 'package:celebrare/shapes/heart.dart';
import 'package:celebrare/shapes/round_rectangle.dart';
import 'package:celebrare/shapes/square.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        LayoutBuilder(builder: (context, size) {
          print(size.biggest);
          return Container(
            padding: const EdgeInsets.all(20),
            width: size.maxWidth,
            height: size.maxWidth,
            child: CustomPaint(
              painter: Circle(),
            ),
          );
        })
      ]),
    );
  }
}
