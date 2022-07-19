import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:p1/authenticate/sign_in.dart';
import 'package:p1/screens/admin/topdeals.dart';
import 'package:p1/screens/blah.dart';
import 'package:p1/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:p1/models/myuser.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      catchError: (_, __) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car rental',
        //initialRoute: 'home',
        home: AnimatedSplashScreen(
        splash: Image.asset("assets/images/splash.png"),
        splashIconSize: 500,
        nextScreen: SignIn(),
        splashTransition: SplashTransition.slideTransition,
        duration: 1500,
        backgroundColor: Colors.blueAccent,
    ),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.purple, // Your accent color
          ),
        ),
        // routes: {
        //   'home': (context) => Wrapper(),
        //   //CarsOverviewScreen()
        // },
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//
//   final Widget? child;
//
//   MyApp({this.child});
//
//   static void restartApp(BuildContext context)
//   {
//     context.findAncestorRenderObjectOfType<_MyAppState>()!.restartApp();
//   }
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   Key key = UniqueKey();
//   void restartApp(){
//     setState(() {
//       key = UniqueKey();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: key,
//       child: widget.child!);
//   }
// }
