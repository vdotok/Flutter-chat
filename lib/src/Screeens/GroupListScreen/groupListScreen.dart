import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdkFlutterChat/src/Screeens/home/CustomAppBar.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';

import '../../core/models/GroupModel.dart';

int listIndex = 0;
TextEditingController _groupNameController = TextEditingController();

class GroupListScreen extends StatefulWidget {
  final GroupListProvider groupListProvider;
  final ContactProvider? contactProvider;
  final AuthProvider authProvider;
  final publishMesg;
  final refreshList;
  final handlePress;
  final chatSocket;
  final MainProvider? mainProvider;
  const GroupListScreen(
      {Key? key,
      required this.groupListProvider,
      this.contactProvider,
      required this.authProvider,
      this.refreshList,
      this.chatSocket,
      this.publishMesg,
      this.mainProvider,
      this.handlePress})
      : super(key: key);
  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
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

  handleSeenStatus(index) {
    if (widget.groupListProvider.groupList.groups![index]!.chatList != null) {
      widget.groupListProvider.groupList.groups![index]!.chatList!
          .forEach((element) {
        if (element!.status != ReceiptType.delivered &&
            widget.authProvider.getUser!.ref_id != element.from) {
          // ChatModel notseenMsg = element;
          // notseenMsg.type = "RECEIPTS";
          // notseenMsg.receiptType = 3;

          Map<String, dynamic> tempData = {
            "date": ((new DateTime.now()).millisecondsSinceEpoch).round(),
            "from": widget.authProvider.getUser!.ref_id,
            "key": element.key,
            "messageId": element.id,
            "receiptType": ReceiptType.seen,
            "to":
                widget.groupListProvider.groupList.groups![index]!.channel_name
          };
          emitter.publish(
              widget.groupListProvider.groupList.groups![index]!.channel_key,
              widget.groupListProvider.groupList.groups![index]!.channel_name,
              tempData,
              0);
        }
      });
    }
  }

