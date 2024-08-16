import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproj/screens/addPostScreen.dart';
import 'package:firebaseproj/screens/feedScreen.dart';
import 'package:firebaseproj/screens/profileScreen.dart';
import 'package:firebaseproj/screens/savedPostsScreen.dart';
import 'package:firebaseproj/screens/searchScreen.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const Searchscreen(),
  const AddPostScreen(),
  const Savedpostsscreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
