import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../../core/providers/groupListProvider.dart';

class HomeIndex extends StatefulWidget {
  bool state;
  HomeIndex ({this.state});
  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // onPressed() {
  //   Provider.of<AuthProvider>(context).logout();
  // }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ElevatedButton(onPressed: onPressed, child: Text("logout")),
  //   );
  // }
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<GroupListProvider>(
        create: (context) => GroupListProvider(),
      )
    ], child: Home(widget.state));
  }
}

// class  extends StatefulWidget {
//   @override
//   _State createState() => _State();
// }

// class _State extends State<> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
