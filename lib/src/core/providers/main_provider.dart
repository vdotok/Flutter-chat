import 'package:flutter/foundation.dart';

import 'contact_provider.dart';
import 'groupListProvider.dart';

enum HomeStatus {
  ChatScreen,
  CreateIndividualGroup,
  CreateGroupChat,
  Home,
 
}

class MainProvider with ChangeNotifier {
  HomeStatus _homeStatus = HomeStatus.Home;
  
  HomeStatus get homeStatus => _homeStatus;

  int _index = 0;
  int get index => _index;
  dynamic _publishMesg;
  dynamic get publishMesg => _publishMesg;
  dynamic _startCall;
  dynamic get startCall => startCall;
  late GroupListProvider _groupListProvider;
  GroupListProvider get groupListProvider => _groupListProvider;
  late ContactProvider _contactProvider;
  ContactProvider get contactProvider => _contactProvider;
  initial() {
    _homeStatus = HomeStatus.Home;
    print("i am here in initial  notify listener");
    notifyListeners();
  }

  handleState(HomeStatus state) {
    print("This is handle group list state $state");
    _homeStatus = state;

    notifyListeners();
  }

  homeScreen() {
    _homeStatus = HomeStatus.Home;
    print("home screen");
    print("hghdfghfd $_homeStatus");
    notifyListeners();
  }

  chatScreen({int ?index, GroupListProvider? groupListProvider}) {
    _index = index!;
    _homeStatus = HomeStatus.ChatScreen;
    print("chat screen in main provider $index");
    print("this is homeStatus $_homeStatus");
    notifyListeners();
  }

  createIndividualGroupScreen() {
    _homeStatus = HomeStatus.CreateIndividualGroup;
    print("create individual group");
    notifyListeners();
  }

  createGroupChatScreen() {
    _homeStatus = HomeStatus.CreateGroupChat;
    print("create group chat screen");
    notifyListeners();
  }
}
