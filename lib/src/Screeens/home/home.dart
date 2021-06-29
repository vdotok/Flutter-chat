import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../home/CustomAppBar.dart';
import '../splash/splash.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';
import '../../jsManager/jsManager.dart';
import '../../Screeens/home/NoChatScreen.dart';

class Home extends StatefulWidget {
  bool state;
  Home(this.state);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _groupNameController = TextEditingController();
  AuthProvider authProvider;
  GroupListProvider groupListProvider;
  Emitter emitter;
  bool isConnect = false;
  Uint8List _image;
  List<Uint8List> listOfChunks = [];
  Map<String, dynamic> header;
  bool scrollUp = false;

  @override
  void initState() {
    super.initState();
    emitter = Emitter.instance;
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);

    emitter.connect(
        clientId: authProvider.getUser.user_id.toString(),
        reconnectivity: true,
        refID: authProvider.getUser.ref_id,
        authorization_token: authProvider.getUser.authorization_token);
 
      emitter.onConnect = (res) {
        print('this is response on connect $res');
        if (res) {
          groupListProvider.getGroupList(authProvider.getUser.auth_token);
          print("Connected Successfully $res");
          setState(() {
            isConnect = res;
          });
          print("this is  connectttttttttttt before $isConnect");
        } else {
          print("connection error $res");
          setState(() {
            isConnect = res;
          });
          print("this is  connectttttttttttt  after $isConnect");
        }
      };
   
    emitter.onPresence = (res) {
      print("Presence  $res");

      groupListProvider.handlePresence(json.decode(res));
    };
    
    
    emitter.onsubscribe = (value) {
      print(("subscription homee $value"));
      if (value ==
          groupListProvider.groupList.groups.last.channel_key +
              "/" +
              groupListProvider.groupList.groups.last.channel_name) {
        groupListProvider.changeState();
      }
    };
   

