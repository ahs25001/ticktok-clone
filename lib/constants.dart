import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clon/models/comment_model.dart';
import 'package:tik_tok_clon/models/reel_model.dart';
import 'package:tik_tok_clon/views/screens/add_video_bottom_sheet.dart';
import 'package:tik_tok_clon/views/screens/search_page.dart';
import 'package:tik_tok_clon/views/screens/video_page.dart';

import 'models/user_model.dart';



/// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var fireStore = FirebaseFirestore.instance;
//get user collection



/// PAGES
List pages = [
  VideoPage(),
  SearchPage(),
  const AddVideoBottomSheet(),
  Text('Messages Screen'),
];
