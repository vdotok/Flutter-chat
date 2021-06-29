// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:vdotok_connect/vdotok_connect.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:crypto/crypto.dart' as crypto;
// import 'package:path/path.dart' as p;
// import '../../constants/constant.dart';
// import '../../core/providers/auth.dart';
// import '../../core/providers/groupListProvider.dart';


// class GroupChatScreen extends StatefulWidget {
//   final int index;
//   final publishMessage;
//   GroupChatScreen({this.index, this.publishMessage});
//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   int get index => widget.index;
//   AuthProvider authProvider;
//   GroupListProvider _groupListProvider;
//   ScrollController secondcontroller;
//   ScrollController controller = ScrollController();
//   final TextEditingController messageController = TextEditingController();
//   Emitter emitter = Emitter.instance;

//   // File _image;
//   final picker = ImagePicker();
//   // File _fromChunks;
//   Uint8List _fromChunks;
//   bool scrollUp = false;

//   @override
//   void initState() {
//     super.initState();
//     // MyKey.scaffoldKey = GlobalKey<ScaffoldMessengerState>();
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     // messageScrolling();
//     authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
//   }

//   Future getImage(String src) async {
//     // print("this is message");

//     // for (int i = 0; i < 10; i++) {
//     //   await Future.delayed(Duration(milliseconds: 5), () {
//     //     print("publish message in loop $i");
//     //   });
//     // }

//     // return;
//     var pickedFile;
//     if (src == "Gallery")
//       pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if (src == "Camera")
//       pickedFile = await picker.getImage(source: ImageSource.camera);
//     // else
//     // final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     // Navigator.pop(context);
//     if (pickedFile != null) {
//       // _image = File(pickedFile.path);
//       Uint8List bytes = await pickedFile.readAsBytes();
//       // print("these are bytes array ${listofChunks.length}, ");
//       // List<Uint8List> listofChunks = byteToPortions(bytes);

// //chunks to file or Unit8List
//       // List<int> fromchunks = listofChunks.expand((element) => element).toList();
//       // Uint8List listFromChunks = Uint8List.fromList(fromchunks);
//       // print("these are bytes array ${listFromChunks.length}, ");
//       // setState(() {
//       //   _fromChunks = listFromChunks;
//       // });

//       // Map<String, dynamic> header = {
//       //   "headerId": authProvider.getUser.client_id + DateTime.now().toString(),
//       //   "totalPacket": listofChunks.length,
//       //   "size": bytes.length,
//       //   "fileExtension": p.extension(_image.path),
//       //   "topic": _groupListProvider.groupList.groups[index].channel_name,
//       //   "key": _groupListProvider.groupList.groups[index].channel_key,
//       //   "from": authProvider.getUser.username,
//       //   "type": 0,
//       // };
//       // print("this is headeer json $header ${base64.encode(listofChunks.last)}");
//       // widget.publishMessage(
//       //     _groupListProvider.groupList.groups[index].channel_key,
//       //     _groupListProvider.groupList.groups[index].channel_name,
//       //     header);
//       // for (int i = 1; i <= listofChunks.length; i++) {
//       //   Map<String, dynamic> filePacket = {
//       //     "headerId": header["headerId"],
//       //     "messageId":
//       //         authProvider.getUser.client_id + DateTime.now().toString(),
//       //     "packetNo": i,
//       //     "topic": _groupListProvider.groupList.groups[index].channel_name,
//       //     "key": _groupListProvider.groupList.groups[index].channel_key,
//       //     "from": authProvider.getUser.username,
//       //     "type": 0,
//       //     "content": base64.encode(listofChunks[i - 1]),
//       //   };
//       //   widget.publishMessage(
//       //       _groupListProvider.groupList.groups[index].channel_key,
//       //       _groupListProvider.groupList.groups[index].channel_name,
//       //       filePacket);
//       // }

//       Map<String, dynamic> filePacket = {
//         "id":
//             generateMd5(_groupListProvider.groupList.groups[index].channel_key),
//         "topic": _groupListProvider.groupList.groups[index].channel_name,
//         "key": _groupListProvider.groupList.groups[index].channel_key,
//         "from": authProvider.getUser.full_name,
//         "type": 0,
//         "content": base64.encode(bytes),
//         "fileExtension": p.extension(pickedFile.path),
//         "status": ReceiptType.sent
//       };

//       // _groupListProvider.sendMsg(index, filePacket);
//       widget.publishMessage(
//           _groupListProvider.groupList.groups[index].channel_key,
//           _groupListProvider.groupList.groups[index].channel_name,
//           filePacket);
//       filePacket["content"] = kIsWeb ? pickedFile.path : File(pickedFile.path);
//       _groupListProvider.sendMsg(index, filePacket);
//     } else {
//       print('No image selected.');
//     }
//   }

