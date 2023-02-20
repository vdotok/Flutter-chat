import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import '../../jsManager/jsManager.dart';
import '../models/ChatModel.dart';
import '../models/GroupListModel.dart';
import '../models/GroupModel.dart';
import '../services/server.dart';
import 'package:vdotok_connect/vdotok_connect.dart';

enum ListStatus { Scussess, Failure, Loading }

enum CreateChatStatus { New, Loading }

enum DeleteGroupStatus { Success, Failure, Loading }

enum EditGroupNameStatus { Success, Failure, Loading }

class GroupListProvider with ChangeNotifier {
  ListStatus _groupListStatus = ListStatus.Loading;
  ListStatus get groupListStatus => _groupListStatus;

  CreateChatStatus _createChatStatusStatus = CreateChatStatus.New;
  CreateChatStatus get creatChatStatusStatus => _createChatStatusStatus;

  DeleteGroupStatus _deleteGroupStatus = DeleteGroupStatus.Loading;
  DeleteGroupStatus get deleteGroupStatus => _deleteGroupStatus;

  EditGroupNameStatus _editGroupNameStatus = EditGroupNameStatus.Loading;
  EditGroupNameStatus get editGroupNameStatus => _editGroupNameStatus;

  late GroupListModel _groupList;
  GroupListModel get groupList => _groupList;

  GroupModel? _currentOpenedChat;
  GroupModel? get currentOpendChat => _currentOpenedChat;

  List<String> _presenceList = [];
  List<String> get presenceList => _presenceList;

  List<String> _typingUserDetail = [];
  List<String> get typingUserDetail => _typingUserDetail;

  List<int> _readParticipants = [];
  List<int> get readParticipants => _readParticipants;

  late String _successMsg;
  String get successMsg => _successMsg;

  late String _errorMsg;
  String get errorMsg => _errorMsg;

  late int _status;
  int get status => _status;

  // set readmodelList(List<ReadModel> myList) {
  //   _readmodelList = myList;
  // }

  Emitter _emitter = Emitter.instance;
  handleCreateChatState() {
    if (_createChatStatusStatus == CreateChatStatus.New) {
      print("this is loading ");
      _createChatStatusStatus = CreateChatStatus.Loading;
    } else
      _createChatStatusStatus = CreateChatStatus.New;

    notifyListeners();
  }

  getGroupList(authToken) async {
    var currentData = await getAPI("AllGroups", authToken);
    print(
        "Current group data: ${currentData}");
    // print(
    //     "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _groupListStatus = ListStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } 
   else {
  //     if(currentData["groups"]==null){
  //        _groupListStatus = ListStatus.Scussess;
  //       notifyListeners();
  //     }
  //  else {
      _groupList = GroupListModel.fromJson(currentData);
      if (_groupList.groups!.length == 0) {
        _groupListStatus = ListStatus.Scussess;
        notifyListeners();
      } else {
        for (int i = 0; i < _groupList.groups!.length; i++) {
          subscribeChannel(_groupList.groups![i]!.channel_key,
              _groupList.groups![i]!.channel_name);
          subscribePresence(_groupList.groups![i]!.channel_key,
              _groupList.groups![i]!.channel_name, true, true);
          // _emitter.subscribe(_groupList.groups[i].channel_key,
          //     _groupList.groups[i].channel_name);
          // _emitter.subscribePresence(_groupList.groups[i].channel_key,
          //     _groupList.groups[i].channel_name);
        }
        // _readmodelList = [];
        notifyListeners();
      }}
    //}
  }

  subscribeChannel(channelKey, channelName) {
    _emitter.subscribe(channelKey, channelName);
  }

  subscribePresence(channelKey, channelName, changes, status) {
    _emitter.subscribePresence(channelKey, channelName, changes, status);
  }

  addGroup(GroupModel groupModel) {
    _groupList.groups!.insert(0, groupModel);
    notifyListeners();
  }

  changeState() {
    _groupListStatus = ListStatus.Scussess;
    notifyListeners();
    for (int i = 0; i < _groupList.groups!.length; i++) {
      _emitter.subscribePresence(_groupList.groups![i]!.channel_key,
          _groupList.groups![i]!.channel_name, true, true);
    }
  }

