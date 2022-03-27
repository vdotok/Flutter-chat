import 'package:flutter/foundation.dart';
import '../models/contact.dart';
import '../models/contactList.dart';
import '../services/server.dart';

enum ContactStates { Loading, Success, Faliure }

class ContactProvider with ChangeNotifier {
  List<Contact> userGroups = [];

  ContactList _contactList;
  ContactList get contactList => _contactList;

  ContactStates _contactStates = ContactStates.Loading;
  ContactStates get contactState => _contactStates;

  String _errorMsg;
  String get errorMsg => _errorMsg;

  getContacts(String authToken) async {
    var dataRequest = {
      "search_field": "email",
      "search_value": "",
      "condition": "contains",
      "sorting": "ORDER BY username ASC",
      "start_row": 0
    };
    final response = await callAPI(dataRequest, "AllUsers", authToken);
    print("response of all users api $response");
    if (response["status"] != 200) {
      _contactStates = ContactStates.Faliure;
      _errorMsg = response['message'];
      notifyListeners();
    } else {
      final json = {"users": response["users"]};
      _contactList = ContactList.fromJson(json);
      print("this is list00 $_contactList");
      _contactStates = ContactStates.Success;
      notifyListeners();
    }
  }

  selectGroups(index) {
    if (contactList.users[index].isSelected == false ||
        contactList.users[index].isSelected == null) {
      contactList.users[index].isSelected = true;
      userGroups.add(contactList.users[index]);
    } else {
      contactList.users[index].isSelected = false;
      userGroups.remove(contactList.users[index]);
    }
    print("The user group: $userGroups");
    notifyListeners();
  }

  Future<dynamic> createGroup(groupName, _selectedContacts, authToken) async {
    List<int> id_List = [];
    for (int i = 0; i < _selectedContacts.length; i++) {
      id_List.add(_selectedContacts[i].user_id);
      print("Here id List: $id_List");
    }
    var newtemp = {
      'group_title': groupName,
      'participants': id_List,
      'auto_created': _selectedContacts.length == 1 ? 1 : 0
    };

    print("newtemp  .... ${newtemp}");
    final response = await callAPI(newtemp, "CreateGroup", authToken);
    print("the current data is: $response");
    return response;
    //  notifyListeners();
  }
}