//   List<Uint8List> byteToPortions(Uint8List largeByteArray) {
//     // create a list to keep the portions
//     List<Uint8List> byteArrayPortions = [];

//     // 12kb is about 12288 bytes
//     int sizePerPortion = 12288;
//     int offset = 0;
//     for (int i = 0; i <= (largeByteArray.length / sizePerPortion); i++) {
//       int end = sizePerPortion * (i + 1);
//       if (end >= largeByteArray.length) {
//         end = largeByteArray.length;
//       }
//       Uint8List portion = largeByteArray.sublist(offset, end);
//       offset = end;
//       byteArrayPortions.add(portion);
//     }
//     return byteArrayPortions;
//   }

//   generateMd5(String groupkey) {
//     var input = DateTime.now().millisecondsSinceEpoch.toString() + groupkey;
//     var content = crypto.md5.convert(utf8.encode(input)).toString();
//     print("the input value in MD5 format: $content");
//     return content;
//   }

//   Future<bool> _onWillPop() async {
//     _groupListProvider.handlBacktoGroupList(index);
//     Navigator.pop(context);
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Consumer<GroupListProvider>(
//         builder: (context, groupListProvider, child) {
//           return Scaffold(
//               // key: MyKey.scaffoldKey,
//               backgroundColor: Color(0xffece5dd),
//               appBar: AppBar(
//                 title: groupListProvider.groupList.groups[index].typingstatus ==
//                             null ||
//                         groupListProvider
//                                 .groupList.groups[index].typingstatus ==
//                             ""
//                     ? //name of user if participants count is 1
//                     groupListProvider
//                                 .groupList.groups[index].participants.length ==
//                             1
//                         ? Text(
//                             "${groupListProvider.groupList.groups[index].participants[0].full_name}")
//                         : //name of user if participants count is 2
//                         groupListProvider.groupList.groups[index].participants
//                                     .length ==
//                                 2
//                             ? Text(
//                                 "${groupListProvider.groupList.groups[index].participants[groupListProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}")
//                             :
//                             //name of user if participants count is more than 2
//                             Text(
//                                 "${groupListProvider.groupList.groups[index].group_title}")
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //name of user if participants count is 1
//                           groupListProvider.groupList.groups[index].participants
//                                       .length ==
//                                   1
//                               ? Text(
//                                   "${groupListProvider.groupList.groups[index].participants[0].full_name}")
//                               : //name of user if participants count is 2
//                               groupListProvider.groupList.groups[index]
//                                           .participants.length ==
//                                       2
//                                   ? Text(
//                                       "${groupListProvider.groupList.groups[index].participants[groupListProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}")
//                                   :
//                                   //name of user if participants count is more than 2
//                                   Text(
//                                       "${groupListProvider.groupList.groups[index].group_title}"),
//                           Text(
//                             "typing...",
//                             style: TextStyle(fontSize: 10),
//                           ),
//                         ],
//                       ),
//                 leading: new IconButton(
//                   icon: new Icon(Icons.arrow_back),
//                   onPressed: () {
//                     groupListProvider.handlBacktoGroupList(index);
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),

//               //List of Messages//
//               body: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   children: [
//                     // Expanded(
//                     //   flex: 2,
//                     //   child: ListView.builder(
//                     //     scrollDirection: Axis.horizontal,
//                     //     itemCount: groupListProvider
//                     //         .groupList.groups[index].participents.length,
//                     //     itemBuilder:
//                     //         (BuildContext context, int indexParticipants) {
//                     //       var presenceIndex = groupListProvider
//                     //           .groupList.groups[index].presence["who"]
//                     //           .indexWhere((e) =>
//                     //               e["username"] ==
//                     //               groupListProvider.groupList.groups[index]
//                     //                   .participents[indexParticipants].ref_id);
//                     //       return Padding(
//                     //         padding: const EdgeInsets.all(8.0),
//                     //         child: Text(
//                     //           groupListProvider.groupList.groups[index]
//                     //               .participents[indexParticipants].username,
//                     //           style: TextStyle(
//                     //               fontWeight: FontWeight.bold,
//                     //               color: presenceIndex == -1
//                     //                   ? Colors.red
//                     //                   : Colors.green),
//                     //         ),
//                     //       );
//                     //     },
//                     //   ),
//                     // ),

//                     Expanded(
//                       child: groupListProvider
//                                   .groupList.groups[index].chatList ==
//                               null
//                           ? Text("")
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               controller: controller,
//                               physics: BouncingScrollPhysics(),
//                               itemCount: groupListProvider
//                                   .groupList.groups[index].chatList.length,
//                               itemBuilder: (context, chatindex) {
//                                 // if (groupListProvider.groupList.groups[index]
//                                 //         .chatList[chatindex].from !=
//                                 //     authProvider.getUser.username) {
//                                 //   if (controller.hasClients) {
//                                 //     controller.animateTo(
//                                 //       controller.position.maxScrollExtent,
//                                 //       curve: Curves.easeOut,
//                                 //       duration:
//                                 //           const Duration(milliseconds: 300),
//                                 //     );
//                                 //   }
//                                 // }

