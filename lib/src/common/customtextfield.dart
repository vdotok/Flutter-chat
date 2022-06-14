import 'package:flutter/material.dart';
import '../constants/constant.dart';

//class customTextField extends
class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  bool checkFocus;

  CustomTextField(this.text, this.controller, this.checkFocus);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final String error = '';
  late Size size;

  RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp userNameRegex = new RegExp(r"^[a-zA-Z0-9_]+$");
  RegExp allowNumber = new RegExp(r"^[0-9]*$");
  //RegExp nameRegex = new RegExp(r"^[a-zA-Z]+([_a-zA-Z0-9_]+)*$");
  String email = '';

  String password = '';

  get myController => widget.controller;
  get focusnode => widget.checkFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      //   width: 256,
      padding: EdgeInsets.symmetric(horizontal: 17),
      //  height: 38,
      child: TextFormField(
          controller: myController,
          //   maxLines: null,
          textInputAction:
              focusnode == true ? TextInputAction.next : TextInputAction.done,
          obscureText: widget.text == "Password" ? true : false,
          style: TextStyle(color: textTypeColor),
          decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: chatRoomBackgroundColor,
              hoverColor: greycolor,
              hintText: this.widget.text,
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: tileGreenColor,
                  fontFamily: secondaryFontFamily),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: lightgreycolor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: lightGreyColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: focusedBorderColor))),
      validator: (value) {
            if (value!.isEmpty) {
              print("The value:${value}");
              return "Field cannot be empty";
            }
            if (widget.text == "Username" && value.length < 4)
              return "Min 4 to 20 characters ";
            if (widget.text == "Username" && (!userNameRegex.hasMatch(value)))
              return "Just alphanumeric characters are allowed.";
            if (widget.text == "Username" && (allowNumber.hasMatch(value)))
              return "Just numeric values are not allowed.";
            if (widget.text == "Username" && value.length > 20)
              return "Maximum 20 characters";
            if (widget.text == "Password" && value.length < 8)
              return "Minimum 8 characters";
            if (widget.text == "Password" && value.length > 14)
              return "Maximum 14 characters";
            if (value.indexOf(' ') >= 0)
              return "Field cannot contain blank spaces";
            if ((this.widget.text == "Email Address") &&
                (!emailRegex.hasMatch(value)))
              return 'Please enter a valid email';
            else
              return null;
          }
          ),
    );
  }
}
