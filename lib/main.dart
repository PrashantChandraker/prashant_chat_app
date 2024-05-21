import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prashant_chat_app/screens/auth/login_screen.dart';

import 'firebase_options.dart';


// global object for accessing device screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        // textTheme: GoogleFonts.lemonTextTheme(),
        useMaterial3: false,
        primarySwatch: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontSize: 60,
         fontFamily: 'KolkerBrush',
            fontStyle: FontStyle.normal
          ),
        ),
      
      ),
      home: LoginScreen(),
    );
  }
}

