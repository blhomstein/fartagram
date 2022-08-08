import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/logic/storage_methods.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/utils/urils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String userName, String profImage) async {
    String response = "some error occured";
    try {
      String photoUrl = await StorageMethods().uploadPic("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection("posts").doc(postId).set(post.toJson());
      response = "success";
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String userName, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          "userName": userName,
          "uid": uid,
          "text": text,
          'commentId': commentId,
          "datePublished": DateTime.now()
        });
      } else {
        print("text is empty a3mo");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //delete post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
