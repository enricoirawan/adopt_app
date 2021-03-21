import 'package:app_adopt/screens/get_started.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Timer> startTimer() async {
    return Timer(Duration(seconds: 3), onDone);
  }

  void onDone() {
    Navigator.of(context).pushReplacementNamed(GetStartedScreen.routeName);
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/playstore.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Helena',
                  style: TextStyle(fontFamily: 'Ubuntu'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
