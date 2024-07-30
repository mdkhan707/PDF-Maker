import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class Gradient extends StatelessWidget {
  const Gradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent])),
    );
  }
}

class Utils {
  static void flushbarmessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        borderRadius: BorderRadius.circular(10),
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        message: message,
        padding: const EdgeInsets.all(15),
        positionOffset: 20,
        reverseAnimationCurve: Curves.bounceInOut,
        icon: const Icon(Icons.error, size: 15),
        backgroundColor: Colors.red,
      )..show(context),
    );
  }
}