    emitter.onMessage = (msg) async {
      print("this is msg on receive $msg");
      var message = json.decode(msg);

      switch (message["type"]) {
        case MessageType.text:
          {
            if (authProvider.getUser.ref_id != message["from"]) {
              if (groupListProvider.currentOpendChat != null) {
                if (groupListProvider.currentOpendChat.channel_key ==
                    message["key"]) {
                  print("samee channel oppeened");
                  var receiptMsg = message;
                  receiptMsg["status"] = ReceiptType.seen;
                  Map<String, dynamic> tempData = {
                    "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                    "from": authProvider.getUser.ref_id,
                    "key": message["key"],
                    "messageId": message["id"],
                    "receiptType": ReceiptType.seen,
                    "to": message["to"]
                  };

                  groupListProvider.recevieMsg(receiptMsg);
                  emitter.publish(
                      groupListProvider.currentOpendChat.channel_key,
                      groupListProvider.currentOpendChat.channel_name,
                      tempData);
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
        case MessageType.media:
          {}
          break;
        case MessageType.file:
          {}
          break;
        case MessageType.thumbnail:
          {}
          break;
        case MessageType.path:
          {}
          break;
        case MessageType.typing:
          {
            if (authProvider.getUser.ref_id != message["from"]) {
              groupListProvider.updateTypingStatus(msg);
            }
          }
          break;
        // case "1":
        //   {
        //     print("this is on file packet");

        //     // if (authProvider.getUser.username != message["from"]) {
        //     //   groupListProvider.updateTypingStatus(msg);
        //     // }
        //   }
        //   break;
        // case "RECEIPTS":
        //   {
        //     print("this is seen notify");
        //     groupListProvider.changeMsgStatus(msg, 3);
        //   }
        //   break;
        default:
          {
            if (message["receiptType"] == ReceiptType.seen)
              groupListProvider.changeMsgStatus(msg, ReceiptType.seen);
          }
          break;
      }

      if (message["type"] == MediaType.audio ||
          message["type"] == MediaType.video ||
          message["type"] == MediaType.image ||
          message["type"] == MediaType.file) {
        if (authProvider.getUser.ref_id != message["from"]) {
          if (groupListProvider.currentOpendChat != null) {
            //if shame channel is open
            if (groupListProvider.currentOpendChat.channel_key ==
                message["key"]) {
              print("samee channel oppeened ${message["date"]}  ${message}  ");
              var receiptMsg = message;
              receiptMsg["status"] = ReceiptType.seen;

              // groupListProvider.recevieMsg(receiptMsg);
              if (!kIsWeb) {
                var extension =
                    message["fileExtension"].toString().contains(".")
                        ? message["fileExtension"]
                        : '.' + message["fileExtension"];
                print("this is tempData ${extension}");
                final tempDir = await getTemporaryDirectory();
                File file = await File(
                        '${tempDir.path}/vdktok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
                    .create();
                file.writeAsBytesSync(base64.decode(receiptMsg["content"]));
                receiptMsg["content"] = file;
                message["id"] = message["messageId"];
                groupListProvider.recevieMsg(message);
              } else {
                final url = await JsManager.instance.connect(
                    base64.decode(receiptMsg["content"]),
                    receiptMsg["fileExtension"]);
                receiptMsg["content"] = url;
                groupListProvider.recevieMsg(receiptMsg);
              }
              Map<String, dynamic> tempData = {
                "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                "from": authProvider.getUser.ref_id,
                "key": message["key"],
                "messageId": message["messageId"],
                "receiptType": ReceiptType.seen,
                "to": message["topic"]
              };

              print("this is temp data $tempData ${message["to"]}");

              emitter.publish(groupListProvider.currentOpendChat.channel_key,
                  groupListProvider.currentOpendChat.channel_name, tempData);
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
                file.writeAsBytesSync(base64.decode(message["content"]));
                message["content"] = file;
                groupListProvider.recevieMsg(message);
              } else {
                final url = await JsManager.instance.connect(
                    base64.decode(message["content"]),
                    message["fileExtension"]);
                message["content"] = url;
                groupListProvider.recevieMsg(message);
              }
            }
          } else {
            print("this is eelsee");
            if (!kIsWeb) {
              final tempDir = await getTemporaryDirectory();
              var extension = message["fileExtension"].toString().contains(".")
                  ? message["fileExtension"]
                  : '.' + message["fileExtension"];

              File file = await File(
                      '${tempDir.path}/vdotok${DateTime.now().toString().trim()}$extension')
                  .create();
              file.writeAsBytesSync(base64.decode(message["content"]));
              message["content"] = file;
              groupListProvider.recevieMsg(message);
            } else {
              final url = await JsManager.instance.connect(
                  base64.decode(message["content"]), message["fileExtension"]);
              message["content"] = url;
              groupListProvider.recevieMsg(message);
            }
          }
        } else {
          // here i'm getting my delivered message
          groupListProvider.changeMsgStatusToDelivered(
              message, ReceiptType.delivered);
        }
      }

      // {
      //   print("this is on file packet");
      //   if (message["totalPacket"] != null) {
      //     header = message;
      //   } else {
      //     print(
      //         "this is listofchunks ${listOfChunks.length},   ${header["totalPacket"]}");
      //     if (header["totalPacket"] - 1 == listOfChunks.length) {
      //       listOfChunks.insert(
      //           --message["packetNo"], base64.decode(message["content"]));

      //       print("this is listofchunks ${listOfChunks.length}");
      //       List<int> fromchunks =
      //           listOfChunks.expand((element) => element).toList();
      //       Uint8List listFromChunks = Uint8List.fromList(fromchunks);
      //       print("this is listofchunks ${listFromChunks.length}");

      //       setState(() {
      //         _image = listFromChunks;
      //       });
      //     } else {
      //       listOfChunks.insert(
      //           --message["packetNo"], base64.decode(message["content"]));
      //     }
      //   }
      // }
    };
  }

  Future<Null> refreshList() async {
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
    groupListProvider.getGroupList(authProvider.getUser.auth_token);
  }

  publishMessage(channelKey, channelName, send_message) {
    emitter.publish(channelKey, channelName, send_message);
  }

  handleSeenStatus(index) {
    if (groupListProvider.groupList.groups[index].chatList != null) {
      groupListProvider.groupList.groups[index].chatList.forEach((element) {
        if (element.status != ReceiptType.delivered &&
            authProvider.getUser.ref_id != element.from) {
          // ChatModel notseenMsg = element;
          // notseenMsg.type = "RECEIPTS";
          // notseenMsg.receiptType = 3;

          Map<String, dynamic> tempData = {
            "date": ((new DateTime.now()).millisecondsSinceEpoch).round(),
            "from": authProvider.getUser.ref_id,
            "key": element.key,
            "messageId": element.id,
            "receiptType": ReceiptType.seen,
            "to": groupListProvider.groupList.groups[index].channel_name
          };
          emitter.publish(groupListProvider.groupList.groups[index].channel_key,
              groupListProvider.groupList.groups[index].channel_name, tempData);
        }
      });
    }
  }

  String _presenceStatus = "";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    print("fbdfbdgfbdgbdb ${widget.state}");
    showSnakbar(msg) {
      final snackBar = SnackBar(
        content: Text(
          "$msg",
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    GroupListProvider groupListProvider =
        Provider.of<GroupListProvider>(context);
    return Consumer2<GroupListProvider, AuthProvider>(
      builder: (context, listProvider, authProvider, child) {
        void _showDialog(group_id, index) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  //title: Text('Alert Dialog Example'),
                  content:
                      Text('Are you sure you want to delete this chatroom?'),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('CANCEL',
                                style: TextStyle(color: chatRoomColor))),
                        // Consumer2<GroupListProvider, AuthProvider>(builder:
                        //     (context, listProvider, authProvider, child) {
                        //   return
                        FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await groupListProvider.deleteGroup(
                                group_id,
                                authProvider.getUser.auth_token,
                              );
                              // (groupListProvider.deleteGroupStatus ==
                              //         DeleteGroupStatus.Loading)
                              //     ? SplashScreen():

                              if (groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Success) {
                                // groupListProvider.groupList.groups.

                                showSnakbar(groupListProvider.successMsg);
                              } else if (groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Failure) {
                                showSnakbar(groupListProvider.errorMsg);
                              } else {}
                              // if (groupListProvider.status == 200) {
                              //   print(
                              //       "this is status ${groupListProvider.status}");
                              //   groupListProvider.getGroupList(
                              //       authProvider.getUser.auth_token);
                              // }
                            },
                            child: Text('DELETE',
                                style: TextStyle(color: chatRoomColor)))
                        //;
                        // }),
                      ],
                    )
                  ],
                );
              });
        }

        //When the Screen is Laoding//
        if (listProvider.groupListStatus == ListStatus.Loading)
          return SplashScreen();

        //In case of success//
        else if (listProvider.groupListStatus == ListStatus.Scussess) {
          //Screen when there is no group or chat in Chat Room//
          if (listProvider.groupList.groups.length == 0)
            return NoChatScreen(
              isConnect:isConnect,
              state:widget.state,
              groupListProvider: groupListProvider,
              emitter: emitter,
              refreshList: refreshList,
              authProvider: authProvider,
              presentCheck: true,
            );

          //Screen with chats in Chat Room//
          else
            // if data found
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: chatRoomBackgroundColor,
              appBar: CustomAppBar(
                ischatscreen: false,
                groupListProvider: groupListProvider,
                title: "Chat Rooms",
                lead: false,
                succeedingIcon: 'assets/plus.svg',
              ),

              body: RefreshIndicator(
                onRefresh: refreshList,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      Expanded(
                          child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: listProvider.groupList.groups.length,
                        itemBuilder: (context, index) {
                          String _presenceStatus = "";
                          int _count = 0;
                          if (listProvider.groupList.groups[index].participants
                                  .length ==
                              1) {
                            if (listProvider.presenceList.indexOf(listProvider
                                    .groupList
                                    .groups[index]
                                    .participants[0]
                                    .ref_id) !=
                                -1)
                              _presenceStatus = "online";
                            else
                              _presenceStatus = "offline";
                          } else if (listProvider.groupList.groups[index]
                                  .participants.length ==
                              2) {
                            listProvider.groupList.groups[index].participants
                                .forEach((element) {
                              if (listProvider.presenceList
                                      .indexOf(element.ref_id) !=
                                  -1) _count++;
                            });
                            if (_count < 2)
                              _presenceStatus = "offline";
                            else
                              _presenceStatus = "online";
                          } else {
                            listProvider.groupList.groups[index].participants
                                .forEach((element) {
                              if (listProvider.presenceList
                                      .indexOf(element.ref_id) !=
                                  -1) _count++;
                            });
                            _presenceStatus = "(" +
                                _count.toString() +
                                "/" +
                                listProvider
                                    .groupList.groups[index].participants.length
                                    .toString() +
                                ") online";
                          }

                          //The Container returned that will show the Group Name, notification counter and availability status//
                          return
                              // InkWell(
                              //   onTap: () {
                              //     listProvider.setCountZero(index);
                              //     Navigator.pushNamed(context, "/chatScreen",
                              //         arguments: {
                              //           "index": index,
                              //           "publishMessage": publishMessage,
                              //           "groupListProvider": groupListProvider
                              //         });

                              //     handleSeenStatus(index);
                              //   },
                              //child:
                              Container(
                            // width: 375,
                            // height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 22),
                                InkWell(
                                    onTap: () {
                                      listProvider.setCountZero(index);
                                      Navigator.pushNamed(
                                          context, "/chatScreen",
                                          arguments: {
                                            "index": index,
                                            "publishMessage": publishMessage,
                                            "groupListProvider":
                                                groupListProvider
                                          });

                                      handleSeenStatus(index);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              //The Group Title Shows Here
                                              Flexible(
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .participants
                                                              .length ==
                                                          1
                                                      ? Text(
                                                          "${listProvider.groupList.groups[index].participants[0].full_name}",
                                                          //  maxLines: 2,

                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color:
                                                                personNameColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                primaryFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .participants
                                                                  .length ==
                                                              2
                                                          ? Text(
                                                              "${listProvider.groupList.groups[index].participants[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}",
                                                              //maxLines: 2,

                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    personNameColor,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    primaryFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ))
                                                          : Text(
                                                              "${listProvider.groupList.groups[index].group_title}",
                                                              //  maxLines: 2,

                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    personNameColor,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    primaryFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                ),
                                              ),
                                              SizedBox(width: 3),

                                              //The Notification Counter for Each Group//
                                              listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .counter ==
                                                          null ||
                                                      listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .counter ==
                                                          0
                                                  ? Text("")
                                                  :
                                                  // Container(

                                                  //    child:

                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8),
                                                      child: Container(
                                                        width: (listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    1 ||
                                                                listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    2)
                                                            ? 16
                                                            : 20,
                                                        height: (listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    1 ||
                                                                listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    2)
                                                            ? 16
                                                            : 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              personOfflineColor,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${listProvider.groupList.groups[index].counter}",
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  counterTextColor,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Inter",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          //),
                                                        ),
                                                      ),
                                                    ),

                                              // Center(
                                              //                                                             child: Container(
                                              //     width: 16,
                                              //     height: 16,
                                              //     decoration:
                                              //         BoxDecoration(
                                              //       shape: BoxShape
                                              //           .circle,
                                              //       color:
                                              //           personOfflineColor,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Positioned.fill(
                                              //   child: Align(
                                              //     alignment:
                                              //         Alignment
                                              //             .center,
                                              //     child: SizedBox(
                                              //       height: 15,
                                              //       child: Text(
                                              //         "${listProvider.groupList.groups[index].counter}",
                                              //         maxLines: 1,
                                              //         overflow:
                                              //             TextOverflow
                                              //                 .ellipsis,
                                              //         style:
                                              //             TextStyle(
                                              //           color:
                                              //               counterTextColor,
                                              //           fontSize:
                                              //               12,
                                              //           fontFamily:
                                              //               "Inter",
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .w800,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              //  )],
                                              //           ),
                                              //  ],

                                              //  ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          width: 24,
                                          margin: EdgeInsets.only(right: 29),

//                                         child: Column(children:
// [

                                          child: PopupMenuButton(
                                              offset: Offset(8, 30),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                size: 24,
                                                color: horizontalDotIconColor,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                        PopupMenuItem(
                                                          enabled: (listProvider
                                                                          .groupList
                                                                          .groups[
                                                                              index]
                                                                          .participants
                                                                          .length ==
                                                                      1 ||
                                                                  listProvider
                                                                          .groupList
                                                                          .groups[
                                                                              index]
                                                                          .participants
                                                                          .length ==
                                                                      2)
                                                              ? false
                                                              : true,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 12,
                                                                  left: 12),
                                                          value: 1,

                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 14,
                                                                    left: 16,
                                                                    right: 70),
                                                            width: 200,
                                                            height: 44,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    backgroundChatColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            //  color:popupGreyColor,
                                                            child: Text(
                                                              "Edit Group Name",
                                                              //textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                //decoration: TextDecoration.underline,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    font_Family,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color:
                                                                    personNameColor,
                                                              ),
                                                            ),
                                                          ),
                                                          //)
                                                        ),
                                                        //SizedBox(height: 8,),

                                                        PopupMenuItem(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 12,
                                                                    left: 12),
                                                            value: 2,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 14,
                                                                    left: 16,
                                                                  ),
                                                                  width: 200,
                                                                  height: 44,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundChatColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  //  color:popupGreyColor,
                                                                  child: Text(
                                                                    "Delete",
                                                                    style:
                                                                        TextStyle(
                                                                      //decoration: TextDecoration.underline,
                                                                      fontSize:
                                                                          font_size,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          font_Family,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color:
                                                                          popupDeleteButtonColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                              onSelected: (menu) {
                                                if (menu == 1) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ListenableProvider<
                                                                GroupListProvider>.value(
                                                            value:
                                                                groupListProvider,
                                                            child:
                                                                CreateGroupPopUp(
                                                              editGroupName:
                                                                  true,
                                                              groupid:
                                                                  listProvider
                                                                      .groupList
                                                                      .groups[
                                                                          index]
                                                                      .id,
                                                              controllerText:
                                                                  listProvider
                                                                      .groupList
                                                                      .groups[
                                                                          index]
                                                                      .group_title,
                                                              groupNameController:
                                                                  _groupNameController,
                                                              publishMessage:
                                                                  publishMessage,
                                                              authProvider:
                                                                  authProvider,
                                                            ));
                                                      });
                                                  print("i am after here");
                                                  // if (groupListProvider
                                                  //         .editGroupNameStatus ==
                                                  //     EditGroupNameStatus
                                                  //         .Success) {
                                                  //   showSnakbar(groupListProvider
                                                  //       .successMsg);
                                                  // } else if (groupListProvider
                                                  //         .editGroupNameStatus ==
                                                  //     EditGroupNameStatus
                                                  //         .Failure) {
                                                  //   showSnakbar(groupListProvider
                                                  //       .errorMsg);
                                                  // } else {}
                                                  //  if(groupListProvider.editGroupNameStatus)

                                                } else if (menu == 2) {
                                                  _showDialog(
                                                      listProvider.groupList
                                                          .groups[index].id,
                                                      listProvider.groupList
                                                          .groups[index]);
                                                  // groupListProvider.deleteGroup(
                                                  //     listProvider.groupList
                                                  //         .groups[index].id);
                                                }
                                              }),
