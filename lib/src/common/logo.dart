import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 84, 0, 0),
      child: Image.asset(
        'assets/logo.png',
        width: 68,
        height: 50.36,
      ),
    );
  }
}