//                                 return Align(
//                                     alignment: (groupListProvider
//                                                 .groupList
//                                                 .groups[index]
//                                                 .chatList[chatindex]
//                                                 .from !=
//                                             authProvider.getUser.full_name
//                                         ? Alignment.centerLeft
//                                         : Alignment.centerRight),
//                                     child: ConstrainedBox(
//                                       constraints: BoxConstraints(
//                                         maxWidth:
//                                             MediaQuery.of(context).size.width -
//                                                 45,
//                                       ),
//                                       child: Card(
//                                         elevation: 1,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8)),
//                                         color: groupListProvider
//                                                     .groupList
//                                                     .groups[index]
//                                                     .chatList[chatindex]
//                                                     .from !=
//                                                 authProvider.getUser.full_name
//                                             ? Colors.white
//                                             : Color(0xffdcf8c6),
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal: 15, vertical: 5),
//                                         child: Stack(
//                                           children: [
//                                             groupListProvider
//                                                         .groupList
//                                                         .groups[index]
//                                                         .chatList[chatindex]
//                                                         .from !=
//                                                     authProvider
//                                                         .getUser.full_name
//                                                 ? Container(
//                                                     padding: EdgeInsets.all(10),
//                                                     child: Text(
//                                                       "${groupListProvider.groupList.groups[index].chatList[chatindex].from}",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                       // maxLines: 1,
//                                                     ),
//                                                   )
//                                                 : Text(""),
//                                             Container(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10,
//                                                     right: groupListProvider.groupList.groups[index].chatList[chatindex].from !=
//                                                             authProvider.getUser
//                                                                 .full_name
//                                                         ? 10
//                                                         : 25,
//                                                     bottom: groupListProvider
//                                                                 .groupList
//                                                                 .groups[index]
//                                                                 .chatList[
//                                                                     chatindex]
//                                                                 .from !=
//                                                             authProvider.getUser
//                                                                 .full_name
//                                                         ? 10
//                                                         : 20,
//                                                     top: groupListProvider
//                                                                 .groupList
//                                                                 .groups[index]
//                                                                 .chatList[chatindex]
//                                                                 .from !=
//                                                             authProvider.getUser.full_name
//                                                         ? 30
//                                                         : 10),
//                                                 child: groupListProvider.groupList.groups[index].chatList[chatindex].type != 0
//                                                     ? Text(
//                                                         "${groupListProvider.groupList.groups[index].chatList[chatindex].content}",
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                         ),
//                                                       )
//                                                     : kIsWeb
//                                                         ? Container(
//                                                             height: 200,
//                                                             width: 200,
//                                                             child: Image.network(
//                                                               groupListProvider
//                                                                   .groupList
//                                                                   .groups[index]
//                                                                   .chatList[
//                                                                       chatindex]
//                                                                   .content,
//                                                               fit: BoxFit.fill,
//                                                             ))
//                                                         : Container(
//                                                             height: 200,
//                                                             width: 200,
//                                                             child: Image.file(
//                                                               groupListProvider
//                                                                   .groupList
//                                                                   .groups[index]
//                                                                   .chatList[
//                                                                       chatindex]
//                                                                   .content,
//                                                               fit: BoxFit.fill,
//                                                             ))),
//                                             Positioned(
//                                               bottom: 4,
//                                               right: 6,
//                                               child: Row(
//                                                 children: [            
//                                                   SizedBox(
//                                                     width: 15,
//                                                   ),
//                                                   groupListProvider
//                                                               .groupList
//                                                               .groups[index]
//                                                               .chatList[
//                                                                   chatindex]
//                                                               .from !=
//                                                           authProvider
//                                                               .getUser.full_name
//                                                       ? Text("")
//                                                       : groupListProvider
//                                                                   .groupList
//                                                                   .groups[index]
//                                                                   .chatList[
//                                                                       chatindex]
//                                                                   .status ==
//                                                               ReceiptType.sent
//                                                           ? Icon(Icons.check,
//                                                               size: 20)
//                                                           : groupListProvider
//                                                                       .groupList
//                                                                       .groups[
//                                                                           index]
//                                                                       .chatList[
//                                                                           chatindex]
//                                                                       .status ==
//                                                                   ReceiptType
//                                                                       .delivered
//                                                               ? Icon(
//                                                                   Icons
//                                                                       .done_all,
//                                                                   size: 20,
//                                                                 )
//                                                               : Icon(
//                                                                   Icons
//                                                                       .done_all,
//                                                                   color: Colors
//                                                                       .blue,
//                                                                   size: 20,
//                                                                 )
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ));
//                               }),
//                     ),

