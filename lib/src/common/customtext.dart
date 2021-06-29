import 'package:flutter/material.dart';
import '../constants/constant.dart';

class CustomText extends StatelessWidget {
  final text;

  const CustomText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$text',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal),
      ),
    );
  }
}
