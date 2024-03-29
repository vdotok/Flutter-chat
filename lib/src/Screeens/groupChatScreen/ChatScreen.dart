import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../core/services/server.dart';
import '../groupChatScreen/AddAttachmentsPopUp.dart';
import '../home/CustomAppBar.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';

// typedef DownloadingProgress = void Function(
//     int total, int download, double prog);

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
  late String _localPath;
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
  // late DownloaderUtils options;
  // late DownloaderCore core;
  // late final String path;
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
    // getApplicationDocumentsDirectory().then((value) async {

    super.dispose();
  }

  bool downloading = false;
  var progress = "0";
  bool isDownloaded = false;
  
  var downloadProgress = 0.0;



  Future<void> downloadFile(uri) async {
    print('this is uri==== $uri ');
    showdialog();
    String extension = uri.toString().split(".").last;
    print("This is extension $extension");
    setState(() {
      downloading = true;
    });
    String filename = (DateTime.now()).millisecondsSinceEpoch.toString() +
        "." +
        '${extension}';
    print("this is file name in downloadddd $filename");
    String savePath;
    //'.$extension';
    if (Platform.isAndroid) {
      savePath = await getFilePath();
    } else {
      savePath = await getDocumentDirectoryPath();
    }
    final response = await http.get(Uri.parse(uri));
    print('ressssponse === $response');
    print('response===byteess=${response.bodyBytes}');
    String filePath = '$savePath/$filename';
    print("this is fillllleeee $filePath");
    File file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);
     Navigator.pop(context);
   
  }

  //gets the applicationDirectory and path for the to-be downloaded file
  // which will be used to save the file to that path in the downloadFile method
  Future<String> getFilePath() async {
     var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("FlutterChat");
     _directory = Directory("/storage/emulated/0/Download");
     final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;

    // String path = '';
    // Directory? dir = await getExternalStorageDirectory();
    // // path = '${dir!.path}/$uniqueFileName';
    // path = dir!.path;
    // print("pathhhhhh $path");
    // return path;
  }


  Future<String> getDocumentDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  Future<String?> _getSavedDir() async {
    Directory directory = await getTemporaryDirectory();
    String appDocPath = directory.path;
    print("this is appdocpath $appDocPath $directory");
    return appDocPath;
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
    XFile? pickedFile;

    if (src == "Gallery") {
      pickedFile = (await picker.pickImage(source: ImageSource.gallery));
      // pickedFile = await picker.getVideo(source: ImageSource.gallery);
      // Navigator.pop(context);
    }
    if (src == "Camera") {
      pickedFile = (await picker.pickImage(source: ImageSource.camera));
      // Navigator.pop(context);
    }
    print('Image pickedd${pickedFile!.readAsBytes()}');
    // ignore: unnecessary_null_comparison
    if (pickedFile != null) {
      image = File(pickedFile.path);
      print("this is imaggggggeeee $image");
      //ContactProvider contact = Provider.of<ContactProvider>(context, listen: false);
//contact.sendFile(image, authProvider.getUser!.auth_token);
      var apiData1 = {
        "type": "ftp",
        "extension": (pickedFile.path.split('.').last),
        "uploadFile": image,
        "auth_token": authProvider.getUser!.auth_token,
      };
      print("this is upload image data  $apiData1");
      var currentpic = await loginPostPic(apiData1);
      print("this is current pic $currentpic");
      
      Map<String, dynamic> filePacket = {
        "id": generateMd5(
            _groupListProvider.groupList.groups![index]!.channel_key),
        // "topic": _groupListProvider.groupList.groups[index].channel_name,
        "to": _groupListProvider.groupList.groups![index]!.channel_name,
        "key": _groupListProvider.groupList.groups![index]!.channel_key,
        "from": authProvider.getUser!.ref_id,
        "type": MessageType.ftp,
        "subType": MediaType.image,
        "content": currentpic["file_name"],
        "fileExtension": (pickedFile.path.split('.').last),
        "isGroupMessage": false,
        "size": 0,
        "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
        "status": ReceiptType.sent,
      };
      print("this is file packett $filePacket");
      widget.publishMessage(
          _groupListProvider.groupList.groups![index]!.channel_key,
          _groupListProvider.groupList.groups![index]!.channel_name,
          filePacket);
      filePacket["content"] = kIsWeb ? pickedFile.path : File(pickedFile.path);
      _groupListProvider.sendMsg(index, filePacket);
    } else {
      print('No image selected.');
    }
  }

  filePIcker(String fileType) async {
    print("filetype $fileType");
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
      print("image block");
      type = MediaType.image;
    } else {
      type = MediaType.file;
    }
    print("this is type $type");
    if (result != null) {
      if (kIsWeb) {
        try {
          Navigator.pop(context);
          Uint8List? uploadfile = result.files.single.bytes;
          print('upload files bytes${base64.encode(uploadfile!)}');
          // if (uploadfile!.length > 6000000) {
          //   buildShowDialog(context, "Error Message",
          //       "File size should be less than 6 MB!!");
          //   return;
          // }
          print("this is file ${(result.files.single.name)}");
          var apiData1 = {
            "type": "ftp",
            "extension": (result.files.single.name.toString().split('.').last),
            "uploadFile": image,
            "auth_token": authProvider.getUser!.auth_token,
          };
          print("this is upload image data  $apiData1");
          var currentpic = await loginPostPic(apiData1);
          print(
              "this is current picccccccccc $currentpic ${result.files.single.name.toString().split('.').last}");
          Map<String, dynamic> filePacket = {
            "id": generateMd5(
                _groupListProvider.groupList.groups![index]!.channel_key),
            // "topic": _groupListProvider.groupList.groups[index].channel_name,
            "to": _groupListProvider.groupList.groups![index]!.channel_name,
            "key": _groupListProvider.groupList.groups![index]!.channel_key,
            "from": authProvider.getUser!.ref_id,
            "type": MessageType.ftp,
            "content": currentpic["file_name"],
            "fileName": result.files.single.name.toString(),
            "fileExtension":
                (result.files.single.name.toString().split('.').last),
            // p.extension(file.path.lastIndexOf('.')).substring(1)),
            "isGroupMessage": false,
            "size": 0,
            "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
            "status": ReceiptType.sent,
            "subType": type
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
        } catch (e) {
          print('$e');
        }
      } else {
        //  Navigator.pop(context);
        File file = File(result.files.first.path!);
        print("file from file $file");
        // print('path of file${file.path}');
        // Uint8List bytes = await file.readAsBytes();
        // print("bytes length ${bytes.length}");
        // if (bytes.length > 6000000) {
        //   buildShowDialog(
        //       context, "Error Message", "File size should be less than 6 MB!!");
        //   return;
        // }
        // print("this is file ${(file.path.split('.').last)}");
        // print("this bytess${bytes}");
        var apiData1 = {
          "type": "ftp",
          "extension": file.path.split('.').last,
          "uploadFile": file,
          "auth_token": authProvider.getUser!.auth_token,
        };
        print("this is upload image data  $apiData1");
        var currentpic = await loginPostPic(apiData1);
        print("this is current pic $currentpic ${file.path.split('.').last}");
        Map<String, dynamic> filePacket = {
          "id": generateMd5(
              _groupListProvider.groupList.groups![index]!.channel_key),
          // "topic": _groupListProvider.groupList.groups[index].channel_name,
          "to": _groupListProvider.groupList.groups![index]!.channel_name,
          "key": _groupListProvider.groupList.groups![index]!.channel_key,
          "from": authProvider.getUser!.ref_id,
          "type": MessageType.ftp,
          "content": currentpic["file_name"],
          "fileExtension": (file.path.split('.').last),
          // p.extension(file.path.lastIndexOf('.')).substring(1)),
          "isGroupMessage": false,
          "size": 0,
          "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
          "status": ReceiptType.sent,
          "subType": type
        };
        // fileee.writeAsBytesSync(bytes);
        // _groupListProvider.sendMsg(index, filePacket);
        widget.publishMessage(
            _groupListProvider.groupList.groups![index]!.channel_key,
            _groupListProvider.groupList.groups![index]!.channel_name,
            filePacket);
        filePacket["content"] = kIsWeb ? null : File(file.path);
        // filePacket["content"] = kIsWeb ? null : currentpic["file_name"];
        _groupListProvider.sendMsg(index, filePacket);
        //  Navigator.pop(context);
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
    widget.mainProvider!.homeScreen();
    strArr.remove("ChatScreen");
    _groupListProvider.handlBacktoGroupList(index);
    // Navigator.pop(context);
    // Navigator.pop(context);
    return false;
  }

  showdialog() {
    showDialog(
        barrierColor: Color.fromARGB(194, 248, 248, 255),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: GestureDetector(
                  onTapDown: (TapDownDetails tapDownDetails) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: dividerColor,
                          blurRadius: 10,
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(7),
                    ),
                    height: 153,
                    width: 262,
                    child: isDownloaded == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Downloading.......",
                                  style: TextStyle(color: receiverMessagecolor),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator(
                                  color: receiverMessagecolor),
                            ],
                          )
                        : Container(),
                  ),
                ));
          });
        });
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
        () => controller.hasClients
            ? controller.jumpTo(controller.position.maxScrollExtent)
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
                                      // (
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
        "this is content of receiving mesgs ${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content} ${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.subtype}");
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
                                      groupListProvider
                                                  .groupList
                                                  .groups![index]!
                                                  .chatList![chatindex]!
                                                  .type ==
                                              MessageType.ftp
                                          ?
                                          // ? Container(child:Text("hehvdsghvcgdbgbvdsgvdgbgvgdb")):Container()
                                          groupListProvider
                                                      .groupList
                                                      .groups![index]!
                                                      .chatList![chatindex]!
                                                      .subtype ==
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
                                                                      .groups![
                                                                          index]!
                                                                      .chatList![
                                                                          chatindex]!
                                                                      .content,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )
                                                              : Image.network(
                                                                  groupListProvider
                                                                      .groupList
                                                                      .groups![
                                                                          index]!
                                                                      .chatList![
                                                                          chatindex]!
                                                                      .content,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                      //   ],
                                                      // )
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      width: 200,
                                                      //
                                                      // height: 100,
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
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child: kIsWeb
                                                            ? Image.memory(
                                                                groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content,
                                                              )
                                                            : Image.network(
                                                                groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress !=
                                                                      null) {
                                                                    return Center(
                                                                      child:
                                                                          Container(
                                                                        child: Transform
                                                                            .scale(
                                                                          scale:
                                                                              0.75,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(chatRoomColor),
                                                                            strokeWidth:
                                                                                3.0,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //     Container(
                                                                      //   //   height: 20,
                                                                      //   child:
                                                                      //       CircularProgressIndicator(
                                                                      //     valueColor:
                                                                      //         AlwaysStoppedAnimation<Color>(chatRoomColor),
                                                                      //     //  strokeWidth: 3.0,
                                                                      //   ),
                                                                      // ),
                                                                    );
                                                                    // return const Center(
                                                                    //     child: Text(
                                                                    //         'Loading...'));
                                                                  } else {
                                                                    return child;
                                                                  }
                                                                },
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                      ),
                                                    )
                                              : groupListProvider
                                                          .groupList
                                                          .groups![index]!
                                                          .chatList![chatindex]!
                                                          .subtype ==
                                                      MediaType.audio
                                                  ? kIsWeb
                                                      ?
                                                      //for audio
                                                      Text("for web audio")
                                                      : InkWell(
                                                          onTap: () {
                                                            print(
                                                                "in audio file case");
                                                            downloadFile(
                                                                groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  receiverMessagecolor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 16,
                                                                    bottom: 16,
                                                                    left: 15,
                                                                    right: 20),
                                                            // width: 250,
                                                            child: Text(
                                                              groupListProvider
                                                                  .groupList
                                                                  .groups![
                                                                      index]!
                                                                  .chatList![
                                                                      chatindex]!
                                                                  .content
                                                                  .toString()
                                                                  .split('/')
                                                                  .last
                                                                  .split("=")
                                                                  .last,
                                                              // +"." +  groupListProvider
                                                              // .groupList
                                                              // .groups![
                                                              //     index]!
                                                              // .chatList![
                                                              //     chatindex]!
                                                              // .fileExtension,
                                                              // .path
                                                              // .toString()
                                                              // .split(
                                                              //     "/")
                                                              // .last,
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
                                                  // Text(
                                                  //                groupListProvider
                                                  //                   .groupList
                                                  //                   .groups![
                                                  //                       index]!
                                                  //                   .chatList![
                                                  //                       chatindex]!
                                                  //                   .content
                                                  //                   .toString()
                                                  //                   .split(
                                                  //                       '/')
                                                  //                   .last.split("=").last,
                                                  //                   // +"." +  groupListProvider
                                                  //                   // .groupList
                                                  //                   // .groups![
                                                  //                   //     index]!
                                                  //                   // .chatList![
                                                  //                   //     chatindex]!
                                                  //                   // .fileExtension,
                                                  //                   // .path
                                                  //                   // .toString()
                                                  //                   // .split(
                                                  //                   //     "/")
                                                  //                   // .last,
                                                  //               textAlign:
                                                  //                   TextAlign
                                                  //                       .left,
                                                  //               style:
                                                  //                   TextStyle(
                                                  //                 color: Colors
                                                  //                     .white,
                                                  //                 fontSize:
                                                  //                     14,
                                                  //               ),
                                                  //             )
                                                  // AudioWidget(
                                                  //     groupListProvider:
                                                  //         groupListProvider,
                                                  //     chatindex: chatindex,
                                                  //     index: index,
                                                  //     file1:
                                                  //         File('dummy.txt'),
                                                  //     file: groupListProvider
                                                  //         .groupList
                                                  //         .groups![index]!
                                                  //         .chatList![
                                                  //             chatindex]!
                                                  //         .content,
                                                  //     isReceive: true,
                                                  //   )
                                                  // : AudioWidget(
                                                  //     groupListProvider:
                                                  //         groupListProvider,
                                                  //     chatindex: chatindex,
                                                  //     index: index,
                                                  //     //file: "",
                                                  //     file:  "",
                                                  //            // file1:
                                                  //             //File('dummy.txt'),
                                                  //     file1:
                                                  //         groupListProvider
                                                  //             .groupList
                                                  //             .groups![
                                                  //                 index]!
                                                  //             .chatList![
                                                  //                 chatindex]!
                                                  //             .content,
                                                  //     isReceive: true,
                                                  //   )
                                                  // Text('fdgsdhg')
                                                  : groupListProvider
                                                              .groupList
                                                              .groups![index]!
                                                              .chatList![
                                                                  chatindex]!
                                                              .subtype ==
                                                          MediaType.video
                                                      ?
                                                      //for video
                                                      InkWell(
                                                          onTap: () {
                                                            print(
                                                                "i am opening file1");
                                                            downloadFile(
                                                                groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content);
                                                            // kIsWeb
                                                            //     ? Navigator.push(
                                                            //         context,
                                                            //         MaterialPageRoute(
                                                            //             builder:
                                                            //                 (context) =>
                                                            //                     VideoScreen(
                                                            //                       text:
                                                            //                           groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content.toString(),
                                                            //                     )))
                                                            //     // ? groupListProvider.playVideo(
                                                            //     //     groupListProvider
                                                            //     //         .groupList
                                                            //     //         .groups![
                                                            //     //             index]!
                                                            //     //         .chatList![
                                                            //     //             chatindex]!
                                                            //     //         .content
                                                            //     //         .toString())
                                                            //     // ? VideoPlayer(videocontroller =
                                                            //     //     VideoPlayerController.network(
                                                            //     //         groupListProvider
                                                            //     //             .groupList
                                                            //     //             .groups![
                                                            //     //                 index]!
                                                            //     //             .chatList![
                                                            //     //                 chatindex]!
                                                            //     //             .content)
                                                            //     //       ..addListener(() =>
                                                            //     //           setState(
                                                            //     //               () {}))
                                                            //     //       ..setLooping(
                                                            //     //           true)
                                                            //     //       ..initialize()
                                                            //     //           .then((_) =>
                                                            //     //               videocontroller!
                                                            //     //                   .play()))
                                                            //     // ? OpenFile.open(
                                                            //     //     groupListProvider
                                                            //     //         .groupList
                                                            //     //         .groups![
                                                            //     //             index]!
                                                            //     //         .chatList![
                                                            //     //             chatindex]!
                                                            //     //         .content)
                                                            //     : OpenFile.open(
                                                            //         groupListProvider
                                                            //             .groupList
                                                            //             .groups![
                                                            //                 index]!
                                                            //             .chatList![
                                                            //                 chatindex]!
                                                            //             .content
                                                            //             .path,
                                                            //       );
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  receiverMessagecolor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
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
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
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
                                                                        .last
                                                                        .split(
                                                                            "=")
                                                                        .last,
                                                                    // +"." +  groupListProvider
                                                                    // .groupList
                                                                    // .groups![
                                                                    //     index]!
                                                                    // .chatList![
                                                                    //     chatindex]!
                                                                    // .fileExtension,
                                                                    // .path
                                                                    // .toString()
                                                                    // .split(
                                                                    //     "/")
                                                                    // .last,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                          ),
                                                        )
                                                      :
                                                      //for file
                                                      InkWell(
                                                          onTap: () async {
                                                            print(
                                                                "i am opening file2 ${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content}");

                                                            await downloadFile(groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content)
                                                                .then(
                                                              (value) {
                                                                OpenFile.open(groupListProvider
                                                                    .groupList
                                                                    .groups![
                                                                        index]!
                                                                    .chatList![
                                                                        chatindex]!
                                                                    .content);
                                                              },
                                                            ).catchError(
                                                                    (onError) {
                                                              print(
                                                                  "this is catch error $onError");
                                                            });

                                                            // _downloadFile(groupListProvider
                                                            // .groupList
                                                            // .groups![
                                                            //     index]!
                                                            // .chatList![
                                                            //     chatindex]!
                                                            // .content);
                                                            // _downloadFile(groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content,"abcd");
// String result=await createFolder(groupListProvider
//                                                                     .groupList
//                                                                     .groups![
//                                                                         index]!
//                                                                     .chatList![
//                                                                         chatindex]!
//                                                                     .content);
// print("this is result $result");

                                                            // _localPath =
                                                            //     (await _getSavedDir())!;
                                                            // var dio = Dio();
                                                            // await dio.download(
                                                            //     groupListProvider
                                                            //         .groupList
                                                            //         .groups![
                                                            //             index]!
                                                            //         .chatList![
                                                            //             chatindex]!
                                                            //         .content,
                                                            //     _localPath);
                                                            // //                                       _localPath =
                                                            //                                           (await _getSavedDir())!;
                                                            //                                           print("This is loxcal path $_localPath ${groupListProvider
                                                            //                                               .groupList
                                                            //                                               .groups![
                                                            //                                                   index]!
                                                            //                                               .chatList![
                                                            //                                                   chatindex]!
                                                            //                                               .content}");
                                                            //                                                 File file = await File(
                                                            //     '${_localPath}/vdotok${DateTime.now().toString().trim()}')
                                                            // .create();
                                                            // file.writeAsString(file.toString());

                                                            //   var file = await File(groupListProvider
                                                            // .groupList
                                                            // .groups![
                                                            //     index]!
                                                            // .chatList![
                                                            //     chatindex]!
                                                            // .content).writeAsString('some content');
                                                            // final fileName = path.basename(
                                                            //     groupListProvider
                                                            //         .groupList
                                                            //         .groups![
                                                            //             index]!
                                                            //         .chatList![
                                                            //             chatindex]!
                                                            //         .content);
                                                            // File localImage =
                                                            //     await file.copy(
                                                            //         "$_localPath/$fileName");
                                                            // print(
                                                            //     "local image $localImage");

                                                            // print("this is finalname $fileName");
                                                            // options =
                                                            //     DownloaderUtils(
                                                            //   progressCallback:
                                                            //       (current,
                                                            //           total) {
                                                            //     final progress =
                                                            //         (current /
                                                            //                 total) *
                                                            //             100;
                                                            //     print(
                                                            //         'Downloading: $progress');
                                                            //   },
                                                            //   file: File(
                                                            //       '$_localPath/200MB.zip'),
                                                            //   progress:
                                                            //       ProgressImplementation(),
                                                            //   onDone: () => print(
                                                            //       'COMPLETE'),
                                                            //   deleteOnCancel:
                                                            //       true,
                                                            // );
                                                            // core = await Flowder.download(
                                                            //     groupListProvider
                                                            //         .groupList
                                                            //         .groups![
                                                            //             index]!
                                                            //         .chatList![
                                                            //             chatindex]!
                                                            //         .content
                                                            //       ,
                                                            //     options);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  receiverMessagecolor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 16,
                                                                    bottom: 16,
                                                                    left: 15,
                                                                    right: 20),
                                                            child: kIsWeb
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
                                                                    // "fjdghdfjhkdfjdfk",
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
                                                                        .last
                                                                        .split(
                                                                            "=")
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
                                                            // SizedBox(
                                                            //   height: 5,
                                                            // ),
                                                            // IconButton(
                                                            //   onPressed: () {
                                                            //     // groupListProvider.downloadFile(
                                                            //     //     urlGenerated
                                                            //     //         .toString(),
                                                            //     //     groupListProvider
                                                            //     //         .groupList
                                                            //     //         .groups![
                                                            //     //             index]!
                                                            //     //         .chatList![
                                                            //     //             chatindex]!
                                                            //     //         .fileName,
                                                            //     //     groupListProvider
                                                            //     //         .groupList
                                                            //     //         .groups![
                                                            //     //             index]!
                                                            //     //         .chatList![
                                                            //     //             chatindex]!
                                                            //     //         .fileExtension);
                                                            //   },
                                                            //   icon: Icon(Icons
                                                            //       .file_download_outlined),
                                                            // )
                                                          ),
                                                        )
                                          : Container()),
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
        'chat available  ${groupListProvider.groupList.groups![index]!.chatList![chatindex]!.content}');
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
                // : Text(""),
                // Text(
                //   DateFormat().add_jm().format(
                //       DateTime.fromMillisecondsSinceEpoch(groupListProvider
                //               .groupList
                //               .groups[index]
                //               .chatList[chatindex]
                //               .date *
                //           100)),
                //   textAlign: TextAlign.right,
                //   style: TextStyle(
                //     color: messageTimeColor,
                //     fontSize: 12,
                //   ),
                // ),
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
                              MessageType.ftp
                          ? groupListProvider.groupList.groups![index]!
                                      .chatList![chatindex]!.subtype ==
                                  MediaType.image
                              ?
                              //for image
                              Container(
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
                                        // : Text("djfkghjf")
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
                                      groupListProvider
                                          .groupList
                                          .groups![index]!
                                          .chatList![chatindex]!
                                          .content,
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
                                              : Text(
                                                  // "fjdghdfjhkdfjdfk",
                                                  groupListProvider
                                                      .groupList
                                                      .groups![index]!
                                                      .chatList![chatindex]!
                                                      .content
                                                      .toString()
                                                      .split("/")
                                                      .last
                                                      .split("'")
                                                      .first,
                                                  // .split('/')
                                                  // .last,
                                                  // .split("=")
                                                  // .last,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    // color:
                                                    //     sendMessageColoer,
                                                    fontSize: 14,
                                                  ),
                                                ),

                                      // Image.file(
                                      //     groupListProvider
                                      //         .groupList
                                      //         .groups![index]!
                                      //         .chatList![chatindex]!
                                      //         .content,
                                      //     fit: BoxFit.fill,
                                      //   ),
                                      //   ],
                                      // ),
                                    ),
                                  ),
                                )
                          // : groupListProvider.groupList.groups![index]!
                          //             .chatList![chatindex]!.type ==
                          //         MediaType.audio
                          //     ?
                          //     //for audio
                          //     kIsWeb
                          //         ?
                          //         // ? AudioWidget(groupListProvider: groupListProvider, chatindex: chatindex, index: index, file1:, file: file, isReceive: isReceive)
                          //         AudioWidget(
                          //             groupListProvider: groupListProvider,
                          //             chatindex: chatindex,
                          //             index: index,
                          //             file1: File('dummy.txt'),
                          //             file: groupListProvider
                          //                 .groupList
                          //                 .groups![index]!
                          //                 .chatList![chatindex]!
                          //                 .content,
                          //             isReceive: false,
                          //           )
                          //         : AudioWidget(
                          //             groupListProvider: groupListProvider,
                          //             chatindex: chatindex,
                          //             index: index,
                          //             file: "",
                          //             file1: groupListProvider
                          //                 .groupList
                          //                 .groups![index]!
                          //                 .chatList![chatindex]!
                          //                 .content,
                          //             isReceive: false,
                          //           )
                          // : groupListProvider.groupList.groups![index]!
                          //             .chatList![chatindex]!.type ==
                          //         MediaType.video
                          //     ?
                          //     //for video
                          //     // Container()
                          //     InkWell(
                          //         onTap: () {
                          //           print("i am opening file4");
                          //           kIsWeb
                          //               ? Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           VideoScreen(
                          //                             text: groupListProvider
                          //                                 .groupList
                          //                                 .groups![index]!
                          //                                 .chatList![
                          //                                     chatindex]!
                          //                                 .content
                          //                                 .toString(),
                          //                           )))
                          //               : OpenFile.open(groupListProvider
                          //                   .groupList
                          //                   .groups![index]!
                          //                   .chatList![chatindex]!
                          //                   .content
                          //                   .path);
                          //           // Navigator.of(context)
                          //           //     .push(new MaterialPageRoute<Null>(
                          //           //         builder: (BuildContext context) {
                          //           //           return VideoItems(
                          //           //             file: groupListProvider
                          //           //                 .groupList
                          //           //                 .groups[index]
                          //           //                 .chatList[chatindex]
                          //           //                 .content
                          //           //                 .path,
                          //           //             // videoPlayerController:
                          //           //             //     VideoPlayerController.network(
                          //           //             //         groupListProvider.groupList.groups[index].chatList[chatindex].content),
                          //           //             looping: false,
                          //           //             autoplay: true,
                          //           //           );
                          //           //         },
                          //           //         fullscreenDialog: true));
                          //         },
                          //         child: Container(
                          //           padding: EdgeInsets.only(
                          //               top: 16,
                          //               bottom: 16,
                          //               left: 20,
                          //               right: 20),
                          //           child: kIsWeb
                          //               ? Text(
                          //                   groupListProvider
                          //                       .groupList
                          //                       .groups![index]!
                          //                       .chatList![chatindex]!
                          //                       .fileExtension,
                          //                   textAlign: TextAlign.left,
                          //                   style: TextStyle(
                          //                     color: sendMessageColoer,
                          //                     fontSize: 14,
                          //                   ),
                          //                 )
                          //               : Text(
                          //                   groupListProvider
                          //                       .groupList
                          //                       .groups![index]!
                          //                       .chatList![chatindex]!
                          //                       .content
                          //                       .path
                          //                       .toString()
                          //                       .split("/")
                          //                       .last,
                          //                   textAlign: TextAlign.left,
                          //                   style: TextStyle(
                          //                     color: sendMessageColoer,
                          //                     fontSize: 14,
                          //                   ),
                          //                 ),
                          //         ))
                          //     :
                          //     //for file
                          //     InkWell(
                          //         onTap: () {
                          //           print("i am opening file5");

                          //           OpenFile.open(
                          //             groupListProvider
                          //                 .groupList
                          //                 .groups![index]!
                          //                 .chatList![chatindex]!
                          //                 .content
                          //                 .path,
                          //           );
                          //           //  Navigator.of(context).push(
                          //           //   new MaterialPageRoute<Null>(
                          //           //       builder:
                          //           //           (BuildContext context) {
                          //           //         return DocumentViewer(
                          //           //           file: groupListProvider
                          //           //               .groupList
                          //           //               .groups[index]
                          //           //               .chatList[chatindex]
                          //           //               .content
                          //           //         );
                          //           //       },
                          //           //       fullscreenDialog: true));
                          //         },
                          //         child: Container(
                          //           padding: EdgeInsets.only(
                          //               top: 16,
                          //               bottom: 16,
                          //               left: 20,
                          //               right: 20),
                          //           child: kIsWeb
                          //               ? Text(
                          //                   groupListProvider
                          //                       .groupList
                          //                       .groups![index]!
                          //                       .chatList![chatindex]!
                          //                       .fileExtension,
                          //                   textAlign: TextAlign.left,
                          //                   style: TextStyle(
                          //                     color: sendMessageColoer,
                          //                     fontSize: 14,
                          //                   ),
                          //                 )
                          //               : Text(
                          //                   groupListProvider
                          //                       .groupList
                          //                       .groups![index]!
                          //                       .chatList![chatindex]!
                          //                       .content
                          //                       .path
                          //                       .toString()
                          //                       .split("/")
                          //                       .last,
                          //                   textAlign: TextAlign.left,
                          //                   style: TextStyle(
                          //                     color: sendMessageColoer,
                          //                     fontSize: 14,
                          //                   ),
                          //                 ),
                          //         ),
                          //       ),
                          : Container()),
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
        () => controller.hasClients
            ? controller.jumpTo(controller.position.maxScrollExtent)
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
                  // Container(
                  //   //   margin: EdgeInsets.only(top: 17),
                  //   height: 21,
                  //   width: 287,
                  //   child:
                  Expanded(
                    child: TextFormField(
                      // onTap: (){
                      //   Timer(
                      //           Duration(milliseconds: 5),
                      //           () => controller.hasClients
                      //               ? controller.jumpTo(
                      //                   controller.position.maxScrollExtent+100)
                      //               //  }
                      //               : null);
                      // },
                      // ignore: deprecated_member_use
                      // inputFormatters: [
                      //   WhitelistingTextInputFormatter(RegExp(r'[a-zA-Z0-9]'))
                      // ],
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
                            "type": MessageType.typing,
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
                      // onEditingComplete: (){
                      //    var send_message = {
                      //     "id": generateMd5(groupListProvider
                      //         .groupList.groups[index].channel_key),
                      //     "to": groupListProvider
                      //         .groupList.groups[index].channel_name,
                      //     "key": groupListProvider
                      //         .groupList.groups[index].channel_key,
                      //     "from": authProvider.getUser.ref_id,
                      //     "type": MessageType.typing,
                      //     "content": "0",
                      //     "size": 0,
                      //     "isGroupMessage": false,
                      //     "date":
                      //         ((DateTime.now()).millisecondsSinceEpoch).round(),
                      //     "status": ReceiptType.sent,
                      //   };

                      //   widget.publishMessage(
                      //       groupListProvider
                      //           .groupList.groups[index].channel_key,
                      //       groupListProvider
                      //           .groupList.groups[index].channel_name,
                      //       send_message);
                      // },
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
                  Expanded(
                    child: Row(
                      children: [
                        Container(
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
                                child:
                                    SvgPicture.asset('assets/AddCircle.svg')),
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
                      ],
                    ),
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



class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
       // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
  
    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }
  
  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }
  
static Future<File> writeCounter(String bytes,String name) async {
  final path = await _localPath;
    // Create a file for the path of
      // device and file name with extension
    File file= File('$path/$name');;
    print("Save file");
      
      // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}