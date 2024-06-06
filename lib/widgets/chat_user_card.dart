import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prashant_chat_app/screens/chat_screen.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * 0.02, vertical: mq.height * 0.005),
      color: Colors.white,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));
        },
        child: ListTile(
          // user profile picture
          // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*0.3), // passing the half height 
            child: CachedNetworkImage(
              width: mq.height * 0.055,
              height: mq.height * 0.055,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          // user name
          title: Text(
            widget.user.name,
            maxLines: 1,
          ),

          // last mesage time
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          //last message time
          trailing: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}
