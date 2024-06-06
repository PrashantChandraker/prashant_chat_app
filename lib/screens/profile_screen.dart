import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/dialogs.dart';
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
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when tap other place
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'My  Profile',
          ),
          actions: [
            IconButton(
              splashColor: Colors.red,
              tooltip: 'Logout',
              autofocus: true,
              onPressed: () async {
                // for showing progress dialog
                Dialogs.showProgressBar(context);
      
                // sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    // for hiding progress dialog
                    Navigator.pop(context);
      
                    // for moving to home screen
                    Navigator.pop(context);
      
                    // replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
      
                // setState(() {});
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
        //update button
        floatingActionButton: FloatingActionButton.extended(
          elevation: 10,
          backgroundColor: Colors.amber,
          onPressed: () {
            if(_formkey.currentState!.validate()){
              _formkey.currentState!.save();
              APIs.updateUserInfo().then((value) {
                Dialogs.showSnacbar(context, 'Profile updated Succesfully', Colors.green);
              });
            }
          },
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
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.03,
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            mq.height * 0.1), // passing the half height
                        child: CachedNetworkImage(
                          width: mq.height * 0.20,
                          height: mq.height * 0.20,
                          fit: BoxFit.contain,
                          imageUrl: widget.user.image,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 90,
                        // right: 0,
                        child: MaterialButton(
                          elevation: 2,
                          shape: CircleBorder(),
                          color: Colors.amber,
                          onPressed: () {},
                          child: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
                      )
                    ],
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
                    onSaved: (val)=>APIs.me.name = val ?? '', // we will store the name or empty string in "val"
                    validator: (val)=>val != null && val.isNotEmpty ? null : 'Required Feild',
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
                    onSaved: (val)=>APIs.me.about = val ?? '', // we will store the name or empty string in "val"
                    validator: (val)=>val != null && val.isNotEmpty ? null : 'Required Feild',
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
          ),
        ),
      ),
    );
  }
}
