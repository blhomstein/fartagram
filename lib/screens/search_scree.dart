import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isUsersShown = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: "search for a user",
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isUsersShown = true;
            });
          },
        ),
      ),
      body: isUsersShown
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("userName",
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } //snapshot.data!.docs.length
                print((snapshot.data as dynamic).docs.length);
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]["uid"],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                        ),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ['userName']),
                      ),
                    );
                  },
                );
              },
            )
          : Text("posts"),
    );
  }
}
