import 'package:flutter/material.dart';

void sensoryDialogBox(context, Function getSensoryData) {
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                      child: Text(
                        "Monitor Health ",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100, 15, 0, 0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 30, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print("tap1");
                        },
                        child: Image.asset(
                          'assets/connectivity.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                      SizedBox(
                        width: 21,
                      ),
                      InkWell(
                        onTap: () {
                          print("hr");
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
                  padding: const EdgeInsets.fromLTRB(40, 10, 30, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print("tap3");
                        },
                        child: Image.asset(
                          'assets/sample.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {
                          print("tap4");
                          getSensoryData("sc");
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
