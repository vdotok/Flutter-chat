import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdkFlutterChat/src/Screeens/ContactListScreen/ContactListScreen.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../constants/constant.dart';
import '../../core/providers/groupListProvider.dart';
import 'home.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  final bool? lead;
  final succeedingIcon;
  final bool ischatscreen;
  final index;
  final GroupListProvider? groupListProvider;
  final AuthProvider? authProvider;
  final ContactProvider? contactProvider;
  final MainProvider? mainProvider;
  final handlePress;

  CustomAppBar(
      {Key? key,
      this.groupListProvider,
      this.title,
      @required this.lead,
      this.succeedingIcon,
      required this.ischatscreen,
      this.index,
      this.authProvider,
      this.contactProvider,
      this.mainProvider,
      this.handlePress})
      : super(key: key);

  Size get preferredSize {
    return ischatscreen ? Size.fromHeight(80) : Size.fromHeight(kToolbarHeight);
  }

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Size get preferredSize {
    return widget.ischatscreen
        ? Size.fromHeight(80)
        : Size.fromHeight(kToolbarHeight);
  }

  Emitter? emitter;

  String _presenceStatus = "";

  int _count = 0;

  @override
  Widget build(BuildContext context) {
    //   emitter.onPresence = (res) {
    //   print("Presence  $res");

    //   groupListProvider.handlePresence(json.decode(res));
    // };
    // if (widget.ischatscreen) {
    //   //    emitter.onPresence = (res) {
    //   //   print("Presence  $res");

    //   //   groupListProvider.handlePresence((res));
    //   // };
    //   print(
    //       "this is group length ${widget.groupListProvider.groupList.groups[widget.index].participants.length}");
    //   if (widget.groupListProvider.groupList.groups[widget.index].participants.length == 1) {
    //     if (widget.groupListProvider.presenceList.indexOf(widget.groupListProvider
    //             .groupList.groups[widget.index].participants[0].ref_id) !=
    //         -1) {
    //       print("hereeeeee");
    //       _presenceStatus = "online";
    //     } else
    //       _presenceStatus = "offline";
    //   } else if (widget.groupListProvider
    //           .groupList.groups[widget.index].participants.length ==
    //       2) {
    //     print("i am in 2");
    //     widget.groupListProvider.groupList.groups[widget.index].participants
    //         .forEach((element) {
    //       if (widget.groupListProvider.presenceList.indexOf(element.ref_id) != -1)
    //         _count++;
    //     });
    //     if (_count < 2)
    //       _presenceStatus = "offline";
    //     else
    //       _presenceStatus = "online";
    //   }
    // } else {
    //   print("nothing");
    // }

    return AppBar(
      backgroundColor:
          widget.ischatscreen ? appbarBackgroundColor : chatRoomBackgroundColor,
      elevation: 0.0,
      centerTitle: false,
      leading: widget.lead == true
          ? widget.ischatscreen == true
              ? Padding(
                  padding: widget.ischatscreen == true
                      ? EdgeInsets.only(left: 20, top: 21)
                      : EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: chatRoomColor,
                    ),
                    onPressed: () {
                      if (strArr.last == "ChatScreen") {
                        print(
                            "this is mainprovider back button press in chat screen ${widget.mainProvider}");
                        widget.mainProvider!.homeScreen();
                        strArr.remove("ChatScreen");
                      } else {
                        widget.mainProvider!.homeScreen();
                        selectedContacts.clear();
                      }
                      widget.groupListProvider!
                          .handlBacktoGroupList(widget.index);
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: chatRoomColor,
                    ),
                    onPressed: () {
                      if (strArr.last == "CreateIndividualGroup") {
                        print("back arrow create individual");
                        widget.mainProvider!.homeScreen();
                        selectedContacts.clear();

                        strArr.remove("CreateIndividualGroup");
                      }
                    },
                  ),
                )
          : null,
      title: widget.ischatscreen == true
          ? //name of user if participants count is 1
          widget.groupListProvider!.groupList.groups![widget.index]!
                      .participants!.length ==
                  1
              //Without Typing Status//
              ? Padding(
                  padding: const EdgeInsets.only(top: 21.0),
                  child: Text(
                    "${widget.groupListProvider!.groupList.groups![widget.index]!.participants![0]!.full_name}",
                    style: TextStyle(
                      color: userTitleColor,
                      fontSize: 20,
                      fontFamily: primaryFontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : widget.groupListProvider!.groupList.groups![widget.index]!
                          .participants!.length ==
                      2
                  ? Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Text(
                        "${widget.groupListProvider!.groupList.groups![widget.index]!.participants![widget.groupListProvider!.groupList.groups![widget.index]!.participants!.indexWhere((element) => element!.ref_id != widget.authProvider!.getUser!.ref_id)]!.full_name}",
                        style: TextStyle(
                          color: userTitleColor,
                          fontSize: 20,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Text(
                        "${widget.groupListProvider!.groupList.groups![widget.index]!.group_title}",
                        style: TextStyle(
                          color: userTitleColor,
                          fontSize: 20,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
          : Text("${widget.title}",
              style: TextStyle(
                color: chatRoomColor,
                fontSize: 20,
                fontFamily: primaryFontFamily,
                fontWeight: FontWeight.w500,
              )),
      bottom: widget.ischatscreen == true
          //&&
          // (groupListProvider.groupList.groups[index].typingstatus != "" &&
          //             groupListProvider.groupList.groups[index].typingstatus !=
          //                 null  )

          ? PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(left: 73.0, bottom: 5),
                    child:

                        // (_count < 2)
                        //     ? Text(_presenceStatus)
                        //

                        (widget.groupListProvider!.groupList
                                        .groups![widget.index]!.typingstatus !=
                                    "" &&
                                widget.groupListProvider!.groupList
                                        .groups![widget.index]!.typingstatus !=
                                    null)
                            ? (widget.groupListProvider!.typingUserDetail
                                        .length >
                                    1)
                                ? Text(
                                    "${widget.groupListProvider!.groupList.groups![widget.index]!.typingstatus} are typing...",
                                    style: TextStyle(
                                      color: userTypingColor,
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    "${widget.groupListProvider!.groupList.groups![widget.index]!.typingstatus} is typing...",
                                    style: TextStyle(
                                      color: userTypingColor,
                                      fontSize: 14,
                                    ),
                                  )
                            : Text(
                                _presenceStatus,
                                style: TextStyle(
                                  color: _presenceStatus != "offline"
                                      ? userTypingColor
                                      : personOfflineColor,
                                  fontSize: 14,
                                ),
                              )),
              ),
            )
          : PreferredSize(preferredSize: Size.fromHeight(0), child: Text("")),
      actions: [
        //If we are on chat screen//

        widget.ischatscreen == true
            ? Container()
            // Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(top: 21.0),
            //         child: Container(
            //           width: 35,
            //           height: 35,
            //           child: IconButton(
            //             icon: SvgPicture.asset('assets/call.svg'),
            //             onPressed: () {
            //               print("three dot icon pressed");
            //             },
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 21.0),
            //         child: Container(
            //           width: 40,
            //           height: 40,
            //           child: IconButton(
            //             icon: SvgPicture.asset('assets/videocallicon.svg'),
            //             onPressed: () {
            //               print("three dot icon pressed");
            //             },
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 14)
            //     ],
            //   )
            :
            //If we are on other screens//
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: widget.succeedingIcon == ""
                    ? Container()
                    : IconButton(
                        icon: SvgPicture.asset(widget.succeedingIcon),
                        onPressed: widget.succeedingIcon == 'assets/plus.svg'
                            ? () {
                                print(
                                    "THSI IS DFFVDFJCJDFBKJD ${widget.mainProvider}");

                                print("khjhg");
                                widget.handlePress(
                                    HomeStatus.CreateIndividualGroup);

                                //   widget.handlePress(
                                //       ListStatus.CreateIndividualGroup);
                                //   widget.mainProvider
                                //       .inActiveCallCreateIndividualGroup(
                                //     startCall: widget.funct,
                                //   );
                                // }
                              }
                            : () {},
                      ),
              ),
      ],
    );
  }
}
