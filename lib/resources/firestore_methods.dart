import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseproj/models/post.dart';
import 'package:firebaseproj/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImg,
  ) async {
    String res = "Something went wrong";
    try {
      String photoUrl = await StorageMethod()
          .uploadImgToStorage(childname: "posts", file: file, isPost: true);

      String postId = Uuid().v1();

      Post post = Post(
          username: username,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          description: description,
          postUrl: photoUrl,
          profImg: profImg,
          likes: []);

      await _firebaseFirestore
          .collection("posts")
          .doc(postId)
          .set(post.convertJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> updateLikes(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> addComment(String postId, String text, String uid,
      String username, String userprofile) async {
    String res = "Something went wrong";
    try {
      if (text.isNotEmpty) {
        final String cmtId = const Uuid().v1();
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(cmtId)
            .set({
          "userprofile": userprofile,
          "username": username,
          "uid": uid,
          "text": text,
          "commentId": cmtId,
          "datePublished": DateTime.now(),
        });
        res = "success";
      } else {
        res = "Please enter your comment first";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Something went wrong";
    try {
      await _firebaseFirestore.collection("posts").doc(postId).delete();
      res = "Post Deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection("users").doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];

    if (following.contains(followId)) {
      await _firebaseFirestore.collection("users").doc(followId).update({
        "followers": FieldValue.arrayRemove([uid])
      });
      await _firebaseFirestore.collection("users").doc(uid).update({
        "following": FieldValue.arrayRemove([followId])
      });
    } else {
      await _firebaseFirestore.collection("users").doc(followId).update({
        "followers": FieldValue.arrayUnion([uid])
      });
      await _firebaseFirestore.collection("users").doc(uid).update({
        "following": FieldValue.arrayUnion([followId])
      });
    }
  }

  Future<void> savePosts(String postId, String uid, String username,
      String caption, String postUrl) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("savedPosts")
          .doc(postId)
          .set({
        "postUrl": postUrl,
        "caption": caption,
        "uid": uid,
        "username": username,
        "postId": postId,
        "dateSaved": DateTime.now(),
      });
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> unsavePost(String postId, String uid) async {
    String res = "Something went wrong";
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("savedPosts")
          .doc(postId)
          .delete();
      res = "Post Unsaved";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
