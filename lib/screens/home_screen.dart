import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prashant_chat_app/api/apis.dart';
import 'package:prashant_chat_app/models/chat_user.dart';
import 'package:prashant_chat_app/screens/profile_screen.dart';
import 'package:prashant_chat_app/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list =
      []; // Creating an empty list to store the data from Firestore= store users

  // for toring searched items
  final List<ChatUser> _searchList = [];

// for storing search status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: _isSearching ? false : true,
        onPopInvoked: (didpop) {
          // if search is on and back button is pressed then close search
          // or else simple close current screen on back button click

          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching; // setted value false
            });
            true; //close current screen on back button click
          } else {
            false; //if search is on and back button is pressed then close search
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          //appbar
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.home,
              ),
              color: Colors.black,
            ),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, Email...',
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 18, letterSpacing: 1.5),
                    // when search text changes than update search list
                    onChanged: (val) {
                      //seach logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text(
                    'PC  Chat',
                  ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching ? CupertinoIcons.clear_circled : Icons.search,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          user: APIs.me,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  )),
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff5ff1f5),
            onPressed: () async {
              // trial to check logout function is working or not
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              setState(() {});
            },
            child: Icon(
              CupertinoIcons.plus_bubble_fill,
              color: Colors.black,
              size: 25,
            ),
          ),
          body: StreamBuilder(
            // This stream will take data from Firestore collection and it will give data to the ListView builder
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // if the data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                // if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:

                  // Storing the data from snapshots in "data" to use further
                  final data = snapshot.data?.docs;

                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 3),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // Retrieve the name and about for the current user
                        // final user = list[index];
                        // final name = user['name'];
                        // final about = user['about'];

                        return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
                        // return Text(
                        //     'Name: ${list[index]}'); // It will print on screen the name and about
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      'No Data found!',
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
