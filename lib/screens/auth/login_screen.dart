import 'package:flutter/material.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Welcome to  P  Chat',
          ),
        ),
        body: Stack(
          children: [
            Positioned(
                top: mq.height * 0.15,
                left: mq.width * 0.25,
                width: mq.width * 0.5,
                child: Image.asset('assets/images/launcher_icon.png'),),
                Positioned(
                  bottom: mq.height * 0.15 ,
                
                left: mq.width * 0.05,
                width: mq.width * 0.9,
                height:  mq.height * 0.07,
                child: ElevatedButton.icon(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: StadiumBorder(),
                  elevation: 5,
                ),
                icon: Image.asset('assets/logo/google_logo.png', height: mq.height * 0.05,) ,
                 label: RichText(text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: [
                  TextSpan(text: 'SignIn with '),
                  TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.w500)),
                 ]),),),),
          ],
        ));
  }
}
