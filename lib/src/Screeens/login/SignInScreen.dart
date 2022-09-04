import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_wear/vdotok_wear.dart';
import '../../common/ReusableButton.dart';
import '../../common/loadingButton.dart';
import '../../core/providers/auth.dart';
import '../../common/customtextbutton.dart';
import '../../common/logo.dart';
import '../../common/customtextfield.dart';
import '../../common/customtext.dart';
import '../../constants/constant.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginformkey = GlobalKey<FormState>();
  bool _autoValidate = false;

  static const channel = const MethodChannel('myWatchChannel');
  int _counter = 0;

  handlePress() async {
    // VdotokFactory vdotokFactory = VdotokFactory();
    // vdotokFactory.getHeartRate().then((value) {
    //   print('this is value skdkdkdkdkd $value');
    // });

    if (_loginformkey.currentState!.validate()) {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.login(_emailController.text, _passwordController.text);

      if (auth.getUser!.auth_token == null) {
        setState(() {
          _autoValidate = true;
        });
      }

      // _loginBloc
      //     .add(LoginEvent(_emailController.text, _passwordController.text));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  handleButton() {
    Navigator.pushNamed(context, "/register");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    size = MediaQuery.of(context).size;
    print("size ${size!.width}");
    print("width is${size!.width / 22}");
    print("height ${size!.height / 18.66} ");

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
            // resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            //backgroundColor: Colors.amber,
            body: SingleChildScrollView(
              //physics: BouncingScrollPhysics(),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                // color: Colors.black,
                padding: EdgeInsets.only(left: 42, right: 42),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,

                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Logo(),
                    SizedBox(height: 39.64),
                    // CardView(text:"Sign Up to your account"),
                    //    Expanded(
                    Form(
                      key: _loginformkey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Container(
                        width: 290,
                        height: 510,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 32),
                                  CustomText(text: "Sign In"),
                                  SizedBox(height: 34),
                                  // CustomTextField(
                                  //     "Your email", myEmailController, _onchange),
                                  // SizedBox(
                                  //   height: 16,
                                  // ),
                                  CustomTextField(
                                      "Username/Email", _emailController, true),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  CustomTextField(
                                      "Password", _passwordController, false),
                                  //SizedBox(height: 156),

                                  Consumer<AuthProvider>(
                                    builder: (context, auth, child) {
                                      if (auth.loggedInStatus == Status.Failure)
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 17),
                                          child: Text(
                                            auth.loginErrorMsg,
                                            style: TextStyle(color: Colors.red),
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
                                      if (auth.loggedInStatus == Status.Loading)
                                        return LoadingButton();
                                      else
                                        return ReusableButton(
                                            text: "SIGN IN",
                                            handlePress: handlePress);
                                    },
                                  ),
                                  SizedBox(height: 38),
                                  CustomTextButton(
                                    text: "SIGN UP",
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

                    // SizedBox(
                    //   height: 127,
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
      //  ),
    );
  }
}
