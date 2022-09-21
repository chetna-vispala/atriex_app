import 'package:flutter/material.dart';

import 'main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  get backgroundColor => null;

  @override
  void initState() {
    super.initState();
    _navigatatetohome();
  }

  _navigatatetohome() async {
    await Future.delayed( const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  const FindDevicesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VispalaApp',
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/whiteLogo.png',
                height: 250.0,
                width: 250.0,
              ),
              const SizedBox(
                height: 5.0,
                width: 125,
                child: Divider(
                  color: Colors.white,
                ),
              ),
              const Text(
                'Version 1.0',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
