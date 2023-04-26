import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/home/CustomAppBar.dart';
import 'package:vdkFlutterChat/src/Screeens/home/NoChatScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/Screeens/splash/splash.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../core/models/contact.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/providers/groupListProvider.dart';

List<Contact> selectedContacts = [];

class ContactListScreen extends StatefulWidget {
  final ContactProvider contactProvider;

  final MainProvider mainProvider;
  final GroupListProvider groupListProvider;
  final refreshList;
  final handlePress;
  const ContactListScreen(
      {Key? key,
      required this.contactProvider,
      required this.mainProvider,
      required this.groupListProvider,
      this.refreshList,
      this.handlePress})
      : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  //ContactProvider contactProvider;
  late GroupListProvider groupListProvider;
  late AuthProvider authProvider;
  int count = 0;
  var changingvaalue;

  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact?>? _filteredList = [];
  bool notmatched = false;
  late Emitter emitter;
  late GlobalKey<ScaffoldState> scaffoldKey;
  bool loading = false;

  //bool isLoading = false;
  @override
  void initState() {
    //contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    //contactProvider.getContacts(authProvider.getUser.auth_token);

    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    emitter = Emitter.instance;
  }

  onSearch(value) {
    List temp;

    temp = widget.contactProvider.contactList.users!.where((element) {
      // if (element.full_name.toLowerCase().startsWith(value.toLowerCase())==true) {
      //   print("i am here");
      return element!.full_name.toLowerCase().startsWith(value.toLowerCase());
      // }
      // else {
      //   return element.full_name.toLowerCase().contains(value.toLowerCase());
      // }
      //  || element.full_name.toLowerCase().contains(value.toLowerCase()))
    }).toList();
    // ..sort((a, b) {
    //   a.full_name.toLowerCase().compareTo(b.full_name.toLowerCase());
    // });
    //..sort((a, b) => a.full_name.toString().compareTo(b.full_name.toString())

    // toString().compareTo(b.toString())
    //);
// if(temp.isEmpty){
//   temp = contactProvider.contactList.users.where((element) {
//       // if (element.full_name.toLowerCase().startsWith(value.toLowerCase())==true) {
//       //   print("i am here");
//         return element.full_name.toLowerCase().contains(value.toLowerCase()) ;
//      // }
//       // else {
//       //   return element.full_name.toLowerCase().contains(value.toLowerCase());
//       // }
//       //  || element.full_name.toLowerCase().contains(value.toLowerCase()))
//     }).toList();
// }
    setState(() {
      if (temp.isEmpty) {
        notmatched = true;
        print("Here in true not matched");
      } else {
        print("Here in false matched");
        notmatched = false;
        _filteredList = temp.cast<Contact?>();
      }
    });
    print("this is filtered list ${_filteredList![0]!.full_name}  ");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactProvider, AuthProvider>(
        builder: (context, contactListProvider, authProvider, child) {
      if (widget.contactProvider.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (widget.contactProvider.contactState == ContactStates.Success) {
        if (widget.contactProvider.contactList.users!.length == 0)
          return NoChatScreen(
            emitter: emitter,
            groupListProvider: groupListProvider,
            presentCheck: false,
          );
        else
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFous = FocusScope.of(context);
                if (!currentFous.hasPrimaryFocus) {
                  currentFous.unfocus();
                }
              },
              child: Scaffold(
                appBar: CustomAppBar(
                    mainProvider: widget.mainProvider,
                    lead: true,
                    ischatscreen: false,
                    title: "New Chat",
                    succeedingIcon: '',
                    groupListProvider: groupListProvider),
                body: SafeArea(
                    child: Column(
                  children: [
                    Container(
                      height: 50,
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
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print("in gesture detector");
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: 13,
                                right: 13,
                              ),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  SvgPicture.asset('assets/GroupChatIcon.svg'),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (strArr.last == "CreateIndividualGroup") {
                                  widget.mainProvider.createGroupChatScreen();
                                  // widget
                                  //     .handlePress(HomeStatus.CreateGroupChat);
                                  strArr.remove("CreateIndividualGroup");
                                }
                              },
                              child: SizedBox(
                                width: 236,
                                child: Text(
                                  "Add Group Chat",
                                  style: TextStyle(
                                    color: addGroupChatColor,
                                    fontSize: 16,
                                    fontFamily: primaryFontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 370,
                      child: Divider(
                        thickness: 1,
                        color: listdividerColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Contacts",
                            style: TextStyle(
                                color: contactColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: secondaryFontFamily)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Scrollbar(
                        child: notmatched == true
                            ? Text("No data Found")
                            : ListView.separated(
                                shrinkWrap: true,
                                //  padding: const EdgeInsets.only(top: 5),
                                itemCount: _searchController.text.isEmpty
                                    ? widget.contactProvider.contactList.users!
                                        .length
                                    : _filteredList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Contact? test = _searchController.text.isEmpty
                                      ? widget.contactProvider.contactList
                                          .users![index]
                                      : _filteredList![index];
                                  var groupIndex = groupListProvider
                                      .groupList.groups!
                                      .indexWhere((element) =>
                                          element!.group_title ==
                                          authProvider.getUser!.full_name +
                                              test!.full_name);

                                  return Column(
                                    children: [
                                      ListTile(
                                        // onTap: () {
                                        //   if (_selectedContacts.indexWhere(
                                        //           (contact) =>
                                        //               contact.user_id ==
                                        //               element.user_id) !=
                                        //       -1) {
                                        //     setState(() {
                                        //       _selectedContacts.remove(element);
                                        //     });
                                        //   } else {
                                        //     setState(() {
                                        //       _selectedContacts.add(element);
                                        //     });
                                        //   }
                                        // },
                                        leading: Container(
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
                                          "${test!.full_name}",
                                          style: TextStyle(
                                            color: contactNameColor,
                                            fontSize: 16,
                                            fontFamily: primaryFontFamily,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                            onTap: !isInternetConnect
                                                ? () {}
                                                : loading == false
                                                    ? () async {
                                                        groupListProvider
                                                            .handleCreateChatState();
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        selectedContacts
                                                            .add(test);
                                                        print(
                                                            "the selected contacts:${test.full_name}");
                                                        var res = await widget
                                                            .contactProvider
                                                            .createGroup(
                                                                authProvider
                                                                        .getUser!
                                                                        .full_name +
                                                                    selectedContacts[
                                                                            0]
                                                                        .full_name,
                                                                selectedContacts,
                                                                authProvider
                                                                    .getUser!
                                                                    .auth_token);

                                                        if (res["status"] ==
                                                            200) {
                                                          List<String>
                                                              refIDList = [];
                                                          for (int i = 0;
                                                              i <
                                                                  selectedContacts
                                                                      .length;
                                                              i++) {
                                                            refIDList.add(
                                                                selectedContacts[
                                                                        i]
                                                                    .ref_id!);
                                                          }
                                                           GroupModel
                                                              groupModel =
                                                              GroupModel
                                                                  .fromJson(res[
                                                                      "group"]);
                                                          var tempdata = {
                                                            "from": authProvider
                                                                .getUser!
                                                                .ref_id,
                                                            "data": {
                                                              "action":
                                                                  "new", //new, modify, delete
                                                              "groupModel":
                                                                groupModel
                                                            },
                                                            "to": refIDList

                                                            // "from":
                                                            //     authProvider
                                                            //     .getUser!
                                                            //     .ref_id, //ref_id who send this packet
                                                            // "id": ((DateTime.now())
                                                            //         .millisecondsSinceEpoch)
                                                            //     .round(),
                                                            // "type":
                                                            //     "create", //type (create/Delete/Update)
                                                            // "users": refIDList
                                                          };
                                                          emitter
                                                              .publishNotification(
                                                                  tempdata);
                                                          // var getGroups=await

                                                          print(
                                                              "this is already created index ${res["is_already_created"]}");
                                                         
                                                          print(
                                                              "this is group index $groupIndex");
                                                          // print(
                                                          //     "this is response of createGroup ${groupModel.participants![0]!.full_name}, ${groupModel.participants![1]!.full_name}");

                                                          int channelIndex = 0;
                                                          if (res[
                                                              "is_already_created"]) {
                                                            channelIndex = groupListProvider
                                                                .groupList
                                                                .groups!
                                                                .indexWhere((element) =>
                                                                    element!
                                                                        .channel_key ==
                                                                    res["group"]
                                                                        [
                                                                        "channel_key"]);

                                                            print(
                                                                "this is already created index $channelIndex");
                                                          } else {
                                                            groupListProvider
                                                                .addGroup(
                                                                    groupModel);
                                                            groupListProvider
                                                                .subscribeChannel(
                                                                    groupModel
                                                                        .channel_key,
                                                                    groupModel
                                                                        .channel_name);
                                                            groupListProvider
                                                                .subscribePresence(
                                                                    groupModel
                                                                        .channel_key,
                                                                    groupModel
                                                                        .channel_name,
                                                                    true,
                                                                    true);
                                                          }

                                                          publishMessage(
                                                              key,
                                                              channelname,
                                                              sendmessage) {
                                                            print(
                                                                "The key:$key....$channelname...$sendmessage");
                                                            emitter.publish(
                                                                key,
                                                                channelname,
                                                                sendmessage,
                                                                0);
                                                          }

                                                          if (res[
                                                              "is_already_created"]) {
                                                            if (strArr.last ==
                                                                "CreateIndividualGroup") {
                                                              strArr.remove(
                                                                  "CreateIndividualGroup");
                                                            } else {
                                                              strArr.remove(
                                                                  "CreateGroupChat");
                                                            }
                                                            //  widget.mainProvider
                                                            //     .chatScreen(
                                                            //       index: 0);
                                                            widget.mainProvider
                                                                .chatScreen(
                                                                    index:
                                                                        channelIndex);
                                                          } else {
                                                            if (strArr.last ==
                                                                "CreateIndividualGroup") {
                                                              strArr.remove(
                                                                  "CreateIndividualGroup");
                                                            } else {
                                                              strArr.remove(
                                                                  "CreateGroupChat");
                                                            }
                                                            widget.mainProvider
                                                                .chatScreen(
                                                                    index: 0);
                                                          }
                                                          selectedContacts
                                                              .clear();
                                                          groupListProvider
                                                              .handleCreateChatState();
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                        } else {}
                                                      }
                                                    : () {},
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 35),
                                              child: SvgPicture.asset(
                                                  'assets/messageicon.svg'),
                                            )),
                                      )
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
                    ),
                  ],
                )),
              ));
      } else {
        return Scaffold(
          backgroundColor: chatRoomBackgroundColor,
          appBar: CustomAppBar(
            groupListProvider: groupListProvider,
            title: "New Chat",
            lead: true,
            succeedingIcon: '',
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
