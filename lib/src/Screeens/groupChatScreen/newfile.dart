import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constant.dart';

class OnePersonChatScreen extends StatefulWidget {
  @override
  _OnePersonChatScreenState createState() => _OnePersonChatScreenState();
}

class _OnePersonChatScreenState extends State<OnePersonChatScreen> {
  bool backarrow = true;
  late bool preceedingicon;
  bool chatscreen = true;
  bool issender = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));

    return Scaffold(
        backgroundColor: chatRoomBackgroundColor,
        // appBar: CustomAppBar(
        //   backarow: backarrow,
        //   precedingicon: preceedingicon,
        //   titleText: "New Chat",
        //   succedingIcon: 'assets/images/checkmark.svg',
        //   ischatscreen: true,
        // ),
        body: Column(
          children: [
            Flexible(
              child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return issender == true
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, top: 28),
                                          child: Text(
                                            "Zohaib ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: receiverMessagecolor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8,
                                                        right: 26,
                                                        left: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0))),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Flexible(
                                                            child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16,
                                                                  bottom: 16,
                                                                  left: 20,
                                                                  right: 20),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                receiverMessagecolor,
                                                          ),
                                                          child: Text(
                                                            "Hey ben are you ok?",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 25,
                                                                    left: 16),
                                                            child: Text(
                                                              "09:02",
                                                              style: TextStyle(
                                                                color:
                                                                    messageTimeColor,
                                                                fontSize: 14,
                                                              ),
                                                            ))
                                                      ],
                                                    )),
                                              )
                                            ]),
                                      ])
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 24, right: 26, left: 40),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Read",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: messageTimeColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                "09:02",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: messageTimeColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 16),
                                          Flexible(
                                              child: Container(
                                            padding: EdgeInsets.only(
                                                top: 16,
                                                bottom: 16,
                                                left: 20,
                                                right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: searchbarContainerColor,
                                            ),
                                            child: Text(
                                              "Amazing!",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: sendMessageColoer,
                                                fontSize: 14,
                                              ),
                                            ),
                                          )),
                                        ],
                                      )),
                                )
                              ],
                            );
                    }),
              ),
            ),
            Container(
                color: messageBoxColor,
                height: 46,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 18),
                      //width:14,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/images/Mic.svg'),
                        onPressed: () {
                          print("three dot icon pressed");
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 17),
                      height: 18,
                      width: 287,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Type your message",
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: typeMessageColor,
                              fontFamily: secondaryFontFamily),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                height: 45,
                color: messageBoxColor,
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/imagepic.svg'),
                              onPressed: () {
                                print("three dot icon pressed");
                              },
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/images/AddCircle.svg'),
                              onPressed: () {
                                print("three dot icon pressed");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 14),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/images/sendmsg.svg'),
                        onPressed: () {
                          print("three dot icon pressed");
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}


