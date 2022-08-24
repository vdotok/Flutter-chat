import 'dart:async';
import 'dart:convert';
// import 'package:universal_io/io.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/VideoApp.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/VideoScreenweb.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/sensoryDialogBox/SensoryDialogBox.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:path/path.dart' as p;
// import 'package:file_picker_web/file_picker_web.dart' as webPicker;
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';
import '../groupChatScreen/AddAttachmentsPopUp.dart';
import '../home/CustomAppBar.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';
import '../groupChatScreen/AudioWidget.dart';
import '../groupChatScreen/videoPlayer.dart';

class ChatScreen extends StatefulWidget {
  final int index;
  final publishMessage;
  final MainProvider? mainProvider;
  final ContactProvider? contactProvider;

  const ChatScreen(
      {Key? key,
      required this.index,
      this.publishMessage,
      this.mainProvider,
      this.contactProvider})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int get index => widget.index;
  late AuthProvider authProvider;
  late GroupListProvider _groupListProvider;
  late ScrollController secondcontroller;
  //AutoScrollController controller;
  ScrollController controller = ScrollController();
  final TextEditingController messageController = TextEditingController();
  Emitter emitter = Emitter.instance;
  final picker = ImagePicker();
  late Uint8List _fromChunks;
  bool scrollUp = false;
  var date = "";
  bool _isPlaying = false;
  var _completedPercentage = 0.0;
  var _totalDuration;
  var _currentDuration;
  late File image;
  // FlutterAudioRecorder _recorder;
  // Recording _current;
  // RecordingStatus _currentStatus = RecordingStatus.Unset;
  // MicrophoneRecorder microphoneRecorder;
  // final textController = TextEditingController();
  String? urlofVideo;

  @override
  void initState() {
    super.initState();
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    controller.addListener(() {});

    // _init();
    //  microphoneRecorder = MicrophoneRecorder()..init();
  }

