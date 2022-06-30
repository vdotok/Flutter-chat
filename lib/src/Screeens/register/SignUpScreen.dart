import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../common/loadingButton.dart';
import '../../core/providers/auth.dart';
import '../../common/customtextbutton.dart';
import '../../common/logo.dart';
import '../../common/ReusableButton.dart';
import '../../common/customtextfield.dart';
import '../../common/customtext.dart';
import '../../constants/constant.dart';
import 'package:vdotok_wear/vdotok_wear.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _registerformkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autoValidate = false;
  bool emailvalidate = false;
  bool passwordvalidate = false;
  bool namevalidate = false;
  Size? size;
  final _vdotokWearPlugin = VdotokWear();
// only commited in taimoor branch
  handlePress() async {
    _vdotokWearPlugin
        .getPlatformVersion(
            "getPlatformVersion", {"message": _nameController.text})
        .then((value) {})
        .catchError((onError) {
          print("this is error $onError");
        });
    // if (_registerformkey.currentState!.validate()) {
    //   AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    //   bool res = await auth.register(
    //     _nameController.text,
    //     _passwordController.text,
    //     _emailController.text,
    //   );
    //   if (auth.getUser!.auth_token == null) {
    //     setState(() {
    //       _autoValidate = true;
    //     });
    //   }
    //   if (res) Navigator.pop(context);
    // } else {
    //   setState(() {
    //     _autoValidate = true;
    //   });
    // }
  }

  handleButton() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _passwordController.text = "12345678";
      _emailController.text = "Taimoor@gmail.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));

    size = MediaQuery.of(context).size;
    print("The size is : ${size!.height * 1.08}");
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFous = FocusScope.of(context);
          if (!currentFous.hasPrimaryFocus) {
            currentFous.unfocus();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                backgroundGradientColor,
                backgroundGradientColor2,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 42, right: 42),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Logo(),
                          SizedBox(height: 39.64),
                          Form(
                            autovalidateMode: AutovalidateMode.always,
                            key: _registerformkey,
                            child: Container(
                              width: 290,
                              height: 510,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 32),
                                        CustomText(
                                            text: "Sign Up to your account"),
                                        SizedBox(height: 34),
                                        CustomTextField(
                                            "Username", _nameController, true),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        CustomTextField("Email Address",
                                            _emailController, true),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        CustomTextField("Password",
                                            _passwordController, false),
                                        Consumer<AuthProvider>(
                                          builder: (context, auth, child) {
                                            if (auth.registeredInStatus ==
                                                Status.Failure)
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 17),
                                                child: Text(
                                                  auth.registerErrorMsg,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              );
                                            else
                                              return Container();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Consumer<AuthProvider>(
                                            builder: (context, auth, child) {
                                          if (auth.registeredInStatus ==
                                              Status.Loading)
                                            return LoadingButton();
                                          else
                                            return ReusableButton(
                                                text: "SIGN UP",
                                                handlePress: handlePress);
                                        }),
                                        SizedBox(height: 38),
                                        CustomTextButton(
                                          text: "SIGN IN",
                                          handlePress: handleButton,
                                        ),
                                        SizedBox(height: 36),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              // ),
            )));
  }
}
