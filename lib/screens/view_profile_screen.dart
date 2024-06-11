import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/my_date_util.dart';
import 'package:prashant_chat_app/models/chat_user.dart';

import '../main.dart';

// to view profile screen of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when tap other place
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
        widget.user.name,
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
        floatingActionButton:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Text('🗓️ Joined On: ',style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),),
                     Text(
                      MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                                     ),
                   ],
                 ),
       
        
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * 0.03,
              ),
              //user profile picture
              _image != null
                  ?
                  //local image
                  ClipRRect(
                      borderRadius: BorderRadius.circular(
                          mq.height * 0.1), // passing the half height
                      child: Image.file(
                        File(_image!),
                        width: mq.height * 0.20,
                        height: mq.height * 0.20,
                        fit: BoxFit.cover,
                      ),
                    )
                  :
              
                  //image from server
                  ClipRRect(
                      borderRadius: BorderRadius.circular(
                          mq.height * 0.1), // passing the half height
                      child: CachedNetworkImage(
                        width: mq.height * 0.20,
                        height: mq.height * 0.20,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
              SizedBox(
                height: mq.height * 0.03,
              ),
              Text(
                '📬 ${widget.user.email}',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              SizedBox(
                height: mq.height * 0.03,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Text('📜 About: ',style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),),
                   Text(
                    widget.user.about,
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                                   ),
                 ],
               ),
              
             
            ],
          ),
        ),
      ),
    );
  }
}
