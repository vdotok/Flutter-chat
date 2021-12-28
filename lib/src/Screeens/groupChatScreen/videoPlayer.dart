// import 'dart:io';

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// class VideoItems extends StatefulWidget {
//   // final VideoPlayerController videoPlayerController;
//   final bool looping;
//   final bool autoplay;
//   dynamic file;


//   VideoItems({
//     // @required this.videoPlayerController,
//     this.looping, this.autoplay,
//     this.file,
//     Key key,
//   }) : super(key: key);

//   @override
//   _VideoItemsState createState() => _VideoItemsState();
// }

// class _VideoItemsState extends State<VideoItems> {
//   ChewieController _chewieController;
//   VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

// _controller = VideoPlayerController.file(
//       File(widget.file),
//     );

//     _chewieController = ChewieController(
//       videoPlayerController: _controller,
//       aspectRatio:_controller.value.aspectRatio,
//       autoInitialize: true,
//       autoPlay: widget.autoplay,
//       looping: widget.looping,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _chewieController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: new AppBar(
//         title: const Text('Video Preview'),
      
//       ),
//       body: Chewie(

//         controller: _chewieController,
//       ),
//     );
//     // return Padding(
//     //   padding: const EdgeInsets.all(8.0),
//     //   child: 
//     // );
//   }

// }