import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/home/homeIndex.dart';
import 'package:vdkFlutterChat/src/Screeens/login/SignInScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/splash/splash.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/routing/routes.dart';
import 'src/core/providers/groupListProvider.dart';


GlobalKey<ScaffoldMessengerState>? rootScaffoldMessengerKey;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main()async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
        ChangeNotifierProvider(create: (_) => GroupListProvider())
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            hintColor: primaryColor,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: secondaryColor),
              bodyText2: TextStyle(color: secondaryColor), //Text
            )),
        onGenerateRoute: Routers.generateRoute,
        home: Scaffold(
          body: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.loggedInStatus == Status.Authenticating)
                return SplashScreen();
              else if (auth.loggedInStatus == Status.LoggedIn) {
                return HomeIndex();
              } else
                return SignInScreen();
            },
          ),
        ),
      ),
    );
  }
}
