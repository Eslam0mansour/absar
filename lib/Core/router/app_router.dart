//
//
// import 'package:flutter/material.dart';
// import 'package:location/Core/const/screens_Names.dart';
// import 'package:location/Core/router/custom_page_route.dart';
// import 'package:location/features/auth/presentation/complitedata.dart';
// import 'package:location/features/auth/presentation/login_screen.dart';
// import 'package:location/features/auth/presentation/otb_screen.dart';
// import 'package:location/features/home/presentation/home.dart';
// import 'package:location/main.dart';
//
// class AppRouter {
//   late Widget startScreen;
//
//   Route? onGenerateRoute(RouteSettings settings) {
//     startScreen = const Splash();
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => startScreen);
//       case ScreensNames.home:
//         return CustomPageRoute(
//             direction: AxisDirection.left, child:  Home());
//       case ScreensNames.login:
//         return CustomPageRoute(
//             direction: AxisDirection.right, child:  Login());
//         case ScreensNames.otp:
//         return CustomPageRoute(
//             direction: AxisDirection.right, child:  Otp());
//         case ScreensNames.completeData:
//         return CustomPageRoute(
//             direction: AxisDirection.right, child:  CompleteData());
//       default:
//         return null;
//     }
//   }
// }
