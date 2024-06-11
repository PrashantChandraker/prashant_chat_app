import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/message.dart';
import 'package:prashant_chat_app/helpers/my_date_util.dart';
import 'package:prashant_chat_app/main.dart';

class Messagecard extends StatefulWidget {
  const Messagecard({super.key, required this.message});

  final Message message;

  @override
  State<Messagecard> createState() => _MessagecardState();
}

class _MessagecardState extends State<Messagecard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //semder or another user message
  Widget _blueMessage() {
    //update last read message if sender and reciver are diffirent
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);

      debugPrint('message card ---------- \nMessage read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.01),
            decoration:  BoxDecoration(
                color: widget.message.type == Type.image
                    ? Colors.transparent
                    : Colors.blue.shade200,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    // topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)
                    ),
                border: widget.message.type == Type.image
                    ? Border.all(
                        color: Colors.transparent,
                      )
                    : Border.all(
                        color: Colors.black,
                      )),
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: widget.message.type == Type.text
                  ?

                  //show text
                  Text(
                      widget.message.msg,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        imageUrl: widget.message.msg,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported,
                          size: 70,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        // message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }








  //our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message time
        Row(
          children: [
            // for adding space
            SizedBox(
              width: 10,
            ),
            // double tick, blue icon for messge read
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 17,
              ),

            // for adding some space
            SizedBox(
              width: 3,
            ),

            // sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        //message content
        Flexible(
          child: Container(
            // padding: EdgeInsets.all(widget.message.type == Type.image ? -0.2 :0),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
                color: widget.message.type == Type.image
                    ? Colors.transparent
                    : Colors.green.shade200,
                borderRadius: BorderRadius.only(
                    // topRight: Radius.circular(15),
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)
                    ),
                border: widget.message.type == Type.image
                    ? Border.all(
                        color: Colors.transparent,
                      )
                    : Border.all(
                        color: Colors.black,
                      )),
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: widget.message.type == Type.text
                  ?

                  //show text
                  Text(
                      widget.message.msg,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        imageUrl: widget.message.msg,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported,
                          size: 70,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
