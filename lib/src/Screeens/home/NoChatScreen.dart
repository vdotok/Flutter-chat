import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdkFlutterChat/src/qrcode/qrcode.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/providers/groupListProvider.dart';
import '../../constants/constant.dart';
import 'CustomAppBar.dart';

class NoChatScreen extends StatefulWidget {
  bool presentCheck;
  final bool? isConnect;
  final bool? state;
  final MainProvider? mainProvider;
  final handlePress;
  NoChatScreen(
      {Key? key,
      required this.groupListProvider,
      required this.emitter,
      this.refreshList,
      this.authProvider,
      required this.presentCheck,
      this.isConnect,
      this.state,
      this.mainProvider,
      this.handlePress, this.contactProvider})
      : super(key: key);

  final GroupListProvider? groupListProvider;
  final AuthProvider? authProvider;
  final ContactProvider? contactProvider;
  final Emitter emitter;
  final refreshList;

  @override
  State<NoChatScreen> createState() => _NoChatScreenState();
}

class _NoChatScreenState extends State<NoChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: chatRoomBackgroundColor,
        appBar: CustomAppBar(
          handlePress: widget.handlePress,
          mainProvider: widget.mainProvider,
          groupListProvider: widget.groupListProvider,
          title: "Chat Rooms",
          authProvider: widget.authProvider,
          contactProvider: widget.contactProvider,
          lead: false,
          succeedingIcon: 'assets/plus.svg',
          ischatscreen: false,
        ),
        body: RefreshIndicator(
          onRefresh: widget.refreshList,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 128,
                ),
                Container(
                    height: 160.0,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/Face.svg',
                      ),
                    )),
                SizedBox(height: 43),
                Text(
                  "No Conversation Yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: chatRoomColor,
                    fontSize: 21,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                    width: 220,
                    height: 66,
                    child: Text(
                      "Tap and hold on any message to star it, so you can easily find it later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: chatRoomTextColor,
                        fontSize: 14,
                      ),
                    )),
                widget.presentCheck == true
                    ? SizedBox(height: 22)
                    : SizedBox(
                        height: 10,
                      ),
                Container(
                  width: 196,
                  height: 56,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.presentCheck == true
                          ? Container(
                              width: 196,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: refreshButtonColor,
                                  width: 3,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  widget.mainProvider?.createIndividualGroupScreen();
                                  widget.contactProvider!.getContacts(widget.authProvider!.getUser!.auth_token);
                                },
                                child: Text(
                                  "New Chat",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: primaryFontFamily,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: refreshButtonColor),
                                ),
                              ))
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 196,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: refreshButtonColor,
                  ),
                  child: Container(
                      width: 196,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xff190354),
                          width: 3,
                        ),
                      ),
                      child: Center(
                          child: TextButton(
                        onPressed: widget.refreshList,
                        child: Text(
                          "Refresh",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: primaryFontFamily,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              color: refreshTextColor,
                              letterSpacing: 0.90),
                        ),
                      ))),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 105,
                        child: TextButton(
                          onPressed: () {
                            widget.authProvider!.logout();
                            widget.emitter.disconnect();
                            setState(() {
                              url= "";
                              project="";
                            });
                            
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
                        )),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color:
                              widget.isConnect! && widget.state! ? Colors.green : Colors.red,
                          shape: BoxShape.circle),
                    ),
                  ],
                ),
                Container(
                    // padding: const EdgeInsets.only(bottom: 60),
                    child: Text(widget.authProvider!.getUser!.full_name))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
