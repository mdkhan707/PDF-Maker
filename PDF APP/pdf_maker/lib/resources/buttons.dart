import 'package:flutter/material.dart';

class UtilityButton extends StatelessWidget {
  const UtilityButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onpressed});
  final IconData icon;
  final String label;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.cyan,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.cyan,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ));
  }
}

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key, required this.lable, required this.onpress});
  final String lable;
  final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onpress,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.cyan,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 30, color: Colors.cyan),
            const SizedBox(height: 10),
            Text(
              lable,
              style: const TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ));
  }
}
