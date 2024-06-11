import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:prashant_chat_app/helpers/message.dart';
import 'package:prashant_chat_app/models/chat_user.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accesing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accesing cloud firestore database
  static FirebaseStorage storage = FirebaseStorage.instance;

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
        me = ChatUser.fromJson(user.data()!);
        debugPrint('\nMY Data: ${user.data()}');
      } else {
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

  // for getting all users from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    // we can use set() also instead of update() but set method used when there is no already value
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file exension
    final ext =
        file.path.split('.').last; // storing last extension after dot in "ext"
    debugPrint('\nExtension: $ext');
    //defining path to store the uploded image
    //storage file ref with path
    final ref = storage.ref().child(
        'Profile_pictures/${user.uid}.$ext'); // using user.uid to store unique images
    // pushig the file to the firebase

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      debugPrint(
          '\n Data Transfered: ${p0.bytesTransferred / 1000} kb'); // printing the transfered data in ad  of bytes
    });

    //updating image in firestore databse
    me.image =
        await ref.getDownloadURL(); // storng the download url in me.image
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  //for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  //update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({'is_online': isOnline, 'last_active': DateTime.now().millisecondsSinceEpoch.toString()});
  }

/*************************** Chat Screen related APIs ***************************/

  // chats (collection)  --> conversation_id (doc) --> messages (collection)  --> message (doc)

//useful for getting unique conversation id
  static String getConversationID(String id) => user.uid.hashCode <=
          id.hashCode // <= symbol will compare both uid and id hashcode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

//for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent',
            descending:
                true) // to reorder the chats upside down and ten we reverse the order in listview builder
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      ChatUser chatuser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send
    final Message message = Message(
        fromId: user.uid,
        msg: msg,
        toId: chatuser.id,
        read: '',
        type: type,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read staus of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true) // to get the senders last message
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file exension
    final ext =
        file.path.split('.').last; // storing last extension after dot in "ext"

    //defining path to store the uploded image
    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext'); // using user.uid to store unique images
    // pushig the file to the firebase

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      debugPrint(
          '\n Data Transfered: ${p0.bytesTransferred / 1000} kb'); // printing the transfered data in ad  of bytes
    });

    //updating image in firestore databse
    final imageUrl =
        await ref.getDownloadURL(); // storng the download url in me.image
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
