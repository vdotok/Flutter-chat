import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../constants/constant.dart';
import '../../core/models/contact.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';

class CreateGroupPopUp extends StatefulWidget {
  const CreateGroupPopUp(
      {Key key,
      @required TextEditingController groupNameController,
      this.contactProvider,
      List<Contact> selectedContacts,
      @required this.publishMessage,
      @required this.authProvider,
      this.controllerText,
      this.editGroupName,
      this.groupid})
      : _groupNameController = groupNameController,
        _selectedContacts = selectedContacts,
        super(key: key);

  final TextEditingController _groupNameController;
  final ContactProvider contactProvider;
  final List<Contact> _selectedContacts;
  final AuthProvider authProvider;
  final publishMessage;
  final String controllerText;
  final bool editGroupName;

  final int groupid;

  @override
  _CreateGroupPopUpState createState() => _CreateGroupPopUpState();
}

class _CreateGroupPopUpState extends State<CreateGroupPopUp> {
  @override
  void initState() {
    if (widget.controllerText != "" || widget.controllerText != null) {
      widget._groupNameController.text = widget.controllerText;
    }
  }

  @override
  Widget build(BuildContext context) {
    showSnakbar(
      msg,
    ) {
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

    return GestureDetector(onTap: () {
      FocusScopeNode currentFous = FocusScope.of(context);
      if (!currentFous.hasPrimaryFocus) {
        currentFous.unfocus();
      }
    }, child: StatefulBuilder(builder: (context, setState) {
      var searchFontFamily;
      return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 0,
                actions: <Widget>[
              Container(
                  height: 278,
                  width: 319,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 201,
                              height: 17,
                              margin: EdgeInsets.only(left: 24, top: 30),
                              child: Text(
                                "Create a group chat",
                                style: TextStyle(
                                  color: createGroupColor,
                                  fontSize: 14,
                                  fontFamily: searchFontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                // right: 23,
                                // top: 30,
                                left: 54,
                                top: 30),
                            width: 30,
                            height: 30,
                            child: IconButton(
                              icon: SvgPicture.asset('assets/close.svg'),
                              onPressed: () {
                                widget._groupNameController.clear();
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, top: 40.7, right: 24),
                        width: 271.36,
                        child: Text(
                          "Name your group chat",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: groupChtnmeColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 23, top: 9),
                        child: TextFormField(
                          controller: widget._groupNameController,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: (widget.controllerText == "" ||
                                    widget.controllerText == null)
                                ? "ex:Deeper Time"
                                : null,
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: textfieldhint,
                                fontFamily: secondaryFontFamily),
                          ),
                        ),
                      ),
                      Container(
                        width: 271.36,
                        height: 0.50,
                        color: Color(0xffd1d9df),
                      ),
                      SizedBox(height: 38),
                      Container(
                          width: 144,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: doneButtonColor,
                          ),
                          child: Consumer<GroupListProvider>(
                            builder: (context, grouplistp, child) {
                              return Center(
                                  child: FlatButton(
                                padding: EdgeInsets.all(8.0),
                                onPressed: grouplistp.creatChatStatusStatus ==
                                        CreateChatStatus.New
                                    ? () async {
                                        if (widget.editGroupName) {
                                          print("here");

                                          await grouplistp.editGroupName(
                                              widget._groupNameController.text,
                                              widget.groupid,
                                              widget.authProvider.getUser
                                                  .auth_token);
                                          if (grouplistp.editGroupNameStatus ==
                                              EditGroupNameStatus.Success) {
                                            showSnakbar(grouplistp.successMsg);
                                          } else if (grouplistp
                                                  .editGroupNameStatus ==
                                              EditGroupNameStatus.Failure) {
                                            showSnakbar(grouplistp.errorMsg);
                                          } else {}
                                          Navigator.of(context).pop();
                                        } else {
                                          if (widget._groupNameController.text
                                                  .isEmpty ||
                                              widget._groupNameController ==
                                                  null ||
                                              widget._selectedContacts.length >
                                                  20) {
                                            return null;
                                          } else {
                                            grouplistp.handleCreateChatState();
                                            var res = await widget
                                                .contactProvider
                                                .createGroup(
                                                    widget._groupNameController
                                                        .text,
                                                    widget._selectedContacts,
                                                    widget.authProvider.getUser
                                                        .auth_token);

                                            // grouplistp.getGroupList(
                                            //     authProvider.getUser.auth_token);
                                            GroupModel groupModel =
                                                GroupModel.fromJson(
                                                    res["group"]);
                                            print(
                                                "this is response of createGroup ${groupModel.channel_key}, ${groupModel.channel_name}");

                                            grouplistp.addGroup(groupModel);
                                            grouplistp.subscribeChannel(
                                                groupModel.channel_key,
                                                groupModel.channel_name);
                                            grouplistp.subscribePresence(
                                                groupModel.channel_key,
                                                groupModel.channel_name,
                                                true,
                                                true);

                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                                context, "/chatScreen",
                                                arguments: {
                                                  "index": 0,
                                                  "publishMessage":
                                                      widget.publishMessage,
                                                  "groupListProvider":
                                                      grouplistp
                                                });

                                            grouplistp.handleCreateChatState();
                                            //  _selectedContacts.clear();
                                          }
                                        }
                                      }
                                    : () {},
                                child: grouplistp.creatChatStatusStatus ==
                                        CreateChatStatus.New
                                    ? Text(
                                        "DONE",
                                        style: TextStyle(
                                          color: doneButtontextColor,
                                          fontSize: 14,
                                          fontFamily: primaryFontFamily,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.90,
                                        ),
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    chatRoomColor)),
                                      ),
                              ));
                            },
                          ))
                    ],
                  ))
            ])),
      );
    }));
  }
}
