import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raftl_app/screens/add_post_screen.dart';
import 'package:raftl_app/screens/feed_screen.dart';
import 'package:raftl_app/screens/profile_screen.dart';
import 'package:raftl_app/screens/search_screen.dart';

import '../screens/graphql_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const GraphQLPage(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
