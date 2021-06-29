import 'package:flutter/material.dart';

class CustomFloating extends StatefulWidget {
  CustomFloating({
    Key key,
  }) : super(key: key);

  @override
  _CustomFloatingState createState() => _CustomFloatingState();
}

class _CustomFloatingState extends State<CustomFloating> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: "2",
        child: Icon(Icons.add),
        onPressed: () async {
        });
  }
}
