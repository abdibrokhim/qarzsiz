import 'package:flutter/material.dart';

Widget buildIconButton({required IconData icon, required String text, VoidCallback? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}