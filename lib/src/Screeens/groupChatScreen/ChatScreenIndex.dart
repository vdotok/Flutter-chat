import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';

import 'ChatScreen.dart';

class ChatScreenIndex extends StatefulWidget {
  final bool? activeCall;
  //bool state;
  final handlePress;
  final  int index;
  final publishMessage;
  // final VoidCallback  callbackfunction;
  final MainProvider mainProvider;
  final ContactProvider contactprovider;
  final funct;

  ChatScreenIndex({
    required this.index,
    this.publishMessage,
    required this.mainProvider,
    this.funct,
    required this.contactprovider,
    this.handlePress,
     this.activeCall,
  });
  @override
  _ChatScreenIndexState createState() => _ChatScreenIndexState();
}

class _ChatScreenIndexState extends State<ChatScreenIndex> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("index in chat screen index ${widget.index}");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ContactProvider()),
          ChangeNotifierProvider(create: (context) => MainProvider()),
        ],
        child: ChatScreen(
          index: widget.index,
          publishMessage: widget.publishMessage,
          mainProvider: widget.mainProvider,
          contactProvider: widget.contactprovider,
        )
        //callbackfunction:widget.callbackfunction)
        );
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
