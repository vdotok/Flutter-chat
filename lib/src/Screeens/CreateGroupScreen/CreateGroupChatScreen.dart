import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
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
  final ContactProvider contactProvider;
  final MainProvider mainProvider;
  final GroupListProvider? groupListProvider;
  final refreshList;
  final handlePress;
  const CreateGroupChatScreen(
      {Key? key,
      required this.contactProvider,
      required this.mainProvider,
      required this.groupListProvider,
      this.refreshList,
      this.handlePress})
      : super(key: key);
  @override
  _CreateGroupChatScreenState createState() => _CreateGroupChatScreenState();
}

List<Contact> selectedContacts = [];

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  late ContactProvider contactProvider;
  late GroupListProvider groupListProvider;
  late AuthProvider authProvider;
  late Emitter emitter;
  int count = 0;
  var changingvaalue;

  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact?>? _filteredList = [];
  bool notmatched = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    emitter = Emitter.instance;
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    super.initState();
  }

  onSearch(value) {
    print("this is here $value");
    List? temp;
    temp = widget.contactProvider.contactList.users!
        .where((element) => element!.full_name.toLowerCase().startsWith(value))
        .toList();
    print("this is filtered list $_filteredList");

    setState(() {
      if (temp!.isEmpty) {
        notmatched = true;
        print("Here in true not matched");
      } else {
        print("Here in false matched");
        notmatched = false;
        _filteredList = temp.cast<Contact?>();
      }
    });
  }

  publishMessage(key, channelname, sendmessage) {
    print("print im here ");
    print("The key:$key....$channelname...$sendmessage");
    emitter.publish(key, channelname, sendmessage, 0);
  }

  Future buildShowDialog(
      BuildContext context, String mesg, String errorMessage) {
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
      if (widget.contactProvider.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (widget.contactProvider.contactState == ContactStates.Success) {
        if (widget.contactProvider.contactList.users!.length == 0)
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
                          if (strArr.last == "CreateGroupChat") {
                            widget
                                .handlePress(HomeStatus.CreateIndividualGroup);
                            strArr.remove("CreateGroupChat");
                            selectedContacts.clear();
                          }
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
                          onPressed: !isInternetConnect
                              ? () {}
                              : selectedContacts.length == 1
                                  ? () async {
                                      var groupName =
                                          selectedContacts[0].full_name +
                                              "-" +
                                              authProvider.getUser!.full_name;
                                      print("The Group Join: ${groupName}");

                                      var res = await widget.contactProvider
                                          .createGroup(
                                              groupName,
                                              selectedContacts,
                                              authProvider.getUser!.auth_token);
                                      // groupListProvider.getGroupList(
                                      //     authProvider.getUser.auth_token);

                                      if (res["status"] == 200) {
                                        GroupModel groupModel =
                                            GroupModel.fromJson(res["group"]);
                                        // print(
                                        //     "this is response of createGroup ${groupModel.channel_key}, ${groupModel.channel_name}");
                                        if (res["is_already_created"]) {
                                          print(
                                              "here in already created grouup");
                                          buildShowDialog(
                                              context,
                                              "Error Message",
                                              "You already have a group with this user");
                                          //   Navigator.pop(context, true);
                                          // Navigator.pop(context, true);
                                        } else {
                                          List<String> refIDList = [];
                                          for (int i = 0;
                                              i < selectedContacts.length;
                                              i++) {
                                            refIDList.add(
                                                selectedContacts[i].ref_id!);
                                          }
                                          GroupModel groupModel =
                                              GroupModel.fromJson(res["group"]);
                                          var tempdata = {
                                            "from":
                                                authProvider.getUser!.ref_id,
                                            "data": {
                                              "action":
                                                  "new", //new, modify, delete
                                              "groupModel": groupModel
                                            },
                                            "to": refIDList
                                          };
                                          emitter.publishNotification(tempdata);
                                          groupListProvider
                                              .addGroup(groupModel);
                                          groupListProvider.subscribeChannel(
                                              groupModel.channel_key,
                                              groupModel.channel_name);
                                          groupListProvider.subscribePresence(
                                              groupModel.channel_key,
                                              groupModel.channel_name,
                                              true,
                                              true);
                                          publishMessage(
                                              key, channelname, sendmessage) {
                                            print(
                                                "The key:$key....$channelname...$sendmessage");
                                            emitter.publish(key, channelname,
                                                sendmessage, 0);
                                          }

                                          if (strArr.last ==
                                              "CreateGroupChat") {
                                            strArr.remove("CreateGroupChat");
                                          }
                                          widget.mainProvider
                                              .chatScreen(index: 0);

                                          selectedContacts.clear();
                                        }
                                      } else {}
                                    }
                                  : selectedContacts.length > 1
                                      ? selectedContacts.length <= 4
                                          ? () {
                                              print("Here in greater than 1");
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ListenableProvider<
                                                        GroupListProvider>.value(
                                                      value: groupListProvider,
                                                      child: CreateGroupPopUp(
                                                        
                                                        handlePress:
                                                            widget.handlePress,
                                                        editGroupName: false,
                                                        publishMessage:
                                                            publishMessage,
                                                        groupNameController:
                                                            _groupNameController,
                                                        contactProvider: widget
                                                            .contactProvider,
                                                        selectedContacts:
                                                            selectedContacts,
                                                        mainProvider:
                                                            widget.mainProvider,
                                                        // groupListProvider: groupListProvider,
                                                        authProvider:
                                                            authProvider,
                                                        controllerText: '',
                                                      ),
                                                    );
                                                  });
                                            }
                                          : () {
                                              buildShowDialog(
                                                  context,
                                                  "Error Message",
                                                  "Contacts should not be greater than 5!!!");
                                            }
                                      : () {
                                          buildShowDialog(
                                              context,
                                              "Error Message",
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
                            value!.isEmpty ? "Field cannot be empty." : null,
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
                                    ? widget.contactProvider.contactList.users!
                                        .length
                                    : _filteredList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Contact? element =
                                      _searchController.text.isEmpty
                                          ? widget.contactProvider.contactList
                                              .users![index]
                                          : _filteredList![index];

                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (selectedContacts.indexWhere(
                                                  (contact) =>
                                                      contact.user_id ==
                                                      element!.user_id) !=
                                              -1) {
                                            setState(() {
                                              selectedContacts.remove(element);
                                            });
                                          } else {
                                            setState(() {
                                              selectedContacts.add(element!);
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
                                          "${element!.full_name}",
                                          style: TextStyle(
                                            color: contactNameColor,
                                            fontSize: 16,
                                            fontFamily: primaryFontFamily,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Container(
                                          margin: EdgeInsets.only(right: 35),
                                          child: selectedContacts.indexWhere(
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
            "${widget.contactProvider.errorMsg}",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )),
        );
      }
    });
  }
}
