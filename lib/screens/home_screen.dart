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
      appBar: AppBar(
        
        
   leading: Icon(CupertinoIcons.home),
       
        title: Text('PC  Chat',),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){},
        child: Icon(CupertinoIcons.chat_bubble_2),
        ),
        body: Text('data',style: TextStyle(fontWeight: FontWeight.w500),),
    );
  }
}