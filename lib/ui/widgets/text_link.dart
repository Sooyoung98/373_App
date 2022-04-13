import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const TextLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
