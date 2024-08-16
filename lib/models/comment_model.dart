import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  String reelId;
  final datePublished;
  List likes;
  String profilePhoto;
  String uid;
  String? id;

  CommentModel({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.reelId,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'reelId': reelId,
        'likes': likes,
        'datePublished': datePublished,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
      };

  CommentModel.fromJson(Map<String, dynamic> json)
      : this(
          username: json['username'],
          comment: json['comment'],
          reelId: json['reelId'],
          likes: json['likes'],
          datePublished: json['datePublished'],
          profilePhoto: json['profilePhoto'],
          uid: json['uid'],
          id: json['id'],
        );
}
