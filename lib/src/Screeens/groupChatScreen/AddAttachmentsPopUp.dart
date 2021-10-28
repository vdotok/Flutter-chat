import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constant.dart';

class AddAttachmentPopUp extends StatelessWidget {
  final getImage;
  final iconName;
  final filePIcker;
  
  const AddAttachmentPopUp({
    Key key, this.getImage, this.iconName, this.filePIcker
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0)),
        elevation: 0,
        actions: <Widget>[
          Container(
              height: 278,
              width: 319,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                                                child: Container(
                              // width: 201,
                             
                              child: Text(
                                "Add Attachment",
                                style: TextStyle(
                                  color:
                                      createGroupColor,
                                  fontSize: 14,
                                  fontFamily:
                                      searchFontFamily,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              )),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(
                            // left: 54,
                            // top: 30,
                          ),
                          width: 30,
                          height: 30,
                          child: IconButton(
                            icon: SvgPicture.asset(
                                'assets/close.svg'),
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                                icon: SvgPicture
                                    .asset(
                                        'assets/File.svg'),
                                onPressed:
                                    () {
                                  filePIcker("file");
                                  //   Navigator.pop(
                                  // context);
                                }),
                          ),
                          Text(
                            "File",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                                icon: SvgPicture
                                    .asset(
                                        'assets/Camera.svg'),
                                onPressed:
                                    () {
                                   getImage("Camera");
                                  //    Navigator.pop(
                                  // context);
                                   
                                }),
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                                icon: SvgPicture
                                    .asset(
                                        'assets/Album.svg'),
                                onPressed:
                                    () {
                                     filePIcker("ImageAndVideo");
                                 // getImage("Gallery");
                                //    Navigator.pop(
                                // context);
                                }),
                          ),
                          Text(
                            "Album",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                                icon: SvgPicture
                                    .asset(
                                        'assets/Audio.svg'),
                                onPressed:
                                    () {
                                      filePIcker("audio");
                                  //       Navigator.pop(
                                  // context);
                                      
                                  print(
                                      "close icon pressed");
                                }),
                          ),
                          Text(
                            "Audio",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                new BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                                icon: SvgPicture
                                    .asset(
                                        'assets/Map.svg'),
                                onPressed:
                                    () {
                                  print(
                                      "close icon pressed");
                                }),
                          ),
                          Text(
                            "Loction",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets
                                .only(
                                    bottom:
                                        4),
                            width: 56,
                            height: 56,
                            decoration:
                                new BoxDecoration(
                              color:
                                  textfieldhint,
                              shape: BoxShape
                                  .circle,
                            ),
                            child: IconButton(
                              icon: SvgPicture
                                  .asset(
                                      'assets/User.svg'),
                              onPressed: () {
                                print(
                                    "close icon pressed");
                              },
                            ),
                          ),
                          Text(
                            "Contact",
                            style: TextStyle(
                              color:
                                  attachmentNameColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ))
        ]);
  }
}