  @override
  void dispose() {
    super.dispose();
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

  Future getAudio(String src) async {
    var pickedFile;
    //    if(src=="Audio")
    // //   pickedFile= await
    //    if(src=="Audio Recording")
  }

  getSensoryData(String type) {}

//   _init() async {
//     try {
//       if (await FlutterAudioRecorder.hasPermissions) {
//         String customPath = '/flutter_audio_recorder_';
//         Directory appDocDirectory;
// //        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
//         if (Platform.isIOS) {
//           appDocDirectory = await getApplicationDocumentsDirectory();
//         } else {
//           appDocDirectory = await getExternalStorageDirectory();
//         }

//         // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//         customPath = appDocDirectory.path +
//             customPath +
//             DateTime.now().millisecondsSinceEpoch.toString();

//         // .wav <---> AudioFormat.WAV
//         // .mp4 .m4a .aac <---> AudioFormat.AAC
//         // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//         _recorder =
//             FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

//         await _recorder.initialized;
//         // after initialization
//         var current = await _recorder.current(channel: 0);
//         print(current);
//         // should be "Initialized", if all working fine
//         setState(() {
//           _current = current;
//           _currentStatus = current.status;
//           print(_currentStatus);
//         });
//       } else {
//         Scaffold.of(context).showSnackBar(
//             new SnackBar(content: new Text("You must accept permissions")));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

  _start() async {
    // microphoneRecorder.start();
    // try {
    //   await _recorder.start();
    //   var recording = await _recorder.current(channel: 0);
    //   setState(() {
    //     _current = recording;
    //   });

    //   const tick = const Duration(milliseconds: 50);
    //   new Timer.periodic(tick, (Timer t) async {
    //     if (_currentStatus == RecordingStatus.Stopped) {
    //       t.cancel();
    //     }

    //     var current = await _recorder.current(channel: 0);
    //     print("this is current ${current.path}");
    //     setState(() {
    //       _current = current;
    //       _currentStatus = _current.status;
    //     });
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

//   _stop() async {

//     await microphoneRecorder.stop();
//   Uint8List bytes = await microphoneRecorder.toBytes();
//   final recordingUrl = microphoneRecorder.value.recording.url;
//     // Recording result = await _recorder.stop();
//     // File file = widget.localFileSystem.file(result.path);
//     // print("File length: ${await file.length()}");
// File file=  File(recordingUrl);
// // Uint8List bytes = await file.readAsBytes();
//     Map<String, dynamic> filePacket = {
//       "id": generateMd5(_groupListProvider.groupList.groups[index].channel_key),
//       "topic": _groupListProvider.groupList.groups[index].channel_name,
//       "to": _groupListProvider.groupList.groups[index].channel_name,
//       "key": _groupListProvider.groupList.groups[index].channel_key,
//       "from": authProvider.getUser.full_name,
//       "type": MediaType.audio,
//       "content": base64.encode(bytes),
//       "fileExtension": p.extension(recordingUrl),
//       "isGroupMessage": false,
//       "size": 0,
//       "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
//       "status": ReceiptType.sent,
//     };
//     // _groupListProvider.sendMsg(index, filePacket);
//     widget.publishMessage(
//         _groupListProvider.groupList.groups[index].channel_key,
//         _groupListProvider.groupList.groups[index].channel_name,
//         filePacket);
//     filePacket["content"] = kIsWeb ? recordingUrl : file;
//     _groupListProvider.sendMsg(index, filePacket);
//     // setState(() {
//     //   _current = file;
//     //   _currentStatus = _current.status;
//     // });
//   }

  Future getImage(String src) async {
    print('yes im here');
    PickedFile? pickedFile;
    try {
      if (src == "Gallery") {
        pickedFile = (await picker.getImage(source: ImageSource.gallery))!;
        // pickedFile = await picker.getVideo(source: ImageSource.gallery);
        // Navigator.pop(context);
      }
      if (src == "Camera") {
        pickedFile = (await picker.getImage(source: ImageSource.camera))!;
        // Navigator.pop(context);
      }
      print('Image pickedd${pickedFile!.readAsBytes()}');
      // ignore: unnecessary_null_comparison
      if (pickedFile != null) {
        // if (kIsWeb) {
        //   try {
        //     Uint8List? uploadfile = await pickedFile.readAsBytes();
        //     print('${uploadfile.length}');
        //     print('this is uploadinfh${uploadfile}');
        //     print('this is extension${uploadfile}');
        //     print('pickedFileeee${pickedFile.path}');
        //     if (uploadfile.length > 6000000) {
        //       buildShowDialog(context, "Error Message",
        //           "File size should be less than 6 MB!!");
        //       return;
        //     }
        //     print('path of picked file${pickedFile.path}');
        //     Map<String, dynamic> filePacket = {
        //       "id": generateMd5(
        //           _groupListProvider.groupList.groups![index]!.channel_key),
        //       // "topic": _groupListProvider.groupList.groups[index].channel_name,
        //       "to": _groupListProvider.groupList.groups![index]!.channel_name,
        //       "key": _groupListProvider.groupList.groups![index]!.channel_key,
        //       "from": authProvider.getUser!.ref_id,
        //       "type": MediaType.image,
        //       "content": base64.encode(uploadfile),
        //       "fileExtension": (pickedFile.path.split('/').last),
        //       "isGroupMessage": false,
        //       "size": 0,
        //       "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
        //       "status": ReceiptType.sent,
        //     };
        //     widget.publishMessage(
        //         _groupListProvider.groupList.groups![index]!.channel_key,
        //         _groupListProvider.groupList.groups![index]!.channel_name,
        //         filePacket);
        //     filePacket["content"] =
        //         kIsWeb ? pickedFile.path : File(pickedFile.path);
        //     print('functionFinisheddddddddd');
        //     // image = pickedFile.openRead()
        //     // var bytes = await ImagePicker.pickImage(source: ImageSource.gallery).readAsBytes();
        //     //  uploadfile = pickedFile.readAsBytes();
        //     // print('imagePicked222 ${uploadfile}');
        //   } catch (e) {
        //     print('this is error with kISWeb$e');
        //   }
        // } else {
        image = File(pickedFile.path);

        Uint8List bytes = await pickedFile.readAsBytes();
        print("bytes are $bytes");
        if (bytes.length > 6000000) {
          buildShowDialog(
              context, "Error Message", "File size should be less than 6 MB!!");
          return;
        }
        Map<String, dynamic> filePacket = {
          "id": generateMd5(
              _groupListProvider.groupList.groups![index]!.channel_key),
          // "topic": _groupListProvider.groupList.groups[index].channel_name,
          "to": _groupListProvider.groupList.groups![index]!.channel_name,
          "key": _groupListProvider.groupList.groups![index]!.channel_key,
          "from": authProvider.getUser!.ref_id,
          "type": MediaType.image,
          "content": base64.encode(bytes),
          "fileExtension": (pickedFile.path.split('.').last),
          "isGroupMessage": false,
          "size": 0,
          "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
          "status": ReceiptType.sent,
        };
        widget.publishMessage(
            _groupListProvider.groupList.groups![index]!.channel_key,
            _groupListProvider.groupList.groups![index]!.channel_name,
            filePacket);
        filePacket["content"] =
            kIsWeb ? pickedFile.path : File(pickedFile.path);
        _groupListProvider.sendMsg(index, filePacket);
        // }
      } else {
        print('No image selected.');
      }
    } catch (error) {
      print("this is error in image picker $error");
    }
  }

  filePIcker(String fileType) async {
    FilePickerResult? result;
    if (fileType == "file")
      result = (await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any))!;
    else if (fileType == "ImageAndVideo")
      result = (await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.media))!;
    else
      result = (await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.audio))!;
    List<String> videoExtensions = [
      "webm",
      "mkv",
      "flv",
      "vob",
      "ogv",
      "ogg",
      "rrc",
      "gifv",
      "mng",
      "mov",
      "avi",
      "qt",
      "wmv",
      "yuv",
      "rm",
      "asf",
      "amv",
      "mp4",
      "m4p",
      "m4v",
      "mpg",
      "mp2",
      "mpeg",
      "mpe",
      "mpv",
      "m4v",
      "svi",
      "3gp",
      "3g2",
      "mxf",
      "roq",
      "nsv",
      "flv",
      "f4v",
      "f4p",
      "f4a",
      "f4b]",
    ];
    bool isVideo = videoExtensions.contains(result.files.single.extension);

