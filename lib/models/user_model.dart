class UserModel {
  String? email;
  String? name;
  String? image;
  String? id;
  List following;
  List followers;
  List likes;

  UserModel(
      {this.email,
      this.name,
      this.image,
      this.id,
      required this.followers,
      required this.likes,
      required this.following});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          email: json["email"],
          id: json["id"],
          name: json["name"],
          image: json["image"],
          followers: json["followers"],
          following: json["following"],
          likes: json["likes"],
        );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
        "image": image,
        "following": following,
        "followers": followers,
        "likes": likes
      };
}
