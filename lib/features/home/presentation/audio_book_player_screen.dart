import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';

class BookAudio extends StatefulWidget {
  final int index;
  final DocumentSnapshot snapshot;
  const BookAudio({Key? key, required this.snapshot , required this.index}) : super(key: key);

  @override
  State<BookAudio> createState() => _BookAudioState();
}

class _BookAudioState extends State<BookAudio> {
  late int index = widget.index;
  late DocumentSnapshot snapshot = widget.snapshot;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  final ReceivePort _port = ReceivePort();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {

      setState(() {});
    });
    Future.delayed(Duration.zero, () async{
      await audioPlayer.play(UrlSource( snapshot['book_audio'] ?? ""));
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.stop();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(
              child: Center(
                child: Text(
                  snapshot['book_name'] ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Image.network(
                  snapshot['book_image'] ?? "",
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  min: 0  ,
                  onChanged: (value) {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),
            Text(
              "${position.inSeconds} / ${duration.inSeconds} seconds",
              style: const TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play(UrlSource( snapshot['book_audio'] ?? ""));
                    }
                  },
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 70,
                  ),
                ),
                const SizedBox(
                  width: 50,),
                IconButton(
                  onPressed: () async {
                    await audioPlayer.stop();
                    setState(() {
                      position = Duration.zero;
                    });
                  },
                  icon: const Icon(
                    Icons.stop_circle_outlined,
                    size: 70,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          audioPlayer.stop();
                        },
                        child: const Text("back to List"),
                      )
                  ),
                  const SizedBox(
                    width: 20,),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}