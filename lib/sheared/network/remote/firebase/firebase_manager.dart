import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../constants.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/reel_model.dart';
import '../../../../models/user_model.dart';

class FirebaseManager {
  /// Firebase FireStore
  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("User")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

// get comment collection
  static CollectionReference<CommentModel> getCommentCollection() {
    return FirebaseFirestore.instance
        .collection("Comment")
        .withConverter<CommentModel>(
      fromFirestore: (snapshot, options) {
        return CommentModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

// get comment by reel id
  static Stream<QuerySnapshot<CommentModel>> getCommentsById(String reelId) {
    var snapShot =
        getCommentCollection().where("reelId", isEqualTo: reelId).snapshots();
    return snapShot;
  }

// add comment
  static void addComment(CommentModel commentModel) {
    var docRef = getCommentCollection().doc();
    commentModel.id = docRef.id;
    docRef.set(commentModel);
  }

// get reel collection
  static CollectionReference<ReelModel> getReelCollection() {
    return FirebaseFirestore.instance
        .collection("Reel")
        .withConverter<ReelModel>(
      fromFirestore: (snapshot, options) {
        return ReelModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

//get reels by user ID
  static Future<List<ReelModel>> getReelsByUserId(String uid) async {
    var collection = getReelCollection();
    var data = await collection.where('uid', isEqualTo: uid).get();
    var reels = data.docs
        .map(
          (e) => e.data(),
        )
        .toList();
    return reels;
  }

// get reel by id
  static Future<ReelModel?> getReelById(String id) async {
    var collection = getReelCollection();
    var data = await collection.doc(id).get();
    var reel = data.data();

    return reel;
  }

//get user by ID
  static Future<UserModel?> getUserById(String id) async {
    var collection = getUserCollection();
    var snapshot = await collection.doc(id).get();
    return snapshot.data();
  }

// update user
  static Future<void> upDateUser(UserModel newUser) async {
    var collection = getUserCollection();
    await collection.doc(newUser.id).update(newUser.toJson());
  }

//add user to firebase
  static Future<void> addUser(UserModel user) async {
    var douRef = getUserCollection().doc(user.id);
    await douRef.set(user);
  }

  //get user by name
  static Future<List<UserModel>> getUserByName(String name) async {
    var collection = getUserCollection();
    var data = await collection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf7ff')
        .get();
    List<UserModel> users = data.docs
        .map(
          (e) => e.data(),
        )
        .toList();
    return users;
  }

  /// Firebase Storage
 static Future<String> uploadFile(File file) async {
    Reference ref = firebaseStorage.ref().child(file.path);
    TaskSnapshot snapshot = await ref.putFile(file);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
