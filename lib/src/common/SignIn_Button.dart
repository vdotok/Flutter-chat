import 'package:flutter/material.dart';
import '../constants/constant.dart';

class SignInButtonFile extends StatefulWidget {
  String? name;
  final handlePress;
  bool _autoValidate = true;
  var myController = TextEditingController();
  SignInButtonFile({Key? key, this.name, this.handlePress}) : super(key: key);
  @override
  _WidgetHeaderState createState() => _WidgetHeaderState();
}

class _WidgetHeaderState extends State<SignInButtonFile> {
  get myController => widget.myController;

  get handlePress => this.handlePress;
  @override
  void initState() {
    super.initState();
    //print("this is my header name ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 300.0,
      height: 48.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // primary: Colors.purple,
          primary: redColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        // shape: new RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(5.0)),
        onPressed: () async {
          widget.handlePress();
        },
        child: Text(
          "${widget.name}",
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              fontFamily: font_Family,
              fontStyle: FontStyle.normal,
              color: whiteColor),
          textAlign: TextAlign.center,
        ),
        // textColor: Colors.white,
        // color: redColor,
      ),
    );
  }
}

//void onSomeEvent() {
//print('i am in parent function');
//}
