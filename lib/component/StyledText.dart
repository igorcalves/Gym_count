import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText({super.key, required this.text, this.colorText, this.size});

  final Color? colorText;
  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          backgroundColor: Colors.transparent,
          color: colorText ?? const Color.fromARGB(255, 255, 255, 255),
          fontSize: size ?? 16),
    );
  }
}
