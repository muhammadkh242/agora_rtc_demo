import 'package:flutter/material.dart';

class DurationDialog extends StatelessWidget {
  const DurationDialog({
    Key? key,
    required this.duration,
  }) : super(key: key);
  final int duration;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 100,
        width: 300,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 32,
        ),
        child: Center(
          child: duration < 60
              ? Text("Call duration : $duration second")
              : Text(
                  "Call duration : ${duration ~/ 60} minute",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
        ),
      ),
    );
  }
}
