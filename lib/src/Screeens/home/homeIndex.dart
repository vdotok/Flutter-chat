import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import '../home/home.dart';
import '../../core/providers/groupListProvider.dart';

class HomeIndex extends StatefulWidget {
 
  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

 

  @override
  
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider(create: (context) => ContactProvider()),
      ChangeNotifierProvider<GroupListProvider>(
        create: (context) => GroupListProvider(),
      ),
      ChangeNotifierProvider(create: (context) => MainProvider()),
    ], child: Home());
  }
}

