import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String postId;
  final datePublished;
  final String uid;
  final String description;
  final String postUrl;
  final String profImg;
  final List likes;
  const Post(
      {required this.username,
      required this.postId,
      required this.datePublished,
      required this.uid,
      required this.description,
      required this.postUrl,
      required this.profImg,
      required this.likes});

  Map<String, dynamic> convertJson() => {
        "username": username,
        "description": description,
        "uid": uid,
        "postId": postId,
        "profImg": profImg,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = (snapshot.data() as Map<String, dynamic>);

    return Post(
      username: snap["username"],
      description: snap["description"],
      postId: snap["postId"],
      uid: snap["uid"],
      datePublished: snap["datePublished"],
      postUrl: snap["postUrl"],
      profImg: snap["profImg"],
      likes: snap['likes'] ?? [],
    );
  }
}
