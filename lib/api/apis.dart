import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:prashant_chat_app/models/chat_user.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accesing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for storing self information
  static late ChatUser me;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking if user exsits or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for checking if user exsits or not
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {

      if (user.exists) {
        me=ChatUser.fromJson(user.data()!);
        debugPrint('\nMY Data: ${user.data()}');
      }else{
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        // getting the data names from debug console which we are getting from print method in "login.dart"
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey i am using PC Chat",
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        email: user.email.toString(),
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting al users from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}
