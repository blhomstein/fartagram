import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String password;
  final String bio;
  final List followers;
  final List following;

  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.userName,
      required this.password,
      required this.bio,
      required this.followers,
      required this.following});
  // convert whatever user object we require from constructor to an object
  Map<String, dynamic> toJson() => {
        'userName': userName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "password": password
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      userName: snapshot["userName"],
      email: snapshot["email"],
      password: snapshot["password"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
