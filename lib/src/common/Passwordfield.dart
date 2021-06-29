import 'package:flutter/material.dart';
import '../constants/constant.dart';

class PasswordFieldFile extends StatefulWidget {
  String name;
  var myController = TextEditingController();
  PasswordFieldFile({Key key, this.name, this.myController}) : super(key: key);
  @override
  _WidgetHeaderState createState() => _WidgetHeaderState();
}

class _WidgetHeaderState extends State<PasswordFieldFile> {
  get myController => widget.myController;
  @override
  void initState() {
    super.initState();
    //print("this is my header name ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: EdgeInsets.all(0.0),
      width: 335,
      // height: 54,
      color: textfieldBackgrounColor,
      child: TextFormField(
        obscureText: true,
        controller: myController,
        validator: (value) {
          if (value.isEmpty) return "Field cannot be empty";
          if (value.length < 6)
            return "Entry should be at least 6 characters long";
          if (value.length > 14) return "Entry should not exceed 14 characters";
          if (value.indexOf(' ') >= 0)
            return "Field cannot contain blank spaces";
          else
            return null;
        },
        decoration: new InputDecoration(
          //  errorStyle: TextStyle(height: 0.4),
          border: OutlineInputBorder(),
          // contentPadding: EdgeInsets.only(left: 10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: redColor, width: 1.0),
          ),
          hintText: "${widget.name}",
          hintStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              fontFamily: font_Family,
              fontStyle: FontStyle.normal,
              color: placeholderTextColor),
        ),
      ),
    );
  }
}