//]),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          width: 235,
                                          padding: EdgeInsets.only(left: 20),
                                          child: listProvider.groupList
                                                      .groups[index].chatList ==
                                                  null
                                              ? Text("",
                                                  style: TextStyle(
                                                    color: messageStatusColor,
                                                    fontSize: 14,
                                                  ))
                                              : (listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .counter ==
                                                              null ||
                                                          listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .counter ==
                                                              0) &&
                                                      listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .chatList
                                                              .last
                                                              .type !=
                                                          0
                                                  ? Text(
                                                      listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .chatList
                                                                  .last
                                                                  .type ==
                                                              "text"
                                                          ? "${listProvider.groupList.groups[index].chatList.last.content}"
                                                          : "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            messageStatusColor,
                                                        fontSize: 14,
                                                      ))
                                                  : listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .chatList
                                                              .last
                                                              .type ==
                                                          0
                                                      ? Text("Image",
                                                          style: TextStyle(
                                                            color:
                                                                messageStatusColor,
                                                            fontSize: 14,
                                                          ))
                                                      // :
                                                      // listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     1
                                                      // ? Text("Audio",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):
                                                      //     listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     2
                                                      // ? Text("Video",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):
                                                      //     listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     3
                                                      // ? Text("File",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):

                                                      : Text("Misread Messages",
                                                          style: TextStyle(
                                                            color:
                                                                messageStatusColor,
                                                            fontSize: 14,
                                                          ))),
                                    ),
                                    Container(
                                      // height: 15,
                                      // width: 51,
                                      margin: EdgeInsets.only(right: 24),
                                      child: listProvider.groupList
                                                      .groups[index].counter ==
                                                  null ||
                                              listProvider.groupList
                                                      .groups[index].counter ==
                                                  0
                                          ? Text(
                                              _presenceStatus,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color:
                                                    _presenceStatus != "offline"
                                                        ? chatRoomColor
                                                        : personOfflineColor,
                                                fontSize: 10,
                                              ),
                                            )
                                          : Text(
                                              _presenceStatus,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color:
                                                    _presenceStatus != "offline"
                                                        ? chatRoomColor
                                                        : personOfflineColor,
                                                fontSize: 10,
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 3),
                                // SizedBox(
                                //   height: 2,
                                //   width: 367,
                                //   child: Divider(
                                //     color: listdividerColor,
                                //     thickness: 1.0,
                                //   ),
                                // ),
                              ],
                            ),
                            //),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 24),
                            child: Divider(
                              thickness: 1,
                              color: listdividerColor,
                            ),
                          );
                        },
                      )),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.only(bottom: 60),
                                    child: FlatButton(
                                      onPressed: () {
                                        authProvider.logout();
                                        emitter.disconnect();
                                      },
                                      child: Text(
                                        "LOG OUT",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: primaryFontFamily,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: logoutButtonColor,
                                            letterSpacing: 0.90),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: isConnect && widget.state
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle),
                                  )
                                ],
                              ),
                              Container(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: Text(authProvider.getUser.full_name))
                            ],
                          )),

                      //Previous Code// NOW CHAGING
                      // Expanded(
                      //     child: ListView.separated(
                      //   scrollDirection: Axis.vertical,
                      //   shrinkWrap: true,
                      //   itemCount: listProvider.groupList.groups.length,
                      //   itemBuilder: (context, index) {
                      // String _presenceStatus = "";
                      // int _count = 0;
                      // if (listProvider.groupList.groups[index].participants
                      //         .length ==
                      //     1) {
                      //   if (listProvider.presenceList.indexOf(listProvider
                      //           .groupList
                      //           .groups[index]
                      //           .participants[0]
                      //           .ref_id) !=
                      //       -1)
                      //     _presenceStatus = "online";
                      //   else
                      //     _presenceStatus = "offline";
                      // } else if (listProvider.groupList.groups[index]
                      //         .participants.length ==
                      //     2) {
                      //   listProvider.groupList.groups[index].participants
                      //       .forEach((element) {
                      //     if (listProvider.presenceList
                      //             .indexOf(element.ref_id) !=
                      //         -1) _count++;
                      //   });
                      //   if (_count < 2)
                      //     _presenceStatus = "offline";
                      //   else
                      //     _presenceStatus = "online";
                      // } else {
                      //   listProvider.groupList.groups[index].participants
                      //       .forEach((element) {
                      //     if (listProvider.presenceList
                      //             .indexOf(element.ref_id) !=
                      //         -1) _count++;
                      //   });
                      //   _presenceStatus = "(" +
                      //       _count.toString() +
                      //       "/" +
                      //       listProvider
                      //           .groupList.groups[index].participants.length
                      //           .toString() +
                      //       ") online";
                      // }

                      //     return Padding(
                      //       padding: const EdgeInsets.only(left: 5, right: 5),
                      //       child: Card(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Padding(
                      //           padding: EdgeInsets.only(
                      //             left: 10,
                      //           ),
                      //           child: Container(
                      //             child: ListTile(
                      //               onTap: () {
                      //                 listProvider.setCountZero(index);
                      //                 Navigator.pushNamed(
                      //                     context, "/chatScreen",
                      //                     arguments: {
                      //                       "index": index,
                      //                       "publishMessage": publishMessage,
                      //                       "groupListProvider":
                      //                           groupListProvider
                      //                     });

                      //                 handleSeenStatus(index);
                      //               },
                      //               leading: Icon(
                      //                 Icons.person,
                      //                 size: 30,
                      //               ),
                      //               title:
                      //                   //name of user if participants count is 1
                      //                   listProvider.groupList.groups[index]
                      //                               .participants.length ==
                      //                           1
                      //                       ? Padding(
                      //                           padding: const EdgeInsets.only(
                      //                               top: 20),
                      //                           child: Text(
                      //                               "${listProvider.groupList.groups[index].participants[0].full_name}"),
                      //                         )
                      //                       : //name of user if participants count is 2
                      //                       listProvider.groupList.groups[index]
                      //                                   .participants.length ==
                      //                               2
                      //                           ? Padding(
                      //                               padding:
                      //                                   const EdgeInsets.only(
                      //                                       top: 20),
                      //                               child: Text(
                      //                                   "${listProvider.groupList.groups[index].participants[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}"),
                      //                             )
                      //                           :
                      //                           //name of user if participants count is more than 2
                      //                           Padding(
                      //                               padding:
                      //                                   const EdgeInsets.only(
                      //                                       top: 20),
                      //                               child: Text(
                      //                                   "${listProvider.groupList.groups[index].group_title}"),
                      //                             ),

                      //               //status for typing
                      //               // subtitle: Text(""),
                      //               subtitle: listProvider
                      //                               .groupList
                      //                               .groups[index]
                      //                               .typingstatus ==
                      //                           null ||
                      //                       listProvider.groupList.groups[index]
                      //                               .typingstatus ==
                      //                           false
                      //                   ? Text("")
                      //                   : Text(
                      //                       "typing...",
                      //                       style: TextStyle(fontSize: 10),
                      //                     ),
                      //               trailing: listProvider.groupList
                      //                               .groups[index].counter ==
                      //                           null ||
                      //                       listProvider.groupList.groups[index]
                      //                               .counter ==
                      //                           0
                      //                   ? //if count is zero
                      //                   Text(
                      //                       _presenceStatus,
                      //                       style: TextStyle(
                      //                           color:
                      //                               _presenceStatus != "offline"
                      //                                   ? Colors.green
                      //                                   : Colors.red),
                      //                     )
                      //                   :
                      //                   // if count is not zero
                      //                   Padding(
                      //                       padding: EdgeInsets.all(1),
                      //                       child: Column(
                      //                         children: [
                      //                           Text(
                      //                             _presenceStatus,
                      //                             style: TextStyle(
                      //                                 color: _presenceStatus !=
                      //                                         "offline"
                      //                                     ? Colors.green
                      //                                     : Colors.red),
                      //                           ),
                      //                           Text(
                      //                             "${listProvider.groupList.groups[index].counter}",
                      //                             style: TextStyle(
                      //                                 color: Colors.blue,
                      //                                 fontSize: 16,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ],
                      //                       )),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   separatorBuilder: (BuildContext context, int index) {
                      //     return SizedBox(
                      //       height: 1,
                      //     );
                      //   },
                      // )),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: Padding(
              //   padding: EdgeInsets.only(bottom: 40),
              //   child: FloatingActionButton(
              //       heroTag: Text("btn2"),
              //       mini: true,
              //       child: Icon(Icons.add),
              //       onPressed: () async {
              //         Navigator.pushNamed(context, '/creategroup',
              //             arguments: groupListProvider);
              //       }),
              // ),
            );
        }

        //The Screen Displayed in case of error//
        else
          return Scaffold(
            appBar: CustomAppBar(
              groupListProvider: groupListProvider,
              title: "Chat Rooms",
              lead: false,
              succeedingIcon: 'assets/plus.png',
              ischatscreen: false,
            ),
            body: Center(
                child: Text(
              "${listProvider.errorMsg}",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )),
          );
      },
    );
  }
}