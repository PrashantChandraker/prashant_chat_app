import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prashant_chat_app/models/chat_user.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accesing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking if user exsits or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(user.uid)
            .get())
        .exists;
  }

  // for creating a new user
  static Future<void> createUser() async {

    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      // getting the data names from debug console which we are getting from print method in "login.dart"
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey i am usin PC Chat",
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
}
