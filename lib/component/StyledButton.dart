import 'package:flutter/material.dart';
import 'package:gym_counter/const/Colors.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(this.text, this.onPressed, this.isResting, {super.key});

  final String text;
  final VoidCallback onPressed;
  final bool isResting;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: StyledColors.primaryColor(),
        padding: const EdgeInsets.all(16.0),
        minimumSize: const Size(230, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: !isResting ? onPressed : null,
      child: Text(text,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
    );
  }
}
