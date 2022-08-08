import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/logic/firestore_methods.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/utils/colors.dart';
import 'package:social_media/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection("comments")
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 16),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "comment as ${user.userName}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                  onTap: () async {
                    await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      commentController.text,
                      user.uid,
                      user.userName,
                      user.photoUrl,
                    );
                    setState(() {
                      commentController.text = "";
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'post',
                      style: TextStyle(
                        color: blueColor,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
