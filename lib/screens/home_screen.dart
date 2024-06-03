import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){},
            icon: Icon(CupertinoIcons.home,),
            color: Colors.black,
            
          ),
          title: Text(
            'PC  Chat',
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                )),
          ],
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff5ff1f5),
          onPressed: () async {
            // trial to check logout function is working or not
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(CupertinoIcons.plus_bubble_fill, color: Colors.black, size: 25,),
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(top: 3),
            itemCount: 20,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatUserCard();
            }));
  }
}