//                     //TextBOX FOR MESSAGESSSSSSSSSS//
//                     buildAlign(context, groupListProvider),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ));
//         },
//       ),
//     );
//   }

//   Align buildAlign(BuildContext context, GroupListProvider groupListProvider) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 70,
//         padding: EdgeInsets.only(left: 2),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Row(
//               children: [
//                 Container(
//                     width: MediaQuery.of(context).size.width - 60,
//                     child: Card(
//                         margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25)),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 controller: messageController,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 keyboardType: TextInputType.multiline,

//                                 decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Type a Message",
//                                     prefixIcon: IconButton(
//                                         icon: Icon(Icons.emoji_emotions),
//                                         onPressed: () {}),
//                                     contentPadding: EdgeInsets.all(5)),

//                                 //TYPING STATUS MESSAGE SEND
//                                 onChanged: (value) {
//                                   var send_message = {
//                                     "from": authProvider.getUser.full_name,
//                                     "content": "1",
//                                     "key": groupListProvider
//                                         .groupList.groups[index].channel_key,
//                                     "type": MessageType.typing,
//                                     "to": groupListProvider
//                                         .groupList.groups[index].channel_name,
//                                     "isGroupMessage": false,
//                                     "status": ReceiptType.sent
//                                   };
//                                   widget.publishMessage(
//                                       groupListProvider
//                                           .groupList.groups[index].channel_key,
//                                       groupListProvider
//                                           .groupList.groups[index].channel_name,
//                                       send_message);
//                                 },
//                               ),
//                             ),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 //For Attachments Files, Images etc
//                                 IconButton(
//                                     icon: Icon(Icons.attach_file),
//                                     onPressed: () {
//                                       //SHOW MODAL BOTTOM SHEET WITH OPTIONS
//                                       showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (builder) => bottomSheet());
//                                     }),
//                                 //CAMERA OPTION
//                                 IconButton(
//                                     icon: Icon(Icons.camera_alt),
//                                     onPressed: () async {
//                                       getImage("Gallery");
//                                     })
//                               ],
//                             ),
//                           ],
//                         ))),

//                 //Send Button//
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(bottom: 8.0, right: 5, left: 2),
//                   child: CircleAvatar(
//                     radius: 25,
//                     backgroundColor: primaryColor,
//                     child: IconButton(
//                         icon: Icon(Icons.send, color: Colors.white),
//                         onPressed: () {
//                           //TEXT MESSAGE SEND
//                           var send_message = {
//                             "from": authProvider.getUser.full_name,
//                             "content": messageController.text,
//                             "id": generateMd5(groupListProvider
//                                 .groupList.groups[index].channel_key),
//                             "key": groupListProvider
//                                 .groupList.groups[index].channel_key,
//                             "type": MessageType.text,
//                             "to": groupListProvider
//                                 .groupList.groups[index].channel_name,
//                             "isGroupMessage": false,
//                             "status": ReceiptType.sent
//                           };

//                           if (messageController.text.isNotEmpty) {
//                             print("This is group chat publish: dsjfjds");
//                             widget.publishMessage(
//                                 groupListProvider
//                                     .groupList.groups[index].channel_key,
//                                 groupListProvider
//                                     .groupList.groups[index].channel_name,
//                                 send_message);
//                             //FOR SCROLLING TO END
//                             groupListProvider.sendMsg(index, send_message);
//                             if (controller.hasClients)
//                               Timer(
//                                   Duration(milliseconds: 300),
//                                   () => controller.jumpTo(
//                                       controller.position.maxScrollExtent));

//                             messageController.clear();
//                           }
//                         }),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget bottomSheet() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 250,
//       child: Card(
//         margin: EdgeInsets.all(18),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   optionIcon(
//                       Icons.insert_drive_file, Colors.indigo, "Documents"),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   optionIcon(Icons.camera_alt, Colors.pink, "Camera"),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   optionIcon(Icons.insert_photo, Colors.purple, "Gallery"),
//                 ],
//               ),

//               SizedBox(
//                 height: 20,
//               ),

//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     optionIcon(Icons.headset, Colors.orange, "Audio"),
//               //     SizedBox(
//               //       width: 40,
//               //     ),
//               //     optionIcon(Icons.location_pin, Colors.teal, "Location"),
//               //     SizedBox(
//               //       width: 40,
//               //     ),
//               //     optionIcon(Icons.person, Colors.blue, "Gallery"),
//               //   ],
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget optionIcon(IconData icon, Color color, String text) {
//     return InkWell(
//       onTap: () {
//         getImage(text);
//       },
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: color,
//             child: Icon(icon, size: 29, color: Colors.white),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Text(
//             "$text",
//             style: TextStyle(fontSize: 12),
//           )
//         ],
//       ),
//     );
//   }
// }