  handlePresence(data) {
    //print("this is the list ${_readmodelList.length}");
    //  _readmodelList.clear();
    print('this is presence data $data');
    print("presence in provider ${data["who"].length}${data}");
    if (data["event"] == "status") {
      data["who"].forEach((e) {
        print("this is each ${e["username"]}");
        if (_presenceList.indexOf(e["username"]) == -1)
          _presenceList.add(e["username"]);
        //  _readmodelList.add(e["username"]);
      });
      // var index = _groupList.groups
      //     .indexWhere((element) => element.channel_name == data["channel"]);

      // _groupList.groups[index].presence = data;
    } else if (data["event"] == "subscribe") {
      // var index = _groupList.groups
      //     .indexWhere((element) => element.channel_name == data["channel"]);
      // _groupList.groups[index].presence["who"].add(data["who"]);
      if (_presenceList.indexOf(data["who"]["username"]) == -1)
        _presenceList.add(data["who"]["username"]);
      //    _readmodelList = [];
      // _readmodelList.add(data["who"]["username"]);
    } else {
      if (_presenceList.indexOf(data["who"]["username"]) != -1)
        _presenceList.remove(
          data["who"]["username"],
        );
      // _readmodelList.remove(data["who"]["username"]);

      // _readmodelList[]
      // _readmodelList.remove(data[])
      // var index = _groupList.groups
      //     .indexWhere((element) => element.channel_name == data["channel"]);
      // print(
      //     "this is data when unsubscribe $index  ${_groupList.groups[index].presence["who"]}");
      // _groupList.groups[index].presence["who"].removeWhere(
      //     (element) => element["username"] == data["who"]["username"]);
    }

    print("this is presenceList after update $_presenceList");
    notifyListeners();
  }

  recevieMsg(message) {
    print("this is group list ${_groupList.groups!.length} ${message}");
    //find the index of channel... does it exist in grouplist?
    var index = _groupList.groups!
        .indexWhere((element) => element!.channel_key == message["key"]);
    if (index != -1) {
      print("thi is index $index");
      if (_groupList.groups![index]!.chatList == null) {
        _groupList.groups![index]!.chatList = [];
        _groupList.groups![index]!.counter = 1;
        print("i am here in null");
        _groupList.groups![index]!.chatList!.add(ChatModel.fromJson(message));
        if (_currentOpenedChat == null) {
          GroupModel? element = _groupList.groups!.removeAt(index);
          _groupList.groups!.insert(0, element);
          print("i am here in current chat null");
        }
      } else {
        _groupList.groups![index]!.chatList!.add(ChatModel.fromJson(message));
        _groupList.groups![index]!.counter++;
        print("i am here in not null");
        if (_currentOpenedChat == null) {
          GroupModel? element = _groupList.groups!.removeAt(index);
          _groupList.groups!.insert(0, element);
        }
      }
    }
    notifyListeners();
  }

