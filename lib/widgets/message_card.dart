import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/message.dart';
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
    return APIs.user.uid == widget.message.formId
        ? _greenMessage()
        : _blueMessage();
  }

  //semder or another user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomRight: Radius.circular(22)),
                border: Border.all(color: Colors.black)),
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: Text(
                widget.message.msg +
                    ' I am prasahnt chandraker what is your name',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        // message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            widget.message.sent,
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
            Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 17,
            ),

            // for adding some space
            SizedBox(
              width: 3,
            ),

            // read time
            Text(
              widget.message.read + '12:05 PM',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        //message content
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    topLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22)),
                border: Border.all(
                  color: Colors.black,
                )),
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: Text(
                widget.message.msg +
                    ' I am prashant chandraker what is your name',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
