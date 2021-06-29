import 'package:flutter/material.dart';
import '../constants/constant.dart';

class LoadingButton extends StatefulWidget {
  @override
  _WidgetHeaderState createState() => _WidgetHeaderState();
}

class _WidgetHeaderState extends State<LoadingButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 160.0,
      height: 48.0,
      decoration: BoxDecoration(
          color: greenColor, borderRadius: BorderRadius.circular(5.0)),
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(chatRoomColor),
      )),
    );
  }
}
