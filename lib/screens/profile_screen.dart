import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:prashant_chat_app/screens/auth/login_screen.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My  Profile',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // trial to check logout function is working or not
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              setState(() {});
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
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
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: Colors.amber,
        onPressed: () {},
        icon: Icon(
          Icons.edit,
          color: Colors.black,
          size: 25,
        ),
        label: Text(
          'Update',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              width: mq.width,
              height: mq.height * 0.03,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  mq.height * 0.1), // passing the half height
              child: CachedNetworkImage(
                width: mq.height * 0.15,
                height: mq.height * 0.15,
                fit: BoxFit.contain,
                imageUrl: widget.user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            Text(
              widget.user.email,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'eg. Pashant Chandraker',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  labelText: 'Name'),
            ),
            SizedBox(
              height: mq.height * 0.02,
            ),
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.info_circle),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'eg. call me anti-social but dont call me',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  labelText: 'Status'),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
