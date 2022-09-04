import 'package:flutter/material.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';

void sensoryDialogBox(
    context, Function getSensoryData, index, groupListProvider) {
  showDialog(
      barrierColor: Color.fromARGB(213, 216, 219, 230),
      // barrierColor:transparrent.withOpacity(100),
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 250,
            width: 300,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Container(
                              // width: 201,
                              child: Text(
                            "Moniter Health",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              // fontFamily: searchFontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          margin: EdgeInsets.only(
                              // left: 54,
                              // top: 30,
                              ),
                          width: 30,
                          height: 30,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          print("OffBody");
                          getSensoryData("ob", groupListProvider, index);
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/connectivity.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("heartRate");
                          getSensoryData("hr", groupListProvider, index);
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/heartbeat.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          print("blood oxygen");
                          getSensoryData("bo", groupListProvider, index);
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/sample.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("stepcount");
                          getSensoryData("sc", groupListProvider, index);
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/stepcount.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
