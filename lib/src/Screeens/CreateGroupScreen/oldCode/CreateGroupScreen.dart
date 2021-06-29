import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/splash/splash.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/models/contact.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  ContactProvider contactProvider;

  GroupListProvider groupListProvider;

  AuthProvider authProvider;
  int count = 0;
  var changingvaalue;
  List<Contact> _selectedContacts = [];
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact> _filteredList = [];
  bool notmatched = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    contactProvider.getContacts(authProvider.getUser.auth_token);

    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  onSearch(value) {
    print("this is here $value");
    List temp;
    temp = contactProvider.contactList.users
        .where((element) => element.full_name.contains(value))
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

  showSnakbar() {
    final snackBar = SnackBar(
      content: Text(
        'Atleast one user should be selected',
        style: TextStyle(color: whiteColor),
      ),
      backgroundColor: primaryColor,
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactProvider, AuthProvider>(
        builder: (context, contactListProvider, authProvider, child) {
      if (contactProvider.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (contactProvider.contactState == ContactStates.Success) {
        if (contactListProvider.contactList.users.length == 0)
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  scaffoldKey.currentState.removeCurrentSnackBar();
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact List",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${contactListProvider.contactList.users.length} contacts",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            body: Text("Empty List"),
          );

        //if data found
        else
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Contact",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${contactListProvider.contactList.users.length} contacts",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Card(
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      onSearch(value);
                    },
                    validator: (value) =>
                        value.isEmpty ? "Field cannot be empty." : null,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                      // contentPadding: EdgeInsets.only(left: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textfieldBorderColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: redColor, width: 2.0),
                      ),
                      hintText: "Search... ",
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: font_Family,
                          fontStyle: FontStyle.normal,
                          color: placeholderTextColor),
                    ),
                  ),
                ),
                Expanded(
                  child: notmatched == true
                      ? Text("No data Found")
                      : ListView.builder(
                          itemCount: _searchController.text.isEmpty
                              ? contactListProvider.contactList.users.length
                              : _filteredList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, userindex) {
                            //      print("this is is selected value: ${contactListProvider.contactList.users[userindex].isSelected}");
                            Contact element = _searchController.text.isEmpty
                                ? contactListProvider
                                    .contactList.users[userindex]
                                : _filteredList[userindex];
                            return buildInkWell(
                                element, userindex, contactListProvider);
                          }),
                ),
              ],
            ),

            //CREATE GROUP BUTTON
            floatingActionButton: FloatingActionButton(
              heroTag: "1",
              child: Icon(Icons.check),
              onPressed: _selectedContacts.length == 1
                  ? () async {
                      var groupName = _selectedContacts[0].full_name +
                          "-" +
                          authProvider.getUser.full_name;
                      print("The Group Join: ${groupName}");
                      await contactProvider.createGroup(groupName,
                          _selectedContacts, authProvider.getUser.auth_token);
                      groupListProvider
                          .getGroupList(authProvider.getUser.auth_token);

                      Navigator.pop(context, true);
                    }
                  : _selectedContacts.length > 1
                      ? () {
                          print("Here in greater than 1");
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Center(
                                        child: Text(
                                      "Create Group",
                                      style: TextStyle(fontSize: 14),
                                    )),
                                    content: TextField(
                                      controller: _groupNameController,
                                      decoration: InputDecoration(
                                          hintText: "enter group name"),
                                    ),
                                    actions: [
                                      TextButton(
                                          child: Center(
                                              child: Text(
                                            "Create",
                                            style:
                                                TextStyle(color: primaryColor),
                                          )),
                                          onPressed: () async {
                                            await contactProvider.createGroup(
                                                _groupNameController.text,
                                                _selectedContacts,
                                                authProvider
                                                    .getUser.auth_token);
                                            groupListProvider.getGroupList(
                                                authProvider
                                                    .getUser.auth_token);

                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  ));
                        }
                      : showSnakbar,
            ),
          );
      } else {
        return Scaffold(
          // key: MyKey.scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Contact List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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

  InkWell buildInkWell(
      Contact element, int userindex, ContactProvider contactListProvider) {
    return InkWell(
      onTap: () {
        // contactProvider.selectGroups(userindex);
        if (_selectedContacts
                .indexWhere((contact) => contact.user_id == element.user_id) !=
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
      child: ListTile(
        leading: Container(
          height: 53,
          width: 50,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: Icon(
                  Icons.person,
                  size: 26,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blueGrey[200],
              ),
              // contactListProvider.contactList.users[userindex].isSelected ==
              //             false ||
              //         contactListProvider
              //                 .contactList.users[userindex].isSelected ==
              //             null
              _selectedContacts.indexWhere(
                          (contact) => contact.user_id == element.user_id) ==
                      -1
                  ? Container()
                  : Positioned(
                      bottom: 4,
                      right: 5,
                      child: CircleAvatar(
                          radius: 11,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )),
                    )
            ],
          ),
        ),
        title: Text("${element.full_name}"),
      ),
    );
  }
}
