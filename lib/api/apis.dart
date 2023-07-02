import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // auth instance
  static FirebaseAuth auth = FirebaseAuth.instance;

  // firestore instance
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // firebase storage instance
  static FirebaseStorage storage = FirebaseStorage.instance;

  //to return current user
  static User get user => auth.currentUser!;

  // for storing self info
  static late ChatUser me;

  //for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for checking the user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      about: "Hey! I am using Chat App",
      email: user.email.toString(),
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //getting all user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for checking the user exists or not
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update(
      {'name': me.name, 'about': me.about},
    );
  }

  // for updating the user profile picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    //upload the file
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
      (p0) {
        // print('${p0.bytesTransferred / 1000}kb');
      },
    );
    me.image = await ref.getDownloadURL();
    // set image path in users data
    await firestore.collection('users').doc(user.uid).update(
      {'image': me.image},
    );
  }
}
