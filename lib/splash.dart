import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:cvd/home.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
          'CvD',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.yellow
        ),
      ),
      image: Image.asset('assets/cd.png'),
      backgroundColor: Colors.blueAccent,
      photoSize: 60,
      loaderColor: Colors.redAccent,
    );
  }
}
