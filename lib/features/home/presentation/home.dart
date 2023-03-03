import 'package:absar/features/home/cubit/home_cubit.dart';
import 'package:absar/features/home/presentation/audio_book_player_screen.dart';
import 'package:absar/features/home/presentation/books_list_screen.dart';
import 'package:absar/features/home/presentation/profile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SpeechToText speechToText = SpeechToText();
  var text = 'hold to speak';
  var isListening = false;
  final audioPlayer = AudioPlayer();
  void navigateToBookAudio(int index, DocumentSnapshot snapshot) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<HomeCubit>(),
          child: BookAudio(
            index: 0,
            snapshot: snapshot,
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    audioPlayer.play(AssetSource('welcome.mp3'));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(text),
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Profile',
              ),
              Tab(
                text: 'Books',
              ),
            ],
          )
        ),
        body:  TabBarView(
          children:[
            Profile(),
            Books(),
          ]
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          endRadius: 75.0,
          animate: isListening,
          duration: const Duration(milliseconds: 2000),
          glowColor: Colors.blue,
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (details) async {
              if (!isListening) {
                var available = await speechToText.initialize();
                if (available) {
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          if (result.recognizedWords.contains('قوه العادات'))
                            {
                              navigateToBookAudio(0, context.read<HomeCubit>().books![0]);
                            }
                          text = result.recognizedWords;
                          print(result.recognizedWords);
                        });
                      },
                      cancelOnError: true,
                      localeId: 'ar_EG',
                      listenMode: ListenMode.confirmation,
                    );
                  });
                }
              }
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                isListening = false;
              });
              speechToText.stop();
            },
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 35,
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}








