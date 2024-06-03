import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/dialogs.dart';
import 'package:prashant_chat_app/screens/home_screen.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleButtonClick() {
    // for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) {
      //for hiding progress bar
      Navigator.pop(context);
      //debug console printing
      if (user != null) {
        print(
          '\nUser : ${(user.user)}',
        );
        print('\nUser Additional Information : ${user.additionalUserInfo}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle : $e');
      Dialogs.showSnacbar(context, 'No Internet Connection');
      return null;
    }
  }

  // signout function
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome  to  PC Chat',
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xff5cfaad), Color(0xff5ff1f5)],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            bottom: _isAnimate ? mq.height * 0.5 : -mq.width * .5,
            left: mq.width * 0.25,
            width: mq.width * 0.5,
            duration: Duration(seconds: 1),
            child: Image.asset('assets/images/launcher_icon.png'),
          ),
          Positioned(
            bottom: mq.height * 0.24,
            // left: mq.width * 0.1,
            width: mq.width * 1,
            height: mq.height * 0.09,
            child: Text(
              'Stay connected with your \nfriends and family',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          Positioned(
            bottom: mq.height * 0.15,
            // left: mq.width * 0.10,
            width: mq.width * 1,
            height: mq.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security_rounded,
                  size: 20,
                  color: Color.fromARGB(255, 3, 155, 8),
                ),
                Text(
                  ' Secure, Private & Encrypted...',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // google lgin button
          Positioned(
            bottom: mq.height * 0.10,
            left: mq.width * 0.05,
            width: mq.width * 0.9,
            height: mq.height * 0.07,
            child: Container(
              width: double.infinity,
              height: mq.height * 0.08, // Adjust the height as needed
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xff5cfaad),
                    Color(0xff5ff1f5)
                  ], // Define your gradient colors here
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(30), // Adjust the radius as needed
              ),

              child: ElevatedButton.icon(
                onPressed: () {
                  _handleGoogleButtonClick();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(),
                  elevation: 5,
                ),
                //google icon
                icon: Image.asset(
                  'assets/logo/google_logo.png',
                  height: mq.height * 0.05,
                ),

                //login with google label
                label: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(text: 'Login with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
