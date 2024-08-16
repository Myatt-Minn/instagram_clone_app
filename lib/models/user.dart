import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List followings;
  final List savePosts;

  const User({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.followers,
    required this.followings,
    required this.savePosts,
  });

  Map<String, dynamic> convertJson() => {
        "username": username,
        "bio": bio,
        "uid": uid,
        "email": email,
        "followers": followers,
        "following": followings,
        "savePosts": savePosts,
        "photoUrl": photoUrl,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
        username: snap["username"],
        email: snap["email"],
        bio: snap["bio"],
        uid: snap["uid"],
        photoUrl: snap["photoUrl"],
        followers: snap["followers"] ?? [],
        followings: snap["followings"] ?? [],
        savePosts: snap["savePosts"] ?? []);
  }
}
