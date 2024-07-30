import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_maker/Routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(
    //     const Duration(seconds: 4),
    //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => const HomeScreen())));
    Timer(
      Duration(seconds: 4),
      () => Navigator.pushNamed(context, RoutesName.homescreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              height: 150,
              width: 150,
              image: AssetImage('images/pdf.png'),
            ),
          ),
          SizedBox(height: 100),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'PDF MAKER',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
