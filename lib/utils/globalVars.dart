import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/screens/add_post_screen.dart';
import 'package:social_media/screens/feed_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/screens/search_scree.dart';

const webscreensize = 600;

final homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  Text("favorite"),
  AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
