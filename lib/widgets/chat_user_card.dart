import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/message.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prashant_chat_app/screens/chat_screen.dart';
import 'package:prashant_chat_app/widgets/dialogs/profile_dialogs.dart';

import '../helpers/my_date_util.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty) _message = list[0];
                return ListTile(
                  // user profile picture
                  // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                  leading: InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (_)=> ProfileDialog(user: widget.user,));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          mq.height * 0.3), // passing the half height
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
                  ),
                  // user name
                  title: Text(
                    widget.user.name,
                    maxLines: 1,
                  ),

                  // last mesage 
                  subtitle: Text(
                    _message != null ? 
                        _message!.type == Type.image ? 'Image Recived' :
                    _message!.msg : 

                    widget.user.about,
                    maxLines: 1,
                  ),

                  //last message time
                  trailing: _message == null
                      ? null //show nothing when no mesage is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ? 
                          //show for unread message
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                            )
                          : 
                          //message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                              style: TextStyle(color: Colors.black54),
                            ),
                );
              })),
    );
  }
}
