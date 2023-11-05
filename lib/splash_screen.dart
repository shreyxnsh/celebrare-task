import 'package:celebrare/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool animate = false;

  @override
  void initState() {
    // TODO: implement initState
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
          
              Center(
                child: AnimatedPositioned(
                  duration: const Duration(milliseconds: 2400),
                  bottom: animate ? 100 : 0,
                  child : AnimatedOpacity(duration: const Duration(milliseconds: 2000), opacity: animate ? 1:0,
                  child: Container(
                    height: 300,
                    width: 300,
                          
                    child: 
                    Image(image: AssetImage('assets/celebrare.png',),),
                  )
                ),
                )
              )
          ],
        ),
    );
  }
  
  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    // navigate to welcome screen after 5 sec
    await Future.delayed(Duration(milliseconds: 5000));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));


  }
}