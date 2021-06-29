import 'dart:async';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/home/homeIndex.dart';
import 'package:vdkFlutterChat/src/Screeens/login/SignInScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/splash/splash.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/routing/routes.dart';
import 'src/constants/constant.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool state = true;
  bool connectionState = false;
  bool keepShowing = false;
  bool isDeviceConnected = false;
  bool isdev=true;
  StreamSubscription subscription;
  GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    checkStatus();
    checkConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  checkStatus() async {
    if (!kIsWeb) {
      bool connectivity = await DataConnectionChecker().hasConnection;
      print("this is for web $connectivity");
      if (connectivity == true) {
        setState(() {
          state = true;
          print("here in state circle");
        });
      } else {
        setState(() {
          state = false;
        });
      }
    }
  }

  void checkConnectivity() async {
     isDeviceConnected = false;
    if (!kIsWeb) {
      DataConnectionChecker().onStatusChange.listen((status) async {
        print("this on listener");
        isDeviceConnected = await DataConnectionChecker().hasConnection;
        print("this is is connected $isDeviceConnected");
        if (isDeviceConnected == true) {
        
          if (state == true)
            state = false;
          else{
          setState(() {
            isdev=true;
          });
            showSnackbar("Internet Connected", whiteColor, Colors.green, false);}
        } else {
          {
            setState(() {
              isdev=false;
            });
          showSnackbar(
              "No Internet Connection", whiteColor, primaryColor, true);
          }
        }
      });
    }
  }

  showSnackbar(text, Color color, Color backgroundColor, bool check) {
    if (check == false) {
      rootScaffoldMessengerKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 2),
        ));
    } else if (check == true) {
      rootScaffoldMessengerKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(days: 1),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
     //  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            accentColor: primaryColor,
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
                print("thiddfdfbkdfkbndfkn $isdev");
                return HomeIndex(state:isdev);
              } else
                return SignInScreen();
            },
          ),
        ),
      ),
    );
  }
}