  void _showDialog(group_id, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Alert Dialog Example'),
            content: Text('Are you sure you want to delete this chatroom?'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: chatRoomColor),
                      onPressed: () => Navigator.of(context).pop(),
                      child:
                          Text('CANCEL', style: TextStyle(color: whiteColor))),
                  // Consumer2<GroupListProvider, AuthProvider>(builder:
                  //     (context, listProvider, authProvider, child) {
                  //   return
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: chatRoomColor),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await widget.groupListProvider.deleteGroup(
                          group_id,
                          widget.authProvider.getUser!.auth_token,
                        );
                        // (groupListProvider.deleteGroupStatus ==
                        //         DeleteGroupStatus.Loading)
                        //     ? SplashScreen():

                        if (widget.groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Success) {
                          // groupListProvider.groupList.groups.

                          showSnakbar(widget.groupListProvider.successMsg);
                        } else if (widget.groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Failure) {
                          showSnakbar(widget.groupListProvider.errorMsg);
                        } else {}
                        // if (groupListProvider.status == 200) {
                        //   print(
                        //       "this is status ${groupListProvider.status}");
                        //   groupListProvider.getGroupList(
                        //       authProvider.getUser.auth_token);
                        // }
                      },
                      child:
                          Text('DELETE', style: TextStyle(color: whiteColor)))
                  //;
                  // }),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: chatRoomBackgroundColor,
      appBar: CustomAppBar(
        mainProvider: widget.mainProvider,
        contactProvider: widget.contactProvider,
        ischatscreen: false,
        groupListProvider: widget.groupListProvider,
        title: "Chat Rooms",
        handlePress: widget.handlePress,
        lead: false,
        succeedingIcon: 'assets/plus.svg',
      ),
      body: RefreshIndicator(
        onRefresh: widget.refreshList,
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
                itemCount: widget.groupListProvider.groupList.groups!.length,
                itemBuilder: (context, index) {
                  // print("this is yess"
                  //     "${listProvider.groupList.groups[index].participants[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}");

                  String _presenceStatus = "";
                  int _count = 0;
                  if (widget.groupListProvider.groupList.groups![index]!
                          .participants!.length ==
                      1) {
                    if (widget.groupListProvider.presenceList.indexOf(widget
                            .groupListProvider
                            .groupList
                            .groups![index]!
                            .participants![0]!
                            .ref_id) !=
                        -1)
                      _presenceStatus = "online";
                    else
                      _presenceStatus = "offline";
                  } else if (widget.groupListProvider.groupList.groups![index]!
                          .participants!.length ==
                      2) {
                    widget.groupListProvider.groupList.groups![index]!
                        .participants!
                        .forEach((element) {
                      if (widget.groupListProvider.presenceList
                              .indexOf(element!.ref_id) !=
                          -1) _count++;
                    });
                    if (_count < 2)
                      _presenceStatus = "offline";
                    else
                      _presenceStatus = "online";
                  } else {
                    widget.groupListProvider.groupList.groups![index]!
                        .participants!
                        .forEach((element) {
                      if (widget.groupListProvider.presenceList
                              .indexOf(element!.ref_id) !=
                          -1) _count++;
                    });
                    _presenceStatus = "(" +
                        _count.toString() +
                        "/" +
                        widget.groupListProvider.groupList.groups![index]!
                            .participants!.length
                            .toString() +
                        ") online";
                  }

                  //The Container returned that will show the Group Name, notification counter and availability status//
                  return Slidable(
                    endActionPane:
                        ActionPane(motion: DrawerMotion(), children: [
                      // SizedBox(width: 10,),
                      SlidableAction(
                        onPressed: (context) {
                          print("length of participants ${widget.groupListProvider.groupList.groups![index]!
                                  .participants!.length}");
                          if (widget.groupListProvider.groupList.groups![index]!
                                  .auto_created ==
                              0) {
                            print("assa");
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  print(
                                      "hfgd ${widget.groupListProvider.groupList.groups![index]!.participants!.length}");

                                  return ListenableProvider<
                                          GroupListProvider>.value(
                                      value: widget.groupListProvider,
                                      child: CreateGroupPopUp(
                                        index: index,
                                        editGroupName: true,
                                        groupid: widget.groupListProvider
                                            .groupList.groups![index]!.id,
                                        controllerText: widget
                                            .groupListProvider
                                            .groupList
                                            .groups![index]!
                                            .group_title,
                                        groupNameController:
                                            _groupNameController,
                                        publishMessage: widget.publishMesg,
                                        authProvider: widget.authProvider,
                                        selectedContacts: [],
                                      ));

// return Container();
                                });
                          } else {
                            showSnakbar("Can't rename this group");
                          }
                          print("i am after here");
                        },
                        icon: Icons.edit_outlined,
                        backgroundColor: chatRoomColor,
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          // print("abcd ${widget.groupListProvider.groupList.groups![index]!.participants![widget.groupListProvider.groupList.groups![index]!.participants!.indexWhere((element) => element!.ref_id != widget.authProvider.getUser!.ref_id)]!.ref_id}");
                          var res = await widget.groupListProvider.deleteGroup(
                            widget
                                .groupListProvider.groupList.groups![index]!.id,
                            widget.authProvider.getUser!.auth_token,
                          );
                     

                          if (widget.groupListProvider.deleteGroupStatus ==
                              DeleteGroupStatus.Success) {
                          

                            showSnakbar(widget.groupListProvider.successMsg);

                            List<String> refIDList = [];
                            widget.groupListProvider.groupList.groups![index]!
                                .participants!
                                .forEach((element) {
                              if (element!.ref_id !=
                                  widget.authProvider.getUser!.ref_id) {
                                print("elementtttttttt is ${element.ref_id}");
                                refIDList.add(element.ref_id);
                              }
                            });

                           
                            var tempdata = {
                              "from": widget.authProvider.getUser!.ref_id,
                              "data": {
                                "action": "delete", //new, modify, delete
                                "groupModel": res
                              },
                              "to": refIDList
                            };
                            emitter.publishNotification(tempdata);
                          } else if (widget
                                  .groupListProvider.deleteGroupStatus ==
                              DeleteGroupStatus.Failure) {
                            showSnakbar(widget.groupListProvider.errorMsg);
                          } else {}
                        },
                        icon: Icons.delete_rounded,
                        backgroundColor: greyColor2,
                      ),
                    ]),
                    child: InkWell(
                      onTap: () {
                        listIndex = index;
                        widget.groupListProvider.setCountZero(index);
                        // Navigator.pushNamed(context, "/chatScreen",
                        //     arguments: {
                        //       "index": index,
                        //       "publishMessage": publishMessage,
                        //       "groupListProvider": groupListProvider
                        //     });

                        handleSeenStatus(index);
                        widget.mainProvider!.chatScreen(index: index);
                      },
                      child: Container(
                        // width: 375,
                        // height: 80,
                        child: Column(
                          children: [
                            SizedBox(height: 22),
                            InkWell(
                                onTap: () {
                                  listIndex = index;
                                  widget.groupListProvider.setCountZero(index);
                                  // Navigator.pushNamed(context, "/chatScreen",
                                  //     arguments: {
                                  //       "index": index,
                                  //       "publishMessage": publishMessage,
                                  //       "groupListProvider": groupListProvider
                                  //     });

                                  handleSeenStatus(index);
                                  widget.mainProvider!.chatScreen(index: index);
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
                                              child: widget
                                                          .groupListProvider
                                                          .groupList
                                                          .groups![index]!
                                                          .participants!
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      //personal chat
                                                      "${widget.groupListProvider.groupList.groups![index]!.participants![0]!.full_name}",
                                                      //  maxLines: 2,

                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: personNameColor,
                                                        fontSize: 20,
                                                        fontFamily:
                                                            primaryFontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  : widget
                                                              .groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .participants!
                                                              .length ==
                                                          2
                                                      ? Text(
                                                          "${widget.groupListProvider.groupList.groups![index]!.participants![widget.groupListProvider.groupList.groups![index]!.participants!.indexWhere((element) => element!.ref_id != widget.authProvider.getUser!.ref_id)]!.full_name}",
                                                          //maxLines: 2,

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
                                                          ))
                                                      : Text(
                                                          //group chat
                                                          "${widget.groupListProvider.groupList.groups![index]!.group_title}",
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
                                                          )),
                                            ),
                                          ),
                                          SizedBox(width: 3),

                                          //The Notification Counter for Each Group//
                                          widget
                                                          .groupListProvider
                                                          .groupList
                                                          .groups![index]!
                                                          .counter ==
                                                      null ||
                                                  widget
                                                          .groupListProvider
                                                          .groupList
                                                          .groups![index]!
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
                                                    width: (widget
                                                                    .groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .counter
                                                                    .toString()
                                                                    .length ==
                                                                1 ||
                                                            widget
                                                                    .groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .counter
                                                                    .toString()
                                                                    .length ==
                                                                2)
                                                        ? 20
                                                        : 25,
                                                    height: (widget
                                                                    .groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .counter
                                                                    .toString()
                                                                    .length ==
                                                                1 ||
                                                            widget
                                                                    .groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .counter
                                                                    .toString()
                                                                    .length ==
                                                                2)
                                                        ? 20
                                                        : 25,
                                                    decoration: BoxDecoration(
                                                      color: personOfflineColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${widget.groupListProvider.groupList.groups![index]!.counter}",
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              counterTextColor,
                                                          fontSize: 12,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      //),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    //             Container(
                                    //               height: 24,
                                    //               width: 24,
                                    //               margin: EdgeInsets.only(right: 29),

                                    // //                                         child: Column(children:
                                    // // [

                                    //               child: PopupMenuButton(
                                    //                   offset: Offset(8, 30),
                                    //                   shape: RoundedRectangleBorder(
                                    //                       borderRadius: BorderRadius.all(
                                    //                           Radius.circular(20.0))),
                                    //                   icon: const Icon(
                                    //                     Icons.more_horiz,
                                    //                     size: 24,
                                    //                     color: horizontalDotIconColor,
                                    //                   ),
                                    //                   itemBuilder: (BuildContext context) => [
                                    //                         PopupMenuItem(
                                    //                           enabled: (widget
                                    //                                           .groupListProvider
                                    //                                           .groupList
                                    //                                           .groups![index]!
                                    //                                           .participants!
                                    //                                           .length ==
                                    //                                       1 ||
                                    //                                   widget
                                    //                                           .groupListProvider
                                    //                                           .groupList
                                    //                                           .groups![index]!
                                    //                                           .participants!
                                    //                                           .length ==
                                    //                                       2)
                                    //                               ? false
                                    //                               : true,
                                    //                           padding: EdgeInsets.only(
                                    //                               right: 12, left: 12),
                                    //                           value: 1,

                                    //                           child: Container(
                                    //                             padding: EdgeInsets.only(
                                    //                                 top: 14,
                                    //                                 left: 16,
                                    //                                 right: 70),
                                    //                             width: 200,
                                    //                             height: 44,
                                    //                             decoration: BoxDecoration(
                                    //                                 color: backgroundChatColor,
                                    //                                 borderRadius:
                                    //                                     BorderRadius.circular(
                                    //                                         8)),
                                    //                             //  color:popupGreyColor,
                                    //                             child: Text(
                                    //                               "Edit Group Name",
                                    //                               //textAlign: TextAlign.center,
                                    //                               style: TextStyle(
                                    //                                 //decoration: TextDecoration.underline,
                                    //                                 fontSize: 12,
                                    //                                 fontWeight: FontWeight.w600,
                                    //                                 fontFamily: font_Family,
                                    //                                 fontStyle: FontStyle.normal,
                                    //                                 color: personNameColor,
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           //)
                                    //                         ),
                                    //                         //SizedBox(height: 8,),

                                    //                         PopupMenuItem(
                                    //                             padding: EdgeInsets.only(
                                    //                                 right: 12, left: 12),
                                    //                             value: 2,
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 SizedBox(
                                    //                                   height: 8,
                                    //                                 ),
                                    //                                 Container(
                                    //                                   padding: EdgeInsets.only(
                                    //                                     top: 14,
                                    //                                     left: 16,
                                    //                                   ),
                                    //                                   width: 200,
                                    //                                   height: 44,
                                    //                                   decoration: BoxDecoration(
                                    //                                       color:
                                    //                                           backgroundChatColor,
                                    //                                       borderRadius:
                                    //                                           BorderRadius
                                    //                                               .circular(8)),
                                    //                                   //  color:popupGreyColor,
                                    //                                   child: Text(
                                    //                                     "Delete",
                                    //                                     style: TextStyle(
                                    //                                       //decoration: TextDecoration.underline,
                                    //                                       fontSize: font_size,
                                    //                                       fontWeight:
                                    //                                           FontWeight.w600,
                                    //                                       fontFamily:
                                    //                                           font_Family,
                                    //                                       fontStyle:
                                    //                                           FontStyle.normal,
                                    //                                       color:
                                    //                                           popupDeleteButtonColor,
                                    //                                     ),
                                    //                                   ),
                                    //                                 )
                                    //                               ],
                                    //                             )),
                                    //                       ],
                                    //                   onSelected: (menu) {
                                    //                     //                                                                    var content =
                                    //                     //     listProvider.groupList.groups[index].chatList.last.content;
                                    //                     // //.toString().codeUnits;
                                    //                     // var decode = utf8.decode(content.toString().codeUnits);
                                    //                     // print("Decode is $decode");
                                    //                     // print(
                                    //                     //     " this is content of receiving mesgs${listProvider.groupList.groups[index].chatList.last.content}");
                                    //                     if (menu == 1) {
                                    //                       showDialog(
                                    //                           context: context,
                                    //                           builder: (BuildContext context) {
                                    //                             return ListenableProvider<
                                    //                                     GroupListProvider>.value(
                                    //                                 value: widget
                                    //                                     .groupListProvider,
                                    //                                 child: CreateGroupPopUp(
                                    //                                   editGroupName: true,
                                    //                                   groupid: widget
                                    //                                       .groupListProvider
                                    //                                       .groupList
                                    //                                       .groups![index]!
                                    //                                       .id,
                                    //                                   controllerText: widget
                                    //                                       .groupListProvider
                                    //                                       .groupList
                                    //                                       .groups![index]!
                                    //                                       .group_title,
                                    //                                   groupNameController:
                                    //                                       _groupNameController,
                                    //                                   publishMessage:
                                    //                                       widget.publishMesg,
                                    //                                   authProvider:
                                    //                                       widget.authProvider,
                                    //                                   selectedContacts: [],
                                    //                                 ));
                                    //                           });
                                    //                       print("i am after here");
                                    //                     } else if (menu == 2) {
                                    //                       _showDialog(
                                    //                           widget.groupListProvider.groupList
                                    //                               .groups![index]!.id,
                                    //                           widget.groupListProvider.groupList
                                    //                               .groups![index]);
                                    //                     }
                                    //                   }),
                                    // //]),
                                    //             ),
                                  ],
                                )),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      width: 235,
                                      padding: EdgeInsets.only(left: 20),
                                      child: widget.groupListProvider.groupList
                                                  .groups![index]!.chatList ==
                                              null
                                          ? Text("",
                                              style: TextStyle(
                                                color: messageStatusColor,
                                                fontSize: 14,
                                              ))
                                          : (widget
                                                              .groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .counter ==
                                                          null ||
                                                      widget
                                                              .groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .counter ==
                                                          0) &&
                                                  widget
                                                          .groupListProvider
                                                          .groupList
                                                          .groups![index]!
                                                          .chatList!
                                                          .last!
                                                          .type !=
                                                      0
                                              ? Text(
                                                  widget
                                                              .groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .chatList!
                                                              .last!
                                                              .type ==
                                                          "text"
                                                      ? (widget
                                                                  .groupListProvider
                                                                  .groupList
                                                                  .groups![index]!
                                                                  .chatList!
                                                                  .last!
                                                                  .from ==
                                                              widget.authProvider.getUser!.ref_id)
                                                          //(listProvider.groupList.groups[index].chatList.last.content
                                                          // (listProvider.groupList.groups[index].chatList[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].content)
                                                          //  listProvider.groupList.groups[index].participants[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name?
                                                          //?
                                                          ? "${widget.groupListProvider.groupList.groups![index]!.chatList!.last!.content}"
                                                          : "${widget.groupListProvider.groupList.groups![index]!.chatList!.last!.content}"
                                                      // :
                                                      : "",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: messageStatusColor,
                                                    fontSize: 14,
                                                  ))
                                              : widget.groupListProvider.groupList.groups![index]!.chatList!.last!.type == 0
                                                  ? Text("Image",
                                                      style: TextStyle(
                                                        color:
                                                            messageStatusColor,
                                                        fontSize: 14,
                                                      ))
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
                                  child: widget.groupListProvider.groupList
                                                  .groups![index]!.counter ==
                                              null ||
                                          widget.groupListProvider.groupList
                                                  .groups![index]!.counter ==
                                              0
                                      ? Text(
                                          _presenceStatus,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: _presenceStatus != "offline"
                                                ? chatRoomColor
                                                : personOfflineColor,
                                            fontSize: 10,
                                          ),
                                        )
                                      : Text(
                                          _presenceStatus,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: _presenceStatus != "offline"
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
                      ),
                    ),
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
                            child: TextButton(
                              onPressed: () {
                                widget.authProvider.logout();
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
                                color: isInternetConnect &&
                                        widget.chatSocket == true
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle),
                          )
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Text(widget.authProvider.getUser!.full_name))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
