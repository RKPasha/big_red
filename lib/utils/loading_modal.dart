import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  final String message;

  const LoadingModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const CircularProgressIndicator(
              color: Colors.red,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