  deleteGroup(group_id, authtoken) async {
    print("group id is $group_id");
    Map<String, dynamic> jsonData = {"group_id": group_id};
    var currentData = await callAPI(jsonData, "DeleteGroup", authtoken);
    print("Current Data: $currentData");
    // print(
    //     "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _deleteGroupStatus = DeleteGroupStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      //_groupListStatus = ListStatus.Scussess;
      _deleteGroupStatus = DeleteGroupStatus.Loading;
      _deleteGroupStatus = DeleteGroupStatus.Success;
      _successMsg = "Group Deleted";
      _status = currentData["status"];
      // _deleteGroupStatus = DeleteGroupStatus.Loading;

      getGroupList(authtoken);

      notifyListeners();
    }
  }

  editGroupName(grouptitle, group_id, authtoken) async {
    print("group id is $group_id");
    Map<String, dynamic> jsonData = {
      "group_title": grouptitle,
      "group_id": group_id
    };
    var currentData = await callAPI(jsonData, "RenameGroup", authtoken);
    print("Current Data: $currentData");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _editGroupNameStatus = EditGroupNameStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      //_groupListStatus = ListStatus.Scussess;
      _editGroupNameStatus = EditGroupNameStatus.Loading;
      _editGroupNameStatus = EditGroupNameStatus.Success;
      _successMsg = currentData["message"];
      _status = currentData["status"];
      // _deleteGroupStatus = DeleteGroupStatus.Loading;

      getGroupList(authtoken);

      notifyListeners();
    }
  }

  sendMsg(index, msg) async {
    if (_groupList.groups![index]!.chatList == null) {
      print("this is send message $index $msg");
      if (kIsWeb == true) {
        if (msg['type'] == MediaType.image) {
          var image = base64Decode(msg['content']);
          print('thisisImage$image');
          msg['content'] = image;
        }
        if (kIsWeb && msg['type'] == MediaType.audio) {
          var url = await JsManager.instance!
              .connect(base64.decode(msg["content"]), msg["fileExtension"]);
          print('this is url on sending end $url');
          msg['content'] = url;
        }
        if (msg['type'] == MediaType.video) {
          var url = await JsManager.instance!
              .connect(base64.decode(msg["content"]), msg["fileExtension"]);
          print('this is url on sending end $url');
          msg['content'] = url;
        }
      }
      _groupList.groups![index]!.chatList = [];
      print("thisis json ${ChatModel.fromJson(msg)}");
      _groupList.groups![index]!.chatList!.add(ChatModel.fromJson(msg));
    } else {
      if (kIsWeb == true) {
        if (msg['type'] == MediaType.image) {
          var image = base64Decode(msg['content']);
          print('thisisImage$image');
          msg['content'] = image;
        }
        if (kIsWeb && msg['type'] == MediaType.audio) {
          var url = await JsManager.instance!
              .connect(base64.decode(msg["content"]), msg["fileExtension"]);
          print('this is url on sending end $url');
          msg['content'] = url;
        }
        if (msg['type'] == MediaType.video) {
          var url = await JsManager.instance!
              .connect(base64.decode(msg["content"]), msg["fileExtension"]);
          print('this is url on sending end $url');
          msg['content'] = url;
        }
      }
    

      _groupList.groups![index]!.chatList!.add(ChatModel.fromJson(msg));
    }
    notifyListeners();
  }

  changeMsgStatus(msg, status) {
    print("this is receipt type $msg");
    var groupindex = _groupList.groups!.indexWhere((element) =>
        element!.channel_key == json.decode(msg)["key"].toString());

    var participantIndex = _groupList.groups![groupindex]!.participants!
        .indexWhere((element) =>
            element!.ref_id == json.decode(msg)["from"].toString());
    var msgindex =
        _groupList.groups![groupindex]!.chatList!.indexWhere((element) {
      return element!.id == json.decode(msg)["messageId"].toString();
      //return element.id == json.decode(msg)["messageId"].toString();
    });
    // var chatIndex= _groupList.groups[groupindex].chatList[0].;

    // if(_groupList.groups[groupindex].chatList[participantIndex].
    print("this is msg --- $participantIndex");
    if (groupindex != -1) {
      if (_groupList.groups![groupindex]!.participants!.length > 2) {
        print(
            "this is msg idddddddd ${json.decode(msg)["messageId"].toString()}");
        // print("this is LISTTTTTTTT $_readmodelList");
        // if (_messageIDD.contains(json.decode(msg)["messageId"].toString())) {
        print("here oooooooo");
        int i = 0;
        while (_groupList.groups![groupindex]!.chatList![i]!.id !=
            json.decode(msg)["messageId"].toString()) {
          i++;
        }
        if (_groupList.groups![groupindex]!.chatList![i]!.id ==
            json.decode(msg)["messageId"].toString()) {
          print(
              "thos osdsdjfk counter ${_groupList.groups![groupindex]!.chatList![i]!.readCount}");
          if (_groupList.groups![groupindex]!.chatList![i]!.participantsRead ==
              null) {
            print("this is nukkk kklkvl");
            _groupList.groups![groupindex]!.chatList![i]!.participantsRead = [];
            _groupList.groups![groupindex]!.chatList![i]!.readCount = 0;
          }
          if (_groupList.groups![groupindex]!.chatList![i]!.participantsRead!
              .contains(participantIndex)) {
          } else {
            _groupList.groups![groupindex]!.chatList![i]!.participantsRead!
                .add(participantIndex);
            _groupList.groups![groupindex]!.chatList![i]!.readCount++;
            print(
                "thos osdsdjfk counter ${_groupList.groups![groupindex]!.chatList![i]!.readCount}");
            print(
                "thos osdsdjfk counter ${_groupList.groups![groupindex]!.chatList![i]!.participantsRead}");
          }
        }
        _groupList.groups![groupindex]!.chatList![msgindex]!.status = status;
        notifyListeners();
       
      } else {
        print("i am in personal chat");
        var msgindex =
            _groupList.groups![groupindex]!.chatList!.indexWhere((element) {
          print("this is id ${json.decode(msg)["messageId"].toString()}");
          // print("participant index is $participantIndex");
          print("element is ${element!.id}");
          return element.id == json.decode(msg)["messageId"].toString();
        });
        print("this is msg index $msgindex");
        // print(
        //     "this is status ${_groupList.groups[groupindex].chatList[msgindex].status}");
        _groupList.groups![groupindex]!.chatList![msgindex]!.status = status;

        notifyListeners();
      }
    }
  }

  changeMsgStatusToDelivered(msg, status) {
    print("this is message to deliverd $msg");
    var groupindex = _groupList.groups!
        .indexWhere((element) => element!.channel_key == msg["key"]);

    // print("this is msg ${_groupList.groups[groupindex].chatList.length}");
    if (groupindex != 1) {
      var msgindex = _groupList.groups![groupindex]!.chatList!
          .indexWhere((element) => element!.id == msg["id"]);
      print("this is msg index $msgindex");

      _groupList.groups![groupindex]!.chatList![msgindex]!.status = status;

      notifyListeners();
    }
  }

  setCountZero(index) {
    print("yes this is back");
    _groupList.groups![index]!.counter = 0;
    _currentOpenedChat = _groupList.groups![index];
    notifyListeners();
  }

  handlBacktoGroupList(index) {
    _groupList.groups![index]!.counter = 0;
    _currentOpenedChat = null;
    notifyListeners();
  }

  updateTypingStatus(msg) {
    var index = _groupList.groups!.indexWhere((element) =>
        element!.channel_key == json.decode(msg)["key"].toString());

    var participantIndex = _groupList.groups![index]!.participants!.indexWhere(
        (element) => element!.ref_id == json.decode(msg)["from"].toString());

    if (index != -1) {
      if (_groupList.groups![index]!.participants!.length > 2) {
        //_typingUserDetail = [];
        if (_typingUserDetail.length <= 2) {
          if (_typingUserDetail.contains(_groupList
              .groups![index]!.participants![participantIndex]!.full_name)) {
            // _typingUserDetail = _typingUserDetail;
          } else {
            _typingUserDetail.add(_groupList
                .groups![index]!.participants![participantIndex]!.full_name);
          }
        }
        _groupList.groups![index]!.typingstatus = _typingUserDetail
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "");
        print("this is typing user detail before $_typingUserDetail");
        notifyListeners();
        Timer(Duration(seconds: 2), () {
          if (_currentOpenedChat != null) {
            print("after delay $index");

            _typingUserDetail.remove(_groupList
                .groups![index]!.participants![participantIndex]!.full_name);
            if (_typingUserDetail.isNotEmpty) {
              _groupList.groups![index]!.typingstatus = _typingUserDetail
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "");
            } else {
              _groupList.groups![index]!.typingstatus = "";
            }

            print("this is typing user detail afterrr $_typingUserDetail");
          } else {
            var index = _groupList.groups!.indexWhere((element) =>
                element!.channel_key == json.decode(msg)["key"].toString());

            _typingUserDetail.remove(_groupList
                .groups![index]!.participants![participantIndex]!.full_name);
            // _groupList.groups[index].typingstatus = "";
            if (_typingUserDetail.isNotEmpty) {
              _groupList.groups![index]!.typingstatus = _typingUserDetail
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "");
            } else {
              _groupList.groups![index]!.typingstatus = "";
            }
            print("this is typing user detail after  $_typingUserDetail");
          }
          notifyListeners();
        });
      } else {
        _groupList.groups![index]!.typingstatus = _groupList
            .groups![index]!.participants![participantIndex]!.full_name;
        notifyListeners();
        Timer(Duration(seconds: 2), () {
          if (_currentOpenedChat != null) {
            print("after delay $index");
            _groupList.groups![index]!.typingstatus = "";
          } else {
            var index = _groupList.groups!.indexWhere((element) =>
                element!.channel_key == json.decode(msg)["key"].toString());
            _groupList.groups![index]!.typingstatus = "";
          }
          notifyListeners();
        });
      }
    }
  }
  // void downloadFile(String url, fileName, extension) {
  //   html.AnchorElement anchorElement = html.AnchorElement(href: url);
  //   anchorElement.download =
  //       fileName.toString() + '.' + extension.toString(); //in my case is .pdf
  //   anchorElement.click();
  //   print("this is path ${anchorElement.baseUri}");
  //   print("this is path ${anchorElement.href.toString()}");
  // }
}
