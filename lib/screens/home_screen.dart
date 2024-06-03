import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        
   leading: Icon(CupertinoIcons.home),
       
        title: Text('PC  Chat',),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {

          // trial to check logout function is working or not
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },
        child: Icon(CupertinoIcons.chat_bubble_2),
        ),
        body: Text('data',style: TextStyle(fontWeight: FontWeight.w500),),
    );
  }
}