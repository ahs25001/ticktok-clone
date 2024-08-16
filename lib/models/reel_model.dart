
class ReelModel {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  // String profilePhoto;

  ReelModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    // required this.profilePhoto,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        // "profilePhoto": profilePhoto,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  ReelModel.fromJson(Map<String, dynamic> json)
      : this(
          username: json['username'],
          uid: json['uid'],
          id: json['id'],
          likes: json['likes'],
          commentCount: json['commentCount'],
          shareCount: json['shareCount'],
          songName: json['songName'],
          caption: json['caption'],
          videoUrl: json['videoUrl'],
          // profilePhoto: json['profilePhoto'],
          thumbnail: json['thumbnail'],
        );
}
