import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import '../../core/models/contact.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../home/CustomAppBar.dart';
import '../home/NoChatScreen.dart';
import '../../constants/constant.dart';
import '../splash/splash.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/providers/groupListProvider.dart';

class CreateGroupChatScreen extends StatefulWidget {
  const CreateGroupChatScreen({Key key}) : super(key: key);
  @override
  _CreateGroupChatScreenState createState() => _CreateGroupChatScreenState();
}

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  ContactProvider contactProvider;
  GroupListProvider groupListProvider;
  AuthProvider authProvider;
  Emitter emitter;
  int count = 0;
  var changingvaalue;
  List<Contact> _selectedContacts = [];
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact> _filteredList = [];
  bool notmatched = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    emitter = Emitter.instance;
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    contactProvider.getContacts(authProvider.getUser.auth_token);
    super.initState();
  }

  onSearch(value) {
    print("this is here $value");
    List temp;
    temp = contactProvider.contactList.users
        .where((element) => element.full_name.toLowerCase().startsWith(value))
        .toList();
    print("this is filtered list $_filteredList");

    setState(() {
      if (temp.isEmpty) {
        notmatched = true;
        print("Here in true not matched");
      } else {
        print("Here in false matched");
        notmatched = false;
        _filteredList = temp;
      }
    });
  }

  publishMessage(key, channelname, sendmessage) {
    print("print im here ");
    print("The key:$key....$channelname...$sendmessage");
    emitter.publish(key, channelname, sendmessage);
  }

  Future buildShowDialog(BuildContext context,String mesg, String errorMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
                title: Center(
                    child: Text(
                  "$mesg",
                  style: TextStyle(color: counterColor),
                )),
                content: Text("$errorMessage"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 0,
                actions: <Widget>[
                  Container(
                    height: 50,
                    width: 319,
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));

    return Consumer2<ContactProvider, AuthProvider>(
        builder: (context, contactListProvider, authProvider, child) {
      if (contactProvider.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (contactProvider.contactState == ContactStates.Success) {
        if (contactListProvider.contactList.users.length == 0)
          return NoChatScreen(
              groupListProvider: groupListProvider,
              emitter: emitter,
              presentCheck: false);
        else {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFous = FocusScope.of(context);
              if (!currentFous.hasPrimaryFocus) {
                currentFous.unfocus();
              }
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: chatRoomBackgroundColor,
                appBar: AppBar(
                    backgroundColor: chatRoomBackgroundColor,
                    elevation: 0.0,
                    leading: Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: chatRoomColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Text(
                        "Create Group Chat",
                        style: TextStyle(
                          color: chatRoomColor,
                          fontSize: 20,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: SvgPicture.asset('assets/checkmark.svg'),
                          onPressed: _selectedContacts.length == 1
                              ? () async {
                                  var groupName =
                                      _selectedContacts[0].full_name +
                                          "-" +
                                          authProvider.getUser.full_name;
                                  print("The Group Join: ${groupName}");
                                  var res = await contactProvider.createGroup(
                                      groupName,
                                      _selectedContacts,
                                      authProvider.getUser.auth_token);
                                  // groupListProvider.getGroupList(
                                  //     authProvider.getUser.auth_token);
                                  GroupModel groupModel =
                                      GroupModel.fromJson(res["group"]);
                                  // print(
                                  //     "this is response of createGroup ${groupModel.channel_key}, ${groupModel.channel_name}");
                                  if (res["is_already_created"]) {
                                    print("here in already created grouup");
                                    buildShowDialog(context,  "Error Message",
                                      "You already have a group with this user");
                                    //   Navigator.pop(context, true);
                                    // Navigator.pop(context, true);
                                  } else {
                                    groupListProvider.addGroup(groupModel);
                                    groupListProvider.subscribeChannel(
                                        groupModel.channel_key,
                                        groupModel.channel_name);
                                    groupListProvider.subscribePresence(
                                        groupModel.channel_key,
                                        groupModel.channel_name,
                                        true,
                                        true);

                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                  }
                                }
                              : _selectedContacts.length > 1
                                  ? _selectedContacts.length <= 4
                                      ? () {
                                          print("Here in greater than 1");
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ListenableProvider<
                                                    GroupListProvider>.value(
                                                  value: groupListProvider,
                                                  child: CreateGroupPopUp(
                                                      editGroupName: false,
                                                      publishMessage:
                                                          publishMessage,
                                                      groupNameController:
                                                          _groupNameController,
                                                      contactProvider:
                                                          contactProvider,
                                                      selectedContacts:
                                                          _selectedContacts,
                                                      // groupListProvider: groupListProvider,
                                                      authProvider:
                                                          authProvider),
                                                );
                                              });
                                        }
                                      : () {
                                          buildShowDialog(context,  "Error Message",
                                              "Contacts should not be greater than 5!!!");
                                        }
                                  : () {
                                      buildShowDialog(context,  "Error Message",
                                          "Please Select At least one contact to proceed!!!");
                                    },
                        ),
                      ),
                    ]),
                //Search Bar//
                body: Column(
                  children: [
                    Container(
                      //height: 50,
                      padding: EdgeInsets.only(left: 21, right: 21),
                      child: TextFormField(
                        //textAlign: TextAlign.center,
                        controller: _searchController,
                        onChanged: (value) {
                          onSearch(value);
                        },
                        validator: (value) =>
                            value.isEmpty ? "Field cannot be empty." : null,
                        decoration: InputDecoration(
                          fillColor: refreshTextColor,
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/SearchIcon.svg',
                              width: 20,
                              height: 20,
                              fit: BoxFit.fill,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: searchbarContainerColor)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: searchbarContainerColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: searchbarContainerColor)),
                          hintText: "Search",
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: searchTextColor,
                              fontFamily: secondaryFontFamily),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 21),
                      child: Text(
                        "Select Contact",
                        style: TextStyle(
                            color: selectcontactColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Scrollbar(
                        child: notmatched == true
                            ? Text("No data Found")
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 10),
                                itemCount: _searchController.text.isEmpty
                                    ? contactListProvider
                                        .contactList.users.length
                                    : _filteredList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Contact element =
                                      _searchController.text.isEmpty
                                          ? contactListProvider
                                              .contactList.users[index]
                                          : _filteredList[index];

                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (_selectedContacts.indexWhere(
                                                  (contact) =>
                                                      contact.user_id ==
                                                      element.user_id) !=
                                              -1) {
                                            setState(() {
                                              _selectedContacts.remove(element);
                                            });
                                          } else {
                                            setState(() {
                                              _selectedContacts.add(element);
                                            });
                                          }
                                        },
                                        leading: Container(
                                          margin: const EdgeInsets.only(
                                              left: 12, right: 14),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/User.svg'),
                                        ),
                                        title: Text(
                                          "${element.full_name}",
                                          style: TextStyle(
                                            color: contactNameColor,
                                            fontSize: 16,
                                            fontFamily: primaryFontFamily,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Container(
                                          margin: EdgeInsets.only(right: 35),
                                          child: _selectedContacts.indexWhere(
                                                      (contact) =>
                                                          contact.user_id ==
                                                          element.user_id) ==
                                                  -1
                                              ? Text("")
                                              : SvgPicture.asset(
                                                  'assets/checkmark-circle.svg'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Divider(
                                      thickness: 1,
                                      color: listdividerColor,
                                    ),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                )),
          );
        }
      } else {
        return Scaffold(
          backgroundColor: chatRoomBackgroundColor,
          appBar: CustomAppBar(
            groupListProvider: groupListProvider,
            title: "New Chat",
            lead: true,
            succeedingIcon: 'assets/checkmark.svg',
            ischatscreen: false,
          ),
          body: Center(
              child: Text(
            "${contactProvider.errorMsg}",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )),
        );
      }
    });
  }
}
