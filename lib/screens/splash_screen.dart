import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prashant_chat_app/screens/auth/login_screen.dart';
import 'package:prashant_chat_app/screens/home_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      //exit full screen UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      if (FirebaseAuth.instance.currentUser != null) {
        //to print ur data in debug console
        debugPrint('\nUser: ${FirebaseAuth.instance.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: mq.height * 0.4,
            left: mq.width * 0.25,
            width: mq.width * 0.5,
            child: Image.asset('assets/images/launcher_icon.png'),
          ),

          // google lgin button
          Positioned(
              bottom: mq.height * 0.10,
              width: mq.width * 1,
              child: Column(
                children: [
                  Text(
                    'MADE IN INDIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'by PRASHANT😉',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
