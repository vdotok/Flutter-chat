import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/ContactListScreen/ContactListIndex.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreen.dart';
import '../Screeens/CreateGroupScreen/CreateGroupChatIndex.dart';
import '../Screeens/login/SignInScreen.dart';
import '../Screeens/register/SignUpScreen.dart';
import '../Screeens/home/homeIndex.dart';
import '../routing/ErrorRoute.dart';
import '../core/providers/groupListProvider.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    print("these are arguments ${settings.arguments}");
    print("these are arguments ${settings.name}");
    switch (settings.name) {
      case '/signin':
        return PageTransition(
            child: SignInScreen(), type: PageTransitionType.rightToLeft);
        break;
      case '/register':
        return PageTransition(
            child: SignUpScreen(), type: PageTransitionType.rightToLeft);
        break;
      case '/home':
        return PageTransition(
            child: HomeIndex(
               
                ),
            type: PageTransitionType.rightToLeft);
        break;
//       case '/contactlist':
//  Map<String, dynamic> params = args;
//        {return PageTransition(
//             child: ListenableProvider<GroupListProvider>.value(
//               value: params["groupListProvider"],
//               child: ContactListIndex(
//                 contactProvider:params["contactProvider"]

//               ),
//             ),
//             type: PageTransitionType.rightToLeft);}
        break;
      // case '/createGroup':
      //   return PageTransition(
      //       child: ListenableProvider<GroupListProvider>.value(
      //         value: args,
      //         child: CreateGroupChatIndex(),
      //       ),
      //       type: PageTransitionType.rightToLeft);
      //   break;
      case '/chatScreen':
        {
          Map<String, dynamic>? params = args as Map<String, dynamic>?;
          return PageTransition(
              child: ListenableProvider<GroupListProvider>.value(
                value: params!["groupListProvider"],
                child: ChatScreen(
                  index: params["index"],
                  publishMessage: params["publishMessage"],
                ),
              ),
              type: PageTransitionType.rightToLeft);
        }
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => ErrorRoute(routename: settings.name));
    }
  }
}
