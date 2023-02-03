import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/ContactListScreen/ContactListIndex.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupChatIndex.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdkFlutterChat/src/Screeens/GroupListScreen/groupListScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreenIndex.dart';
import 'package:vdkFlutterChat/src/core/config/config.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../../main.dart';
import '../home/CustomAppBar.dart';
import '../splash/splash.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';
import '../../jsManager/jsManager.dart';
import '../../Screeens/home/NoChatScreen.dart';

Emitter emitter = Emitter.instance..checkConnectivity();
bool isInternetConnect = true;
List<String> strArr = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final _groupNameController = TextEditingController();
  late AuthProvider authProvider;
  late GroupListProvider groupListProvider;
  bool isSocketConnect = true;
  late MainProvider _mainProvider;
  late ContactProvider contactProvider;
  bool isResumed = true;
  bool inPaused = false;

  bool inInactive = false;

  List<Uint8List> listOfChunks = [];
  late Map<String, dynamic> header;
  bool scrollUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
    emitter.connect(
        clientId: authProvider.getUser!.user_id.toString(),
        reconnectivity: true,
        refID: authProvider.getUser!.ref_id,
        authorization_token: authProvider.getUser!.authorization_token,
        project_id: project_id,
        host: authProvider.host,
        port: authProvider.port);
    print("host ${authProvider.host}");
    emitter.onConnect = (res) {
      print('this is response on connect $res');
      if (res) {
        groupListProvider.getGroupList(authProvider.getUser!.auth_token);
        contactProvider.getContacts(authProvider.getUser!.auth_token);

        print("Connected Successfully $res");
        setState(() {
          isSocketConnect = true;
        });
        print("this is  connectttttttttttt before $isSocketConnect");
      } else {
        print("connection error $res");
        setState(() {
          isSocketConnect = false;
        });
        if (authProvider.loggedInStatus == Status.LoggedOut) {
        } else {
          if (isInternetConnect == true) {
            emitter.connect(
                clientId: authProvider.getUser!.user_id.toString(),
                reconnectivity: true,
                refID: authProvider.getUser!.ref_id,
                authorization_token: authProvider.getUser!.authorization_token,
                project_id: project_id,
                host: authProvider.host,
                port: authProvider.port
                //response: sharedPref.read("authUser");
                );
          }
        }
        print("this is  connectttttttttttt  after $isSocketConnect");
      }
    };

    emitter.internetConnectivityCallBack = (mesg) {
      print("this is sockett internet casll back $mesg");
      if (mesg == "Connected") {
        setState(() {
          isInternetConnect = true;
          isSocketConnect = true;
        });
        if (isResumed) {
          Fluttertoast.showToast(
              msg: "Connected to Internet.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_RIGHT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 14.0);
        }
        //groupListProvider.getGroupList(authProvider.getUser.auth_token);
        //showSnackbar("Internet Connected", whiteColor, Colors.green, false);
      } else {
        setState(() {
          isInternetConnect = false;
          isSocketConnect = false;
        });
          if(isResumed)
        { Fluttertoast.showToast(
                        msg: "Waiting for Internet.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP_RIGHT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 14.0);}
     //   showSnackbar("No Internet Connection", whiteColor, primaryColor, true);
      }
    };
    emitter.onPresence = (res) {
      print("This is emitter onPresence  in hoome  $res");

      groupListProvider.handlePresence(json.decode(res));
    };

    emitter.onsubscribe = (value) {
      print(("subscription homee $value"));
      if (value ==
          groupListProvider.groupList.groups!.last!.channel_key +
              "/" +
              groupListProvider.groupList.groups!.last!.channel_name) {
        groupListProvider.changeState();
      }
    };

    emitter.onMessage = (msg) async {
      print("this is msg on receive $msg");
      var message = json.decode(msg);
      // print("this is msg on receive ${message["content"].toString()}");

      // print(
      //     "message after receiving ${utf8.decode(message["content"].toString().codeUnits)}");
      switch (message["type"]) {
        case MessageType.text:
          {
            if (authProvider.getUser!.ref_id != message["from"]) {
              if (groupListProvider.currentOpendChat != null) {
                if (groupListProvider.currentOpendChat!.channel_key ==
                    message["key"]) {
                  print("samee channel oppeened text");
                  var receiptMsg = message;
                  receiptMsg["status"] = ReceiptType.seen;
                  Map<String, dynamic> tempData = {
                    "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                    "from": authProvider.getUser!.ref_id,
                    "key": message["key"],
                    "messageId": message["id"],
                    "receiptType": ReceiptType.seen,
                    "to": message["to"],
                    // "content": utf8.decode((message["content"].toString().codeUnits))
                  };

                  groupListProvider.recevieMsg(receiptMsg);
                  emitter.publish(
                      groupListProvider.currentOpendChat!.channel_key,
                      groupListProvider.currentOpendChat!.channel_name,
                      tempData,
                      0);
                } else {
                  groupListProvider.recevieMsg(message);
                }
              } else {
                print("this is eelsee");
                groupListProvider.recevieMsg(message);
              }
            } else {
              // here i'm getting my delivered message
              groupListProvider.changeMsgStatusToDelivered(
                  message, ReceiptType.delivered);
            }
          }
          break;

        case MessageType.typing:
          {
            if (authProvider.getUser!.ref_id != message["from"]) {
              groupListProvider.updateTypingStatus(msg);
            }
          }
          break;
        case MediaType.ftp:
          {
            if (authProvider.getUser!.ref_id != message["from"]) {
              if (groupListProvider.currentOpendChat != null) {
                //if same channel is opened
                if (groupListProvider.currentOpendChat!.channel_key ==
                    message["key"]) {
                  print(
                      "samee channel oppeeeeeeened ${message["date"]}  ${message["content"]}  ");
                  var receiptMsg = message;
                  receiptMsg["status"] = ReceiptType.seen;

                  // groupListProvider.recevieMsg(receiptMsg);
                  if (!kIsWeb) {
                    print(
                        "this is messag content ${message["content"].toString()}");
                    //     var response = await http.get(Uri.parse(message["content"].toString()));
                    //  print("ths is parse responseeeeeeeee ${response.bodyBytes}");
                    var extension = message["fileExtension"];
                    // message["fileExtension"].toString().contains(".")
                    //     ? message["fileExtension"]
                    //     : '.' + message["fileExtension"];
                    print("this is tempData ${extension}");
                    //  final tempDir = await getTemporaryDirectory();

                    // File file = await File(
                    //         '${tempDir.path}/vdktok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
                    //     .create();
                    //     print("this is filllleee ${file}");
                    // file.writeAsBytesSync(response.bodyBytes);

                    //   receiptMsg["content"] = file;
                    // message["id"] = message["messageId"];
                  } else {
                    print('inelseofFirst');
                    final url = await JsManager.instance!.connect(
                        base64.decode(receiptMsg["content"]),
                        receiptMsg["fileExtension"]);
                    print('thisisUrlofFile$url');
                    if (receiptMsg["type"] == MediaType.image) {
                      var image = base64Decode(receiptMsg['content']);
                      receiptMsg['content'] = image;
                    } else {
                      receiptMsg["content"] = url;
                    }
                    groupListProvider.recevieMsg(receiptMsg);
                  }
                  // Map<String, dynamic> tempData = {
                  //   "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                  //   "from": authProvider.getUser!.ref_id,
                  //   "key": message["key"],
                  //   "messageId": message["messageId"],
                  //   "receiptType": ReceiptType.seen,
                  //   "to": message["topic"]
                  // };
                  Map<String, dynamic> tempData = {
                    "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                    "from": authProvider.getUser!.ref_id,
                    "key": message["key"],
                    "messageId": message["id"],
                    "receiptType": ReceiptType.seen,
                    "to": message["to"],
                    // "content": utf8.decode((message["content"].toString().codeUnits))
                  };
                  print("this is temp dataaaaaaa $tempData ");
                  groupListProvider.recevieMsg(receiptMsg);
                  emitter.publish(
                      groupListProvider.currentOpendChat!.channel_key,
                      groupListProvider.currentOpendChat!.channel_name,
                      tempData,
                      0);
                }
                // if same channel in not opened
                else {
                  if (!kIsWeb) {
                    var extension =
                        message["fileExtension"].toString().contains(".")
                            ? message["fileExtension"]
                            : '.' + message["fileExtension"];
                    print(
                        "this is extension ${message["fileExtension"].toString().contains(".") ? message["fileExtension"] : '.' + message["fileExtension"]}");
                    final tempDir = await getTemporaryDirectory();
                    File file = await File(
                            '${tempDir.path}/vdotok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
                        .create();
                    //  file.writeAsBytesSync(message["content"]);
                    message["content"] = file;
                    groupListProvider.recevieMsg(message);
                  } else {
                    final url = await JsManager.instance!.connect(
                        base64.decode(message["content"]),
                        message["fileExtension"]);
                    print('thisisUrlofFile$url');
                    if (message["type"] == MediaType.image) {
                      var image = base64Decode(message['content']);
                      message['content'] = image;
                    } else {
                      message["content"] = url;
                    }
                    print('thisiscontentofFile${message['content']}');
                    groupListProvider.recevieMsg(message);
                  }
                }
              } else {
                print("this is eelsee");
                if (!kIsWeb) {
                  print(
                      "this is messag contentttttttt ${message["content"].toString()}");
                  //  var response = await http.get(Uri.parse(message["content"].toString()));
                  //  print("ths is parse response ${response.bodyBytes}");
                  // final tempDir = await getTemporaryDirectory();
                  // var extension =
                  //     message["fileExtension"].toString().contains(".")
                  //         ? message["fileExtension"]
                  //         : '.' + message["fileExtension"];

                  // File file = await File(
                  //         '${tempDir.path}/vdotok${DateTime.now().toString().trim()}$extension')
                  //     .create();
                  // file.writeAsBytesSync(message["content"]);
                  // file.writeAsBytesSync(base64.decode(base64.encode(response.bodyBytes)));
                  // message["content"] = file;
                  groupListProvider.recevieMsg(message);
                } else {
                  final url = await JsManager.instance!.connect(
                      base64.decode(message["content"]),
                      message["fileExtension"]);

                  if (message["type"] == MediaType.image) {
                    var image = base64Decode(message['content']);
                    print('thisis Image bytes $image');
                    message['content'] = image;
                  } else {
                    message["content"] = url;
                  }
                  print('thisiscontentofFile${message['content']}');
                  groupListProvider.recevieMsg(message);
                }
              }
            } else {
              // this is sender mesgsss
              print("hdsghdsgdhsds");
              groupListProvider.changeMsgStatusToDelivered(
                  message, ReceiptType.delivered);
            }
          }
          break;
        default:
          {
            if (message["receiptType"] == ReceiptType.seen)
              print("this is messggddddg $msg");
            groupListProvider.changeMsgStatus(msg, ReceiptType.seen);
          }
          break;
      }

      // if (

      //      message["type"] == MediaType.ftp
      //     ) {
      //receiver side
      // if (authProvider.getUser!.ref_id != message["from"]) {
      //   if (groupListProvider.currentOpendChat != null) {
      //     //if same channel is opened
      //     if (groupListProvider.currentOpendChat!.channel_key ==
      //         message["key"]) {
      //       print("samee channel oppeened ${message["date"]}  ${message}  ");
      //       var receiptMsg = message;
      //       receiptMsg["status"] = ReceiptType.seen;

      //       // groupListProvider.recevieMsg(receiptMsg);
      //       if (!kIsWeb) {
      //         print("this is messag content ${message["content"].toString()}");
      //       //     var response = await http.get(Uri.parse(message["content"].toString()));
      //       //  print("ths is parse responseeeeeeeee ${response.bodyBytes}");
      //         var extension =
      //             message["fileExtension"].toString().contains(".")
      //                 ? message["fileExtension"]
      //                 : '.' + message["fileExtension"];
      //         print("this is tempData ${extension}");
      //         final tempDir = await getTemporaryDirectory();
      //         File file = await File(
      //                 '${tempDir.path}/vdktok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
      //             .create();
      //             file.writeAsBytesSync(message["content"]);
      //        //  file.writeAsBytesSync(base64.decode(base64.encode(response.bodyBytes)));
      //         receiptMsg["content"] = file;
      //         message["id"] = message["messageId"];
      //         groupListProvider.recevieMsg(message);
      //       }
      //       // else {
      //       //   print('inelseofFirst');
      //       //   final url = await JsManager.instance!.connect(
      //       //       base64.decode(receiptMsg["content"]),
      //       //       receiptMsg["fileExtension"]);
      //       //   print('thisisUrlofFile$url');
      //       //   if (receiptMsg["type"] == MediaType.image) {
      //       //     var image = base64Decode(receiptMsg['content']);
      //       //     receiptMsg['content'] = image;
      //       //   } else {
      //       //     receiptMsg["content"] = url;
      //       //   }
      //       //   groupListProvider.recevieMsg(receiptMsg);
      //       // }
      //       Map<String, dynamic> tempData = {
      //         "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
      //         "from": authProvider.getUser!.ref_id,
      //         "key": message["key"],
      //         "messageId": message["messageId"],
      //         "receiptType": ReceiptType.seen,
      //         "to": message["topic"]
      //       };

      //       print("this is temp data $tempData ${message["to"]}");

      //       emitter.publish(groupListProvider.currentOpendChat!.channel_key,
      //           groupListProvider.currentOpendChat!.channel_name, tempData);
      //     }
      //     // if same channel in not opened
      //     else {
      //       if (!kIsWeb) {
      //         var extension =
      //             message["fileExtension"].toString().contains(".")
      //                 ? message["fileExtension"]
      //                 : '.' + message["fileExtension"];
      //         print(
      //             "this is extension ${message["fileExtension"].toString().contains(".") ? message["fileExtension"] : '.' + message["fileExtension"]}");
      //         final tempDir = await getTemporaryDirectory();
      //         File file = await File(
      //                 '${tempDir.path}/vdotok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
      //             .create();
      //         file.writeAsBytesSync(message["content"]);
      //         message["content"] = file;
      //         groupListProvider.recevieMsg(message);
      //       }
      //       // else {
      //       //   final url = await JsManager.instance!.connect(
      //       //       base64.decode(message["content"]),
      //       //       message["fileExtension"]);
      //       //   print('thisisUrlofFile$url');
      //       //   if (message["type"] == MediaType.image) {
      //       //     var image = base64Decode(message['content']);
      //       //     message['content'] = image;
      //       //   } else {
      //       //     message["content"] = url;
      //       //   }
      //       //   print('thisiscontentofFile${message['content']}');
      //       //   groupListProvider.recevieMsg(message);
      //       // }
      //     }
      //   } else {
      //     print("this is eelsee");
      //     if (!kIsWeb) {
      //       print("this is messag contentttttttt ${message["content"].toString()}");
      //       //  var response = await http.get(Uri.parse(message["content"].toString()));
      //       //  print("ths is parse response ${response.bodyBytes}");
      //       final tempDir = await getTemporaryDirectory();
      //       var extension = message["fileExtension"].toString().contains(".")
      //           ? message["fileExtension"]
      //           : '.' + message["fileExtension"];

      //       File file = await File(
      //               '${tempDir.path}/vdotok${DateTime.now().toString().trim()}$extension')
      //           .create();
      //           file.writeAsBytesSync(message["content"]);
      //       // file.writeAsBytesSync(base64.decode(base64.encode(response.bodyBytes)));
      //       message["content"] = file;
      //       groupListProvider.recevieMsg(message);
      //     }
      //     // else {
      //     //   final url = await JsManager.instance!.connect(
      //     //       base64.decode(message["content"]), message["fileExtension"]);

      //     //   if (message["type"] == MediaType.image) {
      //     //     var image = base64Decode(message['content']);
      //     //     print('thisis Image bytes $image');
      //     //     message['content'] = image;
      //     //   } else {
      //     //     message["content"] = url;
      //     //   }
      //     //   print('thisiscontentofFile${message['content']}');
      //     //   groupListProvider.recevieMsg(message);
      //     // }
      //   }
      // } else {
      //   // this is sender mesgsss
      //   groupListProvider.changeMsgStatusToDelivered(
      //       message, ReceiptType.delivered);
      // }
      // }
    };
  }

  showSnackbar(text, Color color, Color backgroundColor, bool check) {
    if (check == false) {
      rootScaffoldMessengerKey!.currentState!
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
      rootScaffoldMessengerKey!.currentState!
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(days: 365),
        ));
    }
  }

  Future<Null> refreshList() async {
    print("here in refresh listtttt");
    setState(() {
      renderList();
      // rendersubscribe();
    });
    return;
  }

// publishMessage(key, channelname, sendmessage) {
//     print("print im here ");
//     print("The key:$key....$channelname...$sendmessage");
//     emitter.publish(key, channelname, sendmessage);
//   }
  renderList() {
    if (groupListProvider.groupListStatus == ListStatus.Scussess) {
      groupListProvider.getGroupList(authProvider.getUser!.auth_token);
    } else {
      contactProvider.getContacts(authProvider.getUser!.auth_token);
      //_selectedContacts.clear();
    }
    if (isSocketConnect == false && isInternetConnect) {
      print("here in refreshlist connection");
      emitter.connect(
          clientId: authProvider.getUser!.user_id.toString(),
          reconnectivity: true,
          refID: authProvider.getUser!.ref_id,
          authorization_token: authProvider.getUser!.authorization_token,
          project_id: project_id,
          host: authProvider.host,
          port: authProvider.port
          //response: sharedPref.read("authUser");
          );
    }
  }

  publishMessage(channelKey, channelName, send_message) {
    print("chat screen message");
    emitter.publish(channelKey, channelName, send_message, 0);
  }

  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) async {
    print("this is changeapplifecyclestate $appLifecycleState");

    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        isResumed = true;
        inInactive = false;
        inPaused = false;
        if (authProvider.loggedInStatus == Status.LoggedOut) {
        } else {
          //  print("this is variable for resume $sockett $isConnected");
          bool status = await emitter.checkInternetConnectivity();

          if (status == false) {
            Fluttertoast.showToast(
                msg: "Waiting for Internet.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_RIGHT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 14.0);
          } else {
            // Fluttertoast.showToast(
            //     msg: "Connected to Internet.",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.TOP_RIGHT,
            //     timeInSecForIosWeb: 1,
            //     backgroundColor: Colors.black,
            //     textColor: Colors.white,
            //     fontSize: 14.0);
          }
          if (status == true && isSocketConnect == false) {
            emitter.connect(
                clientId: authProvider.getUser!.user_id.toString(),
                reconnectivity: true,
                refID: authProvider.getUser!.ref_id,
                authorization_token: authProvider.getUser!.authorization_token,
                project_id: project_id,
                host: authProvider.host,
                port: authProvider.port
                //response: sharedPref.read("authUser");
                );
          }
        }
        // else if (isSocketConnect == true) {
        // } else if (

        //   isInternetConnect && isSocketConnect == false) {
        //   print("here in resume");

        //   emitter.connect(
        //       clientId: authProvider.getUser!.user_id.toString(),
        //       reconnectivity: true,
        //       refID: authProvider.getUser!.ref_id,
        //       authorization_token: authProvider.getUser!.authorization_token,
        //       project_id: project_id,
        //       host: authProvider.host,
        //       port: authProvider.port
        //       //response: sharedPref.read("authUser");
        //       );
        // }
// signalingClient.sendPing();

        break;

      case AppLifecycleState.inactive:
        print("app in inactive");
        inInactive = true;
        isResumed = false;
        inPaused = false;

        break;

      case AppLifecycleState.paused:
        print("app in paused");
        inPaused = true;
        inInactive = false;
        isResumed = false;

// signalingClient.socketDrop();

        break;

      case AppLifecycleState.detached:
        //signalingClient.unRegister(registerRes["mcToken"]);

        print("app in detached");

        break;
    }

    //super.didChangeAppLifecycleState(appLifecycleState);

// _isInForeground = state == AppLifecycleState.resumed;
  }

  handleCreateGroup(HomeStatus state) {
    print("here in handle create group $state");
    _mainProvider.handleState(state);
    // _mainProvider.inActiveCallCreateGroup(startCall: _startCall);
  }

  String _presenceStatus = "";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    Future<bool> _onWillPop() async {
      // _groupListProvider.handlBacktoGroupList(index);
      if (strArr.last == "ChatScreen") {
        print("here in willpop chat");
        _mainProvider.homeScreen();
        strArr.remove("ChatScreen");
      } else if (strArr.last == "CreateGroupChat") {
        _mainProvider.createIndividualGroupScreen();
        strArr.remove("CreateGroupChat");
      } else if (strArr.last == "CreateIndividualGroup") {
        _mainProvider.homeScreen();
        strArr.remove("CreateGroupChat");
      } else if (strArr.last == "GroupList") {
        return true;
      } else if (strArr.last == "NoChat") {
        return true;
        // SystemNavigator.pop();
      }

      return false;
    }

    GroupListProvider groupListProvider =
        Provider.of<GroupListProvider>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer4<GroupListProvider, AuthProvider, MainProvider,
                ContactProvider>(
            builder: (context, listProvider, authProvider, mainProvider,
                contactProvider, child) {
          //When the Screen is Laoding//
          if (listProvider.groupListStatus == ListStatus.Loading)
            return SplashScreen();
          else if (contactProvider.contactState == ContactStates.Loading)
            return SplashScreen();
          //In case of success//
          else if (listProvider.groupListStatus == ListStatus.Scussess &&
              contactProvider.contactState == ContactStates.Success) {
            if (_mainProvider.homeStatus == HomeStatus.Home) {
              //Screen when there is no group or chat in Chat Room//
              if (listProvider.groupList.groups!.length == 0) {
                if (strArr.contains("NoChat")) {
                } else {
                  strArr.add("NoChat");
                }

                print("this is strarray1 $strArr");
                print("no chat screen");
                return NoChatScreen(
                  handlePress: handleCreateGroup,
                  mainProvider: _mainProvider,
                  isConnect: isSocketConnect,
                  state: isInternetConnect,
                  groupListProvider: groupListProvider,
                  emitter: emitter,
                  refreshList: refreshList,
                  authProvider: authProvider,
                  presentCheck: true,
                );
              }

              //Screen with chats in Chat Room//
              else {
                if (strArr.contains("GroupList")) {
                } else {
                  strArr.add("GroupList");
                }
                print("this is strarray2 $strArr");
                print("this is group list screen");
                return GroupListScreen(
                    handlePress: handleCreateGroup,
                    groupListProvider: groupListProvider,
                    contactProvider: contactProvider,
                    authProvider: authProvider,
                    chatSocket: isSocketConnect,
                    refreshList: refreshList,
                    publishMesg: publishMessage,
                    mainProvider: _mainProvider);
              }

              // if data found
            } else if (_mainProvider.homeStatus == HomeStatus.ChatScreen) {
              if (strArr.contains("ChatScreen")) {
              } else {
                strArr.add("ChatScreen");
              }
              print("this is strarray8 $strArr");
              print("this is chat screen1");
              print("this is index from main provider ${mainProvider.index}");
              return ChatScreenIndex(
                mainProvider: _mainProvider,
                index: mainProvider.index,
                publishMessage: publishMessage,
                contactprovider: contactProvider,
              );
            } else if (_mainProvider.homeStatus == HomeStatus.CreateGroupChat) {
              if (strArr.contains("CreateGroupChat")) {
              } else {
                strArr.add("CreateGroupChat");
              }
              print("this is strarray6 $strArr");
              print("this is create group screen");
              return CreateGroupChatIndex(
                  groupListProvider: groupListProvider,
                  refreshList: refreshList,
                  mainProvider: _mainProvider,
                  contactProvider: contactProvider,
                  handlePress: handleCreateGroup);
            } else if (_mainProvider.homeStatus ==
                HomeStatus.CreateIndividualGroup) {
              if (strArr.contains("CreateIndividualGroup")) {
              } else {
                strArr.add("CreateIndividualGroup");
              }
              print("this is strarray4 $strArr");
              print("this is create group screen");
              return ContactListIndex(
                refreshList: refreshList,
                handlePress: handleCreateGroup,
                contactProvider: contactProvider,
                mainProvider: _mainProvider,
                groupListProvider: groupListProvider,
              );
            } else {
              return Container();
            }
          }

          //The Screen Displayed in case of error//
          else {
            return Scaffold(
              appBar: CustomAppBar(
                groupListProvider: groupListProvider,
                title: "Chat Rooms",
                mainProvider: _mainProvider,
                handlePress: handleCreateGroup,
                lead: false,
                succeedingIcon: 'assets/plus.svg',
                ischatscreen: false,
              ),
              body: Center(
                  child: Text(
                "${listProvider.errorMsg}",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
            );
          }
        }));
  }
}
