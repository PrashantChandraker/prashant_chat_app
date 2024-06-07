import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prashant_chat_app/main.dart';
import 'package:prashant_chat_app/models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when touch anywhere
     onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  // This stream will take data from Firestore collection and it will give data to the ListView builder
                  stream: null,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // if the data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return Center(
                      //   child: CircularProgressIndicator(),
                      // );
                
                      // if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                
                        // Storing the data from snapshots in "data" to use further
                
                        // final data = snapshot.data?.docs;
                        // _list =
                        //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        //         [];
                
                        final _list = [];
                
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 3),
                            itemCount: _list.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              // Retrieve the name and about for the current user
                              // final user = list[index];
                              // final name = user['name'];
                              // final about = user['about'];
                
                              return Text(
                                  'Message: ${_list[index]}'); // It will print on screen the name and about
                            },
                          );
                        } else {
                          return Center(
                              child: Text(
                            'Say Hii...👋',
                            style: TextStyle(fontSize: 20),
                          ));
                        }
                    }
                  },
                ),
              ),
              _chatInput()
            ],
          ),
        ),
      ),
    );
  }

  //app bar widget
  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff5cfaad), Color(0xff5ff1f5)],
          ),
        ),
        child: Row(
          children: [
            //back button
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            //user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  mq.height * 0.3), // passing the half height
              child: CachedNetworkImage(
                width: mq.height * 0.050,
                height: mq.height * 0.050,
                imageUrl: widget.user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //username
                Text(
                  widget.user.name,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 3,
                ),
                //lastseen
                Text(
                  'Last seen not avialable',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // bottom chat input feild
  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.lightBlue,
                    ),
                  ),

                  Expanded(
                      child: TextField(
                        // scrollPhysics: AlwaysScrollableScrollPhysics(),
                    keyboardType: TextInputType.multiline,
                     maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  )),
                  //take image from gallery button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.photo,
                      color: Colors.lightBlue,
                    ),
                  ),
                  //take image from camera
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //send messsage button
          MaterialButton(
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
            onPressed: () {},
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
            ),
            color: Colors.green,
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }
}
