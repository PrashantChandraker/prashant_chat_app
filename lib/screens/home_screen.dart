import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.home,
          ),
          color: Colors.black,
        ),
        title: Text(
          'PC  Chat',
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
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
          // await APIs.auth.signOut();
          // await GoogleSignIn().signOut();
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
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          final list =
              []; // Creating an empty list to store the data from Firestore

          if (snapshot.hasData) {
            // Storing the data from snapshots in "data" to use further
            final data = snapshot.data?.docs;
            print(data);

            // Check if there is any data
            if (data!.isEmpty) {
              return Center(child: Text('No data found'));
            } else {
              // Loop through the data and add to list
              for (var i in data) {
                debugPrint('\nData: ${i.data()}'); // To print in debug console

                // Add the data to the list as a map
                list.add({
                  'name': i.data()['name'],
                  'about': i.data()['about'],
                });
              }

              return ListView.builder(
                padding: EdgeInsets.only(top: 3),
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // Retrieve the name and about for the current user
                  final user = list[index];
                  final name = user['name'];
                  final about = user['about'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: $name'),
                      Text('About: $about'),
                      SizedBox(height: 6),
                    ],
                  ); // It will print on screen the name and about
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Text nodata() {
    return Text('No data found');
  }
}
