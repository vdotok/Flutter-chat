import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';

class AudioWidget extends StatefulWidget {
  bool isReceive;
  GroupListProvider groupListProvider;
  String file;
  File file1;
  int chatindex;
  int index;
  AudioWidget(
      {required this.groupListProvider,
      required this.chatindex,
      required this.index,
      required this.file1,
      required this.file,
      required this.isReceive});
  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  AudioPlayer _audioPlayer = AudioPlayer();

  late PlayerState _audioPlayerState;
  bool isPlaying = false;
  var currentTime = "00:00";
  var completeTime = "00:00";
  var _completedPercentage = 0.0;
  var _totalDuration;
  var _currentDurationn = 0;

  double _playPosition = 0;
  Duration _playDuration = Duration();
  Duration _currentDuration = Duration();
  bool isPaused = false;
  bool isResumed = false;
  double min = 0.0;
  late String newDuration;
  late String currentNewDuration;

  @override
  void initState() {
    super.initState();
    print("i am in init in audio");
    durationHandler();
  }

  durationHandler() async {
    _audioPlayer.setUrl(kIsWeb ? widget.file : widget.file1.path,
        isLocal: true);
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _playDuration = duration;
        newDuration = _formatDuration(duration);
        _totalDuration = duration.inMilliseconds;
        completeTime = newDuration;
        //duration.toString().split(".")[0];
        print("complete time $completeTime");
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      print('Current player state: $s');
      setState(() {
        _audioPlayerState = s;
        if (_audioPlayerState == PlayerState.COMPLETED) {
          setState(() {
            isPlaying = false;
            _currentDuration = new Duration();
            _playDuration = new Duration();
            currentTime = "00:00";
            completeTime = "00:00";
          });
        }
      });
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _currentDuration = duration;
        currentNewDuration = _formatDuration(duration);
        currentTime = currentNewDuration;
        print("comp time $completeTime");
        _currentDurationn = duration.inMilliseconds;
        // _completedPercentage =
        //     _currentDurationn.toDouble() / _totalDuration.toDouble();
        //duration.toString().split(".")[0];
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (twoDigitHours == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    ;
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    _audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     // width: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:
            widget.isReceive ? receiverMessagecolor : searchbarContainerColor,
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              if (!isPlaying) {
                int status = await _audioPlayer.play(
                    kIsWeb ? widget.file : widget.file1.path,
                    isLocal: true);
                _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
                  setState(() {
                    _currentDuration = duration;
                    print("this is current duration $_currentDuration");
                    currentNewDuration = _formatDuration(duration);
                    currentTime = currentNewDuration;
                    _currentDurationn = duration.inMilliseconds;
      
                    print("current time $currentTime");
                  });
                });
                if (status == 1) {
                  setState(() {
                    isPlaying = true;
                    isPaused = false;
                    isResumed = false;
                  });
                }
              } else if (isPlaying) {
                // else if (isPlaying || isResumed) {
                _audioPlayer.pause();
      
                setState(() {
                  isPlaying = false;
                  isPaused = true;
                  isResumed = false;
                });
              } else {
                _audioPlayer.resume();
      
                setState(() {
                  isPlaying = true;
                  isResumed = true;
                  isPaused = false;
                });
              }
            },
            icon: (isPlaying || isResumed)
                ? Icon(
                    Icons.pause,
                    color:
                        widget.isReceive ? Colors.white : receiverMessagecolor,
                  )
                : Icon(
                    Icons.play_arrow,
                    color:
                        widget.isReceive ? Colors.white : receiverMessagecolor,
                  ),
          ),
      
          SizedBox(
            // height: 20,
            width: 120,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  //trackShape: ,
                  trackShape: CustomTrackShape(),
                  trackHeight: 3,
                  thumbColor: Colors.transparent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0)),
              child: Slider(
                  activeColor:
                      widget.isReceive ? Colors.white : receiverMessagecolor,
                  inactiveColor: typeMessageColor,
                  min: 0,
                  // min,
                  max: 10,
                  //_playDuration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    print("here in onchanged");
                    setState(() {
                      seekToSecond(value.toInt());
                      value = value;
                      print("in onchange audio");
                      // _playPosition = value;
                    });
                  },
                  value: 0
                  //_currentDuration.inSeconds.toDouble(),
      
                  // activeColor: darkYellowColor,
                  //inactiveColor: lightWhiteColor,
                  ),
            ),
          ),
          // ),
          SizedBox(width: 7),
          Flexible(
            child: Text(
              (currentTime == "00:00") ? currentTime : completeTime,
              style: TextStyle(
                color: widget.isReceive ? Colors.white : geryColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

