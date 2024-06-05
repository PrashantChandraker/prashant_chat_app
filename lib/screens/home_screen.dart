

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:prashant_chat_app/screens/profile_screen.dart';
import 'package:prashant_chat_app/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<ChatUser> list = []; // Creating an empty list to store the data from Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.home,
          ),
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(user: list[0],)));
              },
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
          setState(() {});
        },
        child: Icon(
          CupertinoIcons.plus_bubble_fill,
          color: Colors.black,
          size: 25,
        ),
      ),
      body: StreamBuilder(
        // This stream will take data from Firestore collection and it will give data to the ListView builder
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if the data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(),
              );

            // if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              
              // Storing the data from snapshots in "data" to use further
              final data = snapshot.data?.docs;

              list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

             if(list.isNotEmpty){
               return ListView.builder(
                padding: EdgeInsets.only(top: 3),
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // Retrieve the name and about for the current user
                  // final user = list[index];
                  // final name = user['name'];
                  // final about = user['about'];


                  return ChatUserCard(user: list[index]);
                  // return Text(
                  //     'Name: ${list[index]}'); // It will print on screen the name and about
                },
              );
             }else{
              return Center(child: Text('No Data found!', style: TextStyle(fontSize: 20),));
             }
          }
        },
      ),
    );
  }
}
