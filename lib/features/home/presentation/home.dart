import 'package:absar/features/auth/cubit/auth_cubit.dart';
import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:absar/features/home/cubit/home_cubit.dart';
import 'package:absar/features/home/cubit/home_staets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
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
        body: const TabBarView(
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

class Books extends StatelessWidget {
  const Books({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitialState) {
          return const Center(
            child: Text('initial'),
          );
        } else if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeSuccessState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: context.read<HomeCubit>().books!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<HomeCubit>(),
                          child: BookAudio(
                            index: index,
                            snapshot: context.read<HomeCubit>().books![index],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              context.read<HomeCubit>().books![index]['book_name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                context.read<HomeCubit>().books![index]['book_image'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is HomeErrorState) {
          return const Center(
            child: Text('error'),
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('error:'),
            ),
          );
        }
        if (state is AuthSignOutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil( '/login', (route) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess ||
            state is DataCompletedDone ||
            state is GetUserSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    'Welcome ${context.read<AuthCubit>().userDoc!['name']}'),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  'Your email is ${context.read<AuthCubit>().userDoc!['email']}'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
                child: const Text('Sign Out'),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}

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



