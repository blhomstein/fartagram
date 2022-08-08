import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/logic/storage_methods.dart';
import 'package:social_media/models/user.dart' as userModel;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get the user details for provider

  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return userModel.User.fromSnap(snap);
  }

  //sign up function

  Future<String?> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String response = "some error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            await StorageMethods().uploadPic("profilePics", file, false);
        debugPrint(photoUrl);
        debugPrint("kolshy hoa hadak1234");
        // add user to our database
        userModel.User user = userModel.User(
            userName: userName,
            bio: bio,
            email: email,
            password: password,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            followers: [],
            following: []);
        print(cred.user!.email);
        //add user to db
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        response = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        response =
            "the email format is invalid, please provide valid email address";
      } else if (err.code == "weak-password") {
        response = "the password is too weak";
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String response = "some error has occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        response = "success";
      } else {
        response = "please enter all the required field";
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