    List<String> audioExtensions = [
      "aac",
      "aiff",
      "ape",
      "au",
      "flac",
      "gsm",
      "it",
      "m3u",
      "m4a",
      "mid",
      "mod",
      "mp3",
      "mpa",
      "pls",
      "ra",
      "s3m",
      "sid",
      "wav",
      "wma",
      "xm"
    ];
    bool isAudio = audioExtensions.contains(result.files.single.extension);

    List<String> imageExtensions = [
      "3dm",
      "3ds",
      "max",
      "bmp",
      "dds",
      "gif",
      "jpg",
      "jpeg",
      "png",
      "psd",
      "xcf",
      "tga",
      "thm",
      "tif",
      "tiff",
      "yuv",
      "ai",
      "eps",
      "ps",
      "svg",
      "dwg",
      "dxf",
      "gpx",
      "kml",
      "kmz",
      "webp"
    ];

    bool isImage = imageExtensions.contains(result.files.single.extension);
    var type;

    if (isVideo == true) {
      type = MediaType.video;
    } else if (isAudio == true) {
      type = MediaType.audio;
    } else if (isImage == true) {
      type = MediaType.image;
    } else {
      type = MediaType.file;
    }
    print("this is type $type");
    if (result != null) {
      if (kIsWeb) {
        try {
          Uint8List? uploadfile = result.files.single.bytes;
          print('upload files bytes${uploadfile}');
          if (uploadfile!.length > 6000000) {
            buildShowDialog(context, "Error Message",
                "File size should be less than 6 MB!!");
            return;
          }
          print("this is file ${(result.files.single.name)}");
          Map<String, dynamic> filePacket = {
            "id": generateMd5(
                _groupListProvider.groupList.groups![index]!.channel_key),
            // "topic": _groupListProvider.groupList.groups[index].channel_name,
            "to": _groupListProvider.groupList.groups![index]!.channel_name,
            "key": _groupListProvider.groupList.groups![index]!.channel_key,
            "from": authProvider.getUser!.ref_id,
            "type": type,
            "content": base64.encode(uploadfile),
            "fileName": result.files.single.name.toString(),
            "fileExtension":
                (result.files.single.name.toString().split('.').last),
            // p.extension(file.path.lastIndexOf('.')).substring(1)),
            "isGroupMessage": false,
            "size": 0,
            "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
            "status": ReceiptType.sent,
            "subtype": type
          };
          // print('path before publishing${result.files.single.path}');
          widget.publishMessage(
              _groupListProvider.groupList.groups![index]!.channel_key,
              _groupListProvider.groupList.groups![index]!.channel_name,
              filePacket);
          var abc = base64Encode(uploadfile);
          print('abcdeeffff$abc');
          filePacket["content"] = kIsWeb ? abc : null;
          filePacket["fileExtension"] =
              kIsWeb ? result.files.single.name.toString() : null;
          print('filepacket jebfjdb${filePacket} $index');
          _groupListProvider.sendMsg(index, filePacket);
          //  Navigator.pop(context);
        } catch (e) {
          print('$e');
        }
      } else {
        File file = File(result.files.first.path!);
        print('path of file${file.path}');
        Uint8List bytes = await file.readAsBytes();
        print("bytes length ${bytes.length}");
        if (bytes.length > 6000000) {
          buildShowDialog(
              context, "Error Message", "File size should be less than 6 MB!!");
          return;
        }
        print("this is file ${(file.path.split('.').last)}");
        print("this bytess${bytes}");
        Map<String, dynamic> filePacket = {
          "id": generateMd5(
              _groupListProvider.groupList.groups![index]!.channel_key),
          // "topic": _groupListProvider.groupList.groups[index].channel_name,
          "to": _groupListProvider.groupList.groups![index]!.channel_name,
          "key": _groupListProvider.groupList.groups![index]!.channel_key,
          "from": authProvider.getUser!.ref_id,
          "type": type,
          "content": base64.encode(bytes),
          "fileExtension": (file.path.split('.').last),
          // p.extension(file.path.lastIndexOf('.')).substring(1)),
          "isGroupMessage": false,
          "size": 0,
          "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
          "status": ReceiptType.sent,
          "subtype": type
        };
        // fileee.writeAsBytesSync(bytes);
        // _groupListProvider.sendMsg(index, filePacket);
        widget.publishMessage(
            _groupListProvider.groupList.groups![index]!.channel_key,
            _groupListProvider.groupList.groups![index]!.channel_name,
            filePacket);
        filePacket["content"] = kIsWeb ? null : file;
        _groupListProvider.sendMsg(index, filePacket);
      }
    } else {
      print("null value apear");
      // User canceled the picker
    }
  }

  List<Uint8List> byteToPortions(Uint8List largeByteArray) {
    // create a list to keep the portions
    List<Uint8List> byteArrayPortions = [];

    // 12kb is about 12288 bytes
    int sizePerPortion = 12288;
    int offset = 0;
    for (int i = 0; i <= (largeByteArray.length / sizePerPortion); i++) {
      int end = sizePerPortion * (i + 1);
      if (end >= largeByteArray.length) {
        end = largeByteArray.length;
      }
      Uint8List portion = largeByteArray.sublist(offset, end);
      offset = end;
      byteArrayPortions.add(portion);
    }
    return byteArrayPortions;
  }

  generateMd5(String groupkey) {
    var input = DateTime.now().millisecondsSinceEpoch.toString() + groupkey;
    var content = crypto.md5.convert(utf8.encode(input)).toString();
    print("the input value in MD5 format: $content");
    return content;
  }

  Future<bool> _onWillPop() async {
    if (strArr.last == "ChatScreen") {
      print(
          "this is mainprovider back button press in chat screen ${widget.mainProvider}");
      widget.mainProvider!.homeScreen();
      strArr.remove("ChatScreen");
    }
    _groupListProvider.handlBacktoGroupList(index);
    // Navigator.pop(context);
    // Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    Timer(
        Duration(milliseconds: 5),
        () => kIsWeb
            ? controller.hasClients
                ? controller.jumpTo(controller.position.maxScrollExtent)
                : controller.hasClients
                    ? controller.jumpTo(controller.position.maxScrollExtent)
                    //  }
                    : null
            : null);

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer<GroupListProvider>(
            builder: (context, groupListProvider, child) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFous = FocusScope.of(context);
              if (!currentFous.hasPrimaryFocus) {
                currentFous.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: backgroundChatColor,
              appBar: CustomAppBar(
                  groupListProvider: groupListProvider,
                  lead: true,
                  ischatscreen: true,
                  title: "",
                  index: index,
                  mainProvider: widget.mainProvider,
                  authProvider: authProvider),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: Scrollbar(
                            child: groupListProvider
                                        .groupList.groups![index]!.chatList ==
                                    null
                                ? Text("")
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    //reverse: true,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: controller,
                                    itemCount: groupListProvider.groupList
                                        .groups![index]!.chatList!.length,
                                    itemBuilder: (context, chatindex) {
                                      if (groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .type !=
                                              MessageType.text ||
                                          groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .status ==
                                              ReceiptType.delivered) {
                                        // date = DateFormat().add_jm().format(
                                        //     DateTime.fromMillisecondsSinceEpoch(
                                        //         groupListProvider
                                        //                 .groupList
                                        //                 .groups[index]
                                        //                 .chatList[chatindex]
                                        //                 .date *
                                        //             100));
                                      }
                                      //  Timer(
                                      //               Duration(
                                      //                   milliseconds: 1000),
                                      //               () => controller
                                      //                   .jumpTo(controller
                                      //                       .position
                                      //                       .maxScrollExtent+200));

                                      return Column(
                                        children: [
                                          groupListProvider
                                                      .groupList
                                                      .groups![index]!
                                                      .chatList![chatindex]!
                                                      .from !=
                                                  authProvider.getUser!.ref_id
                                              ? receiverText(groupListProvider,
                                                  chatindex, date.toString())
                                              : senderText(groupListProvider,
                                                  chatindex, date.toString())
                                        ],
                                      );
                                    }))),
                    SizedBox(
                      height: 8,
                    ),
                    buildAlign(groupListProvider)
                  ],
                ),
              ),
            ),
          );
        }));
  }

  //Sender Text Widget//
  Column receiverText(
      GroupListProvider groupListProvider, int chatindex, String date) {
    var participantIndex = groupListProvider
        .groupList.groups![index]!.participants!
        .indexWhere((element) =>
            element!.ref_id ==
            groupListProvider
                .groupList.groups![index]!.chatList![chatindex]!.from);
    print("chat index is $chatindex");
    var content = groupListProvider
        .groupList.groups![index]!.chatList![chatindex]!.content;
    //.toString().codeUnits;
    // var decode = utf8.decode(content.toString().codeUnits);
    // print("Decode is $decode");
    print(
        "this is content of receiving mesgs${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content}");
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, top: 28),
                    child: Text(
                        // "pata nahi",
                        "${groupListProvider.groupList.groups![index]!.participants![participantIndex]!.full_name} ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: receiverMessagecolor, fontSize: 14))),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 5, right: 26, left: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // color: groupListProvider
                                  //             .groupList
                                  //             .groups[index]
                                  //             .chatList[chatindex]
                                  //             .type ==
                                  //         MediaType.image
                                  //     ? Colors.white
                                  //     : receiverMessagecolor,
                                ),
                                //The Text Inside Receiver Container//
                                child: groupListProvider
                                            .groupList
                                            .groups![index]!
                                            .chatList![chatindex]!
                                            .type ==
                                        MessageType.text
                                    ?
                                    //If we have type not equal to 0 then we have to show the content inside the message
                                    Container(
                                        decoration: BoxDecoration(
                                          color: receiverMessagecolor,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        // color: receiverMessagecolor,
                                        child: Text(
                                          "${content.toString()}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    :
                                    //If its an image then we will check if its on web or mobile device
                                    groupListProvider.groupList.groups![index]!
                                                .chatList![chatindex]!.type ==
                                            MediaType.image
                                        ? kIsWeb
                                            ? Container(
                                                width: 200,
                                                child:
                                                    // Column(
                                                    //   children: [
                                                    //     IconButton(
                                                    //       onPressed: () {
                                                    // anchorElement.click();
                                                    // groupListProvider.downloadFile(
                                                    //     urlGenerated
                                                    //         .toString(),
                                                    //     groupListProvider
                                                    //         .groupList
                                                    //         .groups![index]!
                                                    //         .chatList![
                                                    //             chatindex]!
                                                    //         .fileName,
                                                    //     groupListProvider
                                                    //         .groupList
                                                    //         .groups![index]!
                                                    //         .chatList![
                                                    //             chatindex]!
                                                    //         .fileExtension);
                                                    //   },
                                                    //   icon: Icon(Icons
                                                    //       .file_download_outlined),
                                                    // ),
                                                    kIsWeb
                                                        ? Image.memory(
                                                            groupListProvider
                                                                .groupList
                                                                .groups![index]!
                                                                .chatList![
                                                                    chatindex]!
                                                                .content,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.file(
                                                            groupListProvider
                                                                .groupList
                                                                .groups![index]!
                                                                .chatList![
                                                                    chatindex]!
                                                                .content,
                                                            fit: BoxFit.fill,
                                                          ),
                                                //   ],
                                                // )
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(8),
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  color:
                                                      searchbarContainerColor,
                                                  //       //searchbarContainerColor,
                                                  // border: Border.all(
                                                  //  // color: Colors.white,
                                                  //  // color:Colors.red
                                                  //       //searchbarContainerColor,
                                                  //   // width: 15,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: kIsWeb
                                                      ? Image.memory(
                                                          groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .chatList![
                                                                  chatindex]!
                                                              .content,
                                                        )
                                                      : Image.file(
                                                          groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .chatList![
                                                                  chatindex]!
                                                              .content,
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              )
                                        : groupListProvider
                                                    .groupList
                                                    .groups![index]!
                                                    .chatList![chatindex]!
                                                    .type ==
                                                MediaType.audio
                                            ? kIsWeb
                                                ?
                                                //for audio
                                                AudioWidget(
                                                    groupListProvider:
                                                        groupListProvider,
                                                    chatindex: chatindex,
                                                    index: index,
                                                    file1: File('dummy.txt'),
                                                    file: groupListProvider
                                                        .groupList
                                                        .groups![index]!
                                                        .chatList![chatindex]!
                                                        .content,
                                                    isReceive: true,
                                                  )
                                                : AudioWidget(
                                                    groupListProvider:
                                                        groupListProvider,
                                                    chatindex: chatindex,
                                                    index: index,
                                                    file: "",
                                                    file1: groupListProvider
                                                        .groupList
                                                        .groups![index]!
                                                        .chatList![chatindex]!
                                                        .content,
                                                    isReceive: true,
                                                  )
                                            // Text('fdgsdhg')
                                            : groupListProvider
                                                        .groupList
                                                        .groups![index]!
                                                        .chatList![chatindex]!
                                                        .type ==
                                                    MediaType.video
                                                ?
                                                //for video
                                                InkWell(
                                                    onTap: () {
                                                      print(
                                                          "i am opening file1");
                                                      kIsWeb
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          VideoScreen(
                                                                            text:
                                                                                groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content.toString(),
                                                                          )))
                                                          : OpenFile.open(
                                                              groupListProvider
                                                                  .groupList
                                                                  .groups![
                                                                      index]!
                                                                  .chatList![
                                                                      chatindex]!
                                                                  .content
                                                                  .path,
                                                            );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            receiverMessagecolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
                                                          left: 15,
                                                          right: 20),
                                                      // width: 250,
                                                      child: kIsWeb
                                                          ? Text(
                                                              groupListProvider
                                                                  .groupList
                                                                  .groups![
                                                                      index]!
                                                                  .chatList![
                                                                      chatindex]!
                                                                  .fileExtension,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                          : Text(
                                                              groupListProvider
                                                                  .groupList
                                                                  .groups![
                                                                      index]!
                                                                  .chatList![
                                                                      chatindex]!
                                                                  .content
                                                                  .path
                                                                  .toString()
                                                                  .split("/")
                                                                  .last,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                    ),
                                                  )
                                                :
                                                //for file
                                                InkWell(
                                                    onTap: () {
                                                      print(
                                                          "i am opening file2");
                                                      OpenFile.open(
                                                        groupListProvider
                                                            .groupList
                                                            .groups![index]!
                                                            .chatList![
                                                                chatindex]!
                                                            .content
                                                            .path,
                                                      );

                                                      //  Navigator.of(context).push(
                                                      //   new MaterialPageRoute<Null>(
                                                      //       builder:
                                                      //           (BuildContext context) {
                                                      //         return DocumentViewer(
                                                      //           file: groupListProvider
                                                      //               .groupList
                                                      //               .groups[index]
                                                      //               .chatList[chatindex]
                                                      //               .content
                                                      //         );
                                                      //       },
                                                      //       fullscreenDialog: true));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            receiverMessagecolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
                                                          left: 15,
                                                          right: 20),
                                                      child: Row(
                                                        children: [
                                                          kIsWeb
                                                              ? Text(
                                                                  groupListProvider
                                                                      .groupList
                                                                      .groups![
                                                                          index]!
                                                                      .chatList![
                                                                          chatindex]!
                                                                      .content
                                                                      .toString()
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    // color:
                                                                    //     sendMessageColoer,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  groupListProvider
                                                                      .groupList
                                                                      .groups![
                                                                          index]!
                                                                      .chatList![
                                                                          chatindex]!
                                                                      .content
                                                                      .toString()
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    // color:
                                                                    //     sendMessageColoer,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              // groupListProvider.downloadFile(
                                                              //     urlGenerated
                                                              //         .toString(),
                                                              //     groupListProvider
                                                              //         .groupList
                                                              //         .groups![
                                                              //             index]!
                                                              //         .chatList![
                                                              //             chatindex]!
                                                              //         .fileName,
                                                              //     groupListProvider
                                                              //         .groupList
                                                              //         .groups![
                                                              //             index]!
                                                              //         .chatList![
                                                              //             chatindex]!
                                                              //         .fileExtension);
                                                            },
                                                            icon: Icon(Icons
                                                                .file_download_outlined),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                              ),
                            ),
                            Container(
                                // margin: EdgeInsets.only(top: 25, left: 10),
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  DateFormat().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          groupListProvider
                                              .groupList
                                              .groups![index]!
                                              .chatList![chatindex]!
                                              .date)),
                                  style: TextStyle(
                                    color: messageTimeColor,
                                    fontSize: 12,
                                  ),
                                ))
                          ],
                        )),
                  )
                ]),
              ])
        ]);
  }

  //Sender Text Widget//
  Row senderText(
      GroupListProvider groupListProvider, int chatindex, String date) {
    //  var participantIndex = groupListProvider
    // .groupList.groups[index].participants
    // .indexWhere((element) =>
    //     element.ref_id ==
    //     groupListProvider.groupList.groups[index].chatList[chatindex].from);
    print("this is chat indexxx $chatindex");
    print(
        'chat available ${groupListProvider.groupList.groups![index]!.chatList!.length}');
    // if (groupListProvider.groupList.groups[index].chatList.length == 0) {
    //   groupListProvider.readmodelList = [];
    // }
    // if(groupListProvider.groupList.groups[]==0)
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Flexible(
        child: Container(
          margin: EdgeInsets.only(top: 24, right: 26, left: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                groupListProvider.groupList.groups![index]!
                            .chatList![chatindex]!.from !=
                        authProvider.getUser!.ref_id
                    ? Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: messageTimeColor,
                          fontSize: 14,
                        ),
                      )
                    : groupListProvider.groupList.groups![index]!
                                .chatList![chatindex]!.status ==
                            ReceiptType.sent
                        ? Text("")
                        : groupListProvider.groupList.groups![index]!
                                    .chatList![chatindex]!.status ==
                                ReceiptType.delivered
                            ? Text("")
                            : (groupListProvider.groupList.groups![index]!
                                        .participants!.length >
                                    2)
                                ? Text(
                                    "Read ${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.readCount}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: messageTimeColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : Text(
                                    "Read",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: messageTimeColor,
                                      fontSize: 12,
                                    ),
                                  ),
                Container(
                    margin: EdgeInsets.only(top: 25, left: 10),
                    child: Text(
                      DateFormat().add_jm().format(
                          DateTime.fromMillisecondsSinceEpoch(groupListProvider
                              .groupList
                              .groups![index]!
                              .chatList![chatindex]!
                              .date)),
                      style: TextStyle(
                        color: messageTimeColor,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
            SizedBox(width: 16),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: searchbarContainerColor,
                ),
                child: groupListProvider.groupList.groups![index]!
                            .chatList![chatindex]!.type ==
                        MessageType.text
                    ?
                    //for text
                    Container(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 20, right: 20),
                        child: Text(
                          "${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: sendMessageColoer,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : groupListProvider.groupList.groups![index]!
                                .chatList![chatindex]!.type ==
                            MediaType.image
                        ?
                        //for image
                        kIsWeb
                            ? Container(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 20, right: 20),
                                color: messageTimeColor,
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: kIsWeb
                                      ? Image.memory(
                                          groupListProvider
                                              .groupList
                                              .groups![index]!
                                              .chatList![chatindex]!
                                              .content,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          groupListProvider
                                              .groupList
                                              .groups![index]!
                                              .chatList![chatindex]!
                                              .content,
                                          fit: BoxFit.fill,
                                        ),
                                ))
                            : InkWell(
                                onTap: () {
                                  print("i am opening file3");
                                  OpenFile.open(
                                    groupListProvider.groupList.groups![index]!
                                        .chatList![chatindex]!.content.path,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  // color: messageTimeColor,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: searchbarContainerColor,
                                      // width: 15,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child:
                                        // Column(
                                        //   children: [
                                        // IconButton(
                                        //   onPressed: () {
                                        //     // anchorElement.click();
                                        //     // groupListProvider.downloadFile(
                                        //     //     urlGenerated
                                        //     //         .toString(),
                                        //     //     groupListProvider
                                        //     //         .groupList
                                        //     //         .groups![index]!
                                        //     //         .chatList![
                                        //     //             chatindex]!
                                        //     //         .fileName,
                                        //     //     groupListProvider
                                        //     //         .groupList
                                        //     //         .groups![index]!
                                        //     //         .chatList![
                                        //     //             chatindex]!
                                        //     //         .fileExtension);
                                        //   },
                                        //   icon: Icon(
                                        //       Icons.file_download_outlined),
                                        // ),
                                        kIsWeb
                                            ? Image.memory(
                                                groupListProvider
                                                    .groupList
                                                    .groups![index]!
                                                    .chatList![chatindex]!
                                                    .content,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                groupListProvider
                                                    .groupList
                                                    .groups![index]!
                                                    .chatList![chatindex]!
                                                    .content,
                                                fit: BoxFit.fill,
                                              ),
                                    //   ],
                                    // ),
                                  ),
                                ),
                              )
                        : groupListProvider.groupList.groups![index]!
                                    .chatList![chatindex]!.type ==
                                MediaType.audio
                            ?
                            //for audio
                            kIsWeb
                                ?
                                // ? AudioWidget(groupListProvider: groupListProvider, chatindex: chatindex, index: index, file1:, file: file, isReceive: isReceive)
                                AudioWidget(
                                    groupListProvider: groupListProvider,
                                    chatindex: chatindex,
                                    index: index,
                                    file1: File('dummy.txt'),
                                    file: groupListProvider
                                        .groupList
                                        .groups![index]!
                                        .chatList![chatindex]!
                                        .content,
                                    isReceive: false,
                                  )
                                : AudioWidget(
                                    groupListProvider: groupListProvider,
                                    chatindex: chatindex,
                                    index: index,
                                    file: "",
                                    file1: groupListProvider
                                        .groupList
                                        .groups![index]!
                                        .chatList![chatindex]!
                                        .content,
                                    isReceive: false,
                                  )
                            : groupListProvider.groupList.groups![index]!
                                        .chatList![chatindex]!.type ==
                                    MediaType.video
                                ?
                                //for video
                                // Container()
                                InkWell(
                                    onTap: () {
                                      print("i am opening file4");
                                      kIsWeb
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoScreen(
                                                        text: groupListProvider
                                                            .groupList
                                                            .groups![index]!
                                                            .chatList![
                                                                chatindex]!
                                                            .content
                                                            .toString(),
                                                      )))
                                          : OpenFile.open(groupListProvider
                                              .groupList
                                              .groups![index]!
                                              .chatList![chatindex]!
                                              .content
                                              .path);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                          left: 20,
                                          right: 20),
                                      child: kIsWeb
                                          ? Text(
                                              groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .fileExtension,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: sendMessageColoer,
                                                fontSize: 14,
                                              ),
                                            )
                                          : Text(
                                              groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .content
                                                  .path
                                                  .toString()
                                                  .split("/")
                                                  .last,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: sendMessageColoer,
                                                fontSize: 14,
                                              ),
                                            ),
                                    ))
                                :
                                //for file
                                InkWell(
                                    onTap: () {
                                      print("i am opening file5");

                                      OpenFile.open(
                                        groupListProvider
                                            .groupList
                                            .groups![index]!
                                            .chatList![chatindex]!
                                            .content
                                            .path,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                          left: 20,
                                          right: 20),
                                      child: kIsWeb
                                          ? Text(
                                              groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .fileExtension,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: sendMessageColoer,
                                                fontSize: 14,
                                              ),
                                            )
                                          : Text(
                                              groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .content
                                                  .path
                                                  .toString()
                                                  .split("/")
                                                  .last,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: sendMessageColoer,
                                                fontSize: 14,
                                              ),
                                            ),
                                    ),
                                  ),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }

  Container audioWidget(GroupListProvider groupListProvider, int chatindex) {
    Future<void> _onPlay({required String filePath, required int index}) async {
      AudioPlayer audioPlayer = AudioPlayer();
      if (!_isPlaying) {
        audioPlayer.play(filePath, isLocal: true);
        setState(() {
          // _selectedIndex = index;
          _completedPercentage = 0.0;
          _isPlaying = true;
        });

        audioPlayer.onPlayerCompletion.listen((_) {
          setState(() {
            _isPlaying = false;
            _completedPercentage = 0.0;
          });
        });
        audioPlayer.onDurationChanged.listen((duration) {
          setState(() {
            _totalDuration = duration.inMicroseconds;
          });
        });

        audioPlayer.onAudioPositionChanged.listen((duration) {
          setState(() {
            _currentDuration = duration.inMicroseconds;
            _completedPercentage =
                _currentDuration.toDouble() / _totalDuration.toDouble();
          });
        });
      }
    }

    return Container(
      // height: 50,
      // width: 224,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: searchbarContainerColor,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _onPlay(
                  filePath: groupListProvider.groupList.groups![index]!
                      .chatList![chatindex]!.content.path,
                  index: 0);
            },
            icon: _isPlaying
                ? Icon(
                    Icons.pause,
                    color: receiverMessagecolor,
                  )
                : Icon(Icons.play_arrow, color: receiverMessagecolor),
            //  onPressed: () => _onPlay(
            //  filePath: record, index: 0),
          ),
          SizedBox(
            width: 125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: typeMessageColor,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  value: _completedPercentage,
                  // value:_completedPercentage,
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "0.37",
                style: TextStyle(
                  color: receiverMessagecolor,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  //bottom Text Box//
  Align buildAlign(GroupListProvider groupListProvider) {
    Timer(
        Duration(milliseconds: 5),
        () => kIsWeb
            ? controller.hasClients
                ? controller.jumpTo(controller.position.maxScrollExtent)
                : controller.hasClients
                    ? controller.jumpTo(controller.position.maxScrollExtent)
                    //  }
                    : null
            : null);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              color: messageBoxColor,
              height: 46,
              child: Row(
                children: [
                  Container(
                    color: messageBoxColor,
                    padding: EdgeInsets.only(left: 18),
                    //width:14,
                    child: IconButton(
                      icon: SvgPicture.asset('assets/Mic.svg'),
                      onPressed: _start,
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: messageController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Type your message",
                        contentPadding: EdgeInsets.only(bottom: 4, right: 28),
                        hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: typeMessageColor,
                            fontFamily: secondaryFontFamily),
                      ),
                      onChanged: (value) {
                        // print("this is date ${((DateTime.now()).millisecondsSinceEpoch).round()}");

                        var send_message = {
                          "id": generateMd5(groupListProvider
                              .groupList.groups![index]!.channel_key),
                          "to": groupListProvider
                              .groupList.groups![index]!.channel_name,
                          "key": groupListProvider
                              .groupList.groups![index]!.channel_key,
                          "from": authProvider.getUser!.ref_id,
                          "type": MessageType.typing,
                          "content": "1",
                          "size": 0,
                          "isGroupMessage": false,
                          "date":
                              ((DateTime.now()).millisecondsSinceEpoch).round(),
                          "status": ReceiptType.sent,
                        };
                        widget.publishMessage(
                            groupListProvider
                                .groupList.groups![index]!.channel_key,
                            groupListProvider
                                .groupList.groups![index]!.channel_name,
                            send_message);

                        Timer(Duration(seconds: 6), () {
                          var send_message = {
                            "id": generateMd5(groupListProvider
                                .groupList.groups![index]!.channel_key),
                            "to": groupListProvider
                                .groupList.groups![index]!.channel_name,
                            "key": groupListProvider
                                .groupList.groups![index]!.channel_key,
                            "from": authProvider.getUser!.ref_id,
                            //"type": MessageType.text,
                            "content": "0",
                            "size": 0,
                            "isGroupMessage": false,
                            "date": ((DateTime.now()).millisecondsSinceEpoch)
                                .round(),
                            "status": ReceiptType.sent,
                          };

                          widget.publishMessage(
                              groupListProvider
                                  .groupList.groups![index]!.channel_key,
                              groupListProvider
                                  .groupList.groups![index]!.channel_name,
                              send_message);
                        });
                      },
                    ),
                  ),
                  //   ),
                ],
              )),
          Container(
              height: 45,
              color: messageBoxColor,
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        padding: EdgeInsets.only(left: 16),
                        child: IconButton(
                          icon: Material(
                              child: SvgPicture.asset('assets/imagepic.svg')),
                          onPressed: () async {
                            if (kIsWeb == true) {
                              filePIcker('file');
                            } else {
                              getImage("Gallery");
                            }
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Material(
                              child: SvgPicture.asset('assets/AddCircle.svg')),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AddAttachmentPopUp(
                                      getImage: getImage,
                                      filePIcker: filePIcker,
                                    );
                                  });
                                });
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Material(
                              child: SvgPicture.asset('assets/AddCircle.svg')),
                          onPressed: () {
                            sensoryDialogBox(context, getSensoryData);
                          },
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(right: 14),
                      child: IconButton(
                        icon: Material(
                            child: SvgPicture.asset('assets/sendmsg.svg')),
                        onPressed: () {
// coffee.code;
                          var send_message = {
                            "from": authProvider.getUser!.ref_id,
                            "content": messageController.text,
                            "id": generateMd5(groupListProvider
                                .groupList.groups![index]!.channel_key),
                            "key": groupListProvider
                                .groupList.groups![index]!.channel_key,
                            "type": MessageType.text,
                            "to": groupListProvider
                                .groupList.groups![index]!.channel_name,
                            "isGroupMessage": false,
                            "date": ((DateTime.now()).millisecondsSinceEpoch)
                                .round(),
                            "status": ReceiptType.sent,
                            "size": 0.0
                          };

                          if (messageController.text.isNotEmpty &&
                              messageController.text.trim().length != 0) {
                            print("This is group chat publish: dsjfjds");
                            widget.publishMessage(
                                groupListProvider
                                    .groupList.groups![index]!.channel_key,
                                groupListProvider
                                    .groupList.groups![index]!.channel_name,
                                send_message);
                            //FOR SCROLLING TO END
                            groupListProvider.sendMsg(index, send_message);

                            messageController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
