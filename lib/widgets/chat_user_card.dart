import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width*0.02, vertical: mq.height*0.005),
      color: Colors.white,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // user profile picture
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
         
          // user name
          title: Text('Prahant Chandraker', maxLines: 1,),
         
          // last mesage time
          subtitle: Text('Last user message', maxLines: 1,),

          //last message time
          trailing: Text(
            '12:00 PM',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
