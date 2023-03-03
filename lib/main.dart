import 'package:absar/Core/obesrver/BlocObserver.dart';
import 'package:absar/features/auth/cubit/auth_cubit.dart';
import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:absar/features/auth/presentation/complitedata.dart';
import 'package:absar/features/auth/presentation/otb_screen.dart';
import 'package:absar/features/home/cubit/home_cubit.dart';
import 'package:absar/features/home/presentation/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit()..init(),
      ),
      BlocProvider<HomeCubit>(
        create: (context) => HomeCubit()..getBooksFromFirestore(),
      ),
    ],
    child: MyApp.create(),
  ));
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Widget create() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is GetUserSuccess) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/home', (r) => false);
        }
        if (state is NotHaveCurrentUser) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (r) => false);
        }
        if (state is GetUserError) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/complete', (r) => false);
        }
      },
      child: const MyApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.white70,
      ),
      navigatorKey: _navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/login': (context) =>  LoginWithGoogle(),
        '/home': (context) => const Home(),
        '/complete': (context) =>  CompleteData(),
      },
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}


