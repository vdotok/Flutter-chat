import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/Header_file.dart';
import '../../common/Passwordfield.dart';
import '../../common/SignIn_Button.dart';
import '../../common/TextField_file.dart';
import '../../common/loadingButton.dart';
import '../../core/providers/auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerformkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    // MyKey.scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  }

  handlePress() async {
    if (_registerformkey.currentState.validate()) {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      bool res = await auth.register(_emailController.text, _passwordController.text,"");
      if (auth.getUser.auth_token == null || auth.getUser.auth_token.isEmpty) {
        setState(() {
          _autoValidate = true;
        });
      }
      if (res) Navigator.pop(context);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: MyKey.scaffoldKey,
      appBar: AppBar(
        title: Text("Register user"),
      ),
      body: SingleChildScrollView(
        child: Container(
          //color: screenbackgroundColor,
          child: Form(
            key: _registerformkey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                HeaderFile(
                    headername: 'Create a user',
                    textname: 'Register with username and password.'),
                SizedBox(height: 30),
                TextFieldFile(
                    name: "User Name", myController: _emailController),
                SizedBox(height: 10),
                PasswordFieldFile(
                    name: "Password", myController: _passwordController),
                SizedBox(height: 15),
                // Text(
                //   errorMsg,
                //   style: TextStyle(color: Colors.red, fontSize: 12),
                // ),
                SizedBox(height: 50),
                // SingnInGoogle_Button(
                //   onPressed: handleGoogleLogin,
                //   name: "Sign In with Google",
                // ),
                // SizedBox(height: 15),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.registeredInStatus == Status.Failure)
                      return Text(
                        auth.registerErrorMsg,
                        style: TextStyle(color: Colors.red),
                      );
                    else
                      return Container();
                  },
                ),
                SizedBox(height: 15),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.registeredInStatus == Status.Loading)
                      return LoadingButton();
                    else
                      return SignInButtonFile(
                        name: "Register",
                        handlePress: handlePress,
                      );
                  },
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
