import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String userName;
  final datePublished;
  final likes;
  final String postUrl;
  final String profImage;

  Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.profImage,
    required this.userName,
  });
  // convert whatever user object we require from constructor to an object
  Map<String, dynamic> toJson() => {
        'userName': userName,
        "uid": uid,
        "postId": postId,
        "postUrl": postUrl,
        "likes": likes,
        "profImage": profImage,
        "datePublished": datePublished,
        "description": description
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      userName: snapshot["userName"],
      postId: snapshot["postId"],
      postUrl: snapshot["postUrl"],
      uid: snapshot["uid"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
      description: snapshot["description"],
      profImage: snapshot["profImage"],
    );
  }
}
