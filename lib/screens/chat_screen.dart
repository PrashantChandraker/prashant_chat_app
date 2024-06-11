import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/helpers/message.dart';
import 'package:prashant_chat_app/helpers/my_date_util.dart';
import 'package:prashant_chat_app/main.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:prashant_chat_app/screens/view_profile_screen.dart';
import 'package:prashant_chat_app/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages
  List<Message> _list = [];
  // for handling message text changes
  final _textcontroller = TextEditingController();

  // //for storing value of showing or hiding emoji
  // bool _showEmoji = false;
  bool _isImageUploading =
      false; //to check image is uploading or not from gallery
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when touch anywhere
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 227, 244, 246),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  // This stream will take data from Firestore collection and it will give data to the ListView builder
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // if the data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                          child: SizedBox(),
                        );

                      // if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:

                        // Storing the data from snapshots in "data" to use further

                        final data = snapshot.data?.docs;

                        //print method for gtting the data in json format and then we convert to dart format
                        // debugPrint('\nData: ${jsonEncode(data![0].data())}');
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        //for dummy data
                        // _list.clear(); // to clear the older
                        // _list.add(Message(formId: APIs.user.uid, msg: 'hii', toId: 'Maine bheja', read: '', type: Type.text, sent: '12:00 AM'));

                        // _list.add(Message(formId: 'Maine bheja', msg: 'Hello', toId: APIs.user.uid, read: '', type: Type.text, sent: '12:05 AM'));

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse:
                                true, // so that we dont need to scroll to bottom for chats
                            padding: EdgeInsets.only(top: 3),
                            itemCount: _list.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              // Retrieve the name and about for the current user
                              // final user = list[index];
                              // final name = user['name'];
                              // final about = user['about'];

                              return Messagecard(
                                message: _list[index],
                              ); // It will print on screen the name and about
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
              if (_isImageUploading) // is image is uploading then it will be called
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )),

              //chat input feild
              _chatInput(),

              //emojis will be placed here
            ],
          ),
        ),
      ),
    );
  }

  //app bar widget
  Widget _appbar() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user: widget.user),),);
      },
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xff5cfaad), Color(0xff5ff1f5)],
            ),
          ),
          child: StreamBuilder(
              stream: APIs.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                
                return Row(
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
                        imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
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
                         list.isNotEmpty? list[0].name : widget.user.name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        //lastseen time of the user
                        Text(
                          list.isNotEmpty ? 
                          list[0].isOnline ? 'Online' :
                          MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive) : 
                          
                          MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                );
              })),
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
              color: const Color.fromARGB(255, 227, 232, 242),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _showEmoji = !_showEmoji;
                  //     });
                  //   },
                  //   icon: Icon(
                  //     Icons.emoji_emotions,
                  //     color: Colors.lightBlue,
                  //   ),
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textcontroller,
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
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick multiple images.
                      final List<XFile> images = await picker.pickMultiImage();

                      //uploading and sending imagesone by one
                      for (var i in images) {
                        setState(() {
                          _isImageUploading = true;
                        });
                        debugPrint('Image path: ${i.path}');
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          _isImageUploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.photo,
                      color: Colors.lightBlue,
                    ),
                  ),
                  //take image from camera
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        debugPrint('Image path: ${image.path}');
                        setState(() {
                          _isImageUploading = true;
                        });

                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() {
                          _isImageUploading = false;
                        });

                        // for hiding bottom sheet
                        // Navigator.pop(context);
                      }
                    },
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
            onPressed: () {
              if (_textcontroller.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textcontroller.text, Type.text);
                _textcontroller.text = '';
              }
            },
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
