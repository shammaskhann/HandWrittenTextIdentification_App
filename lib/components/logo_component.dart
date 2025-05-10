import 'package:flutter/material.dart';

Widget getLogo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/logo.png',
        height: 40,
      ),
      const SizedBox(width: 12),
      const Text(
        'ScriptSense',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ],
  );
}
