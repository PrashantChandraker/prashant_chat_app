import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:prashant_chat_app/screens/view_profile_screen.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SizedBox(
        width: mq.width * 0.6,
        height: mq.height * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user: user)));
                  },
                  icon: Icon(Icons.info_outline),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  mq.height * 0.25), // passing the half height
              child: CachedNetworkImage(
                width: mq.height * 0.5,
                // height: mq.height * 0.20,
                fit: BoxFit.cover,
                imageUrl: user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
