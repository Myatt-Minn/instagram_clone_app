import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseproj/models/user.dart';
import 'package:firebaseproj/providers/user_provider.dart';
import 'package:firebaseproj/resources/firestore_methods.dart';
import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/utils/utils.dart';
import 'package:firebaseproj/widgets/cmt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentcontroller = TextEditingController();

  void addComment(String username, String uid, String profilepic) async {
    try {
      String res = await FirestoreMethods().addComment(widget.snap['postId'],
          _commentcontroller.text, uid, username, profilepic);
      if (res == "success") {
        showSnakBar(context, "Comment Added");
      } else {
        showSnakBar(context, res.toString());
      }
    } catch (err) {
      showSnakBar(context, err.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments")
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CmtCard(snap: snapshot.data!.docs[index].data());
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 8),
                child: TextField(
                  controller: _commentcontroller,
                  decoration: const InputDecoration(
                    hintText: "Enter your comment..",
                    border: InputBorder.none,
                  ),
                ),
              )),
              InkWell(
                onTap: () {
                  addComment(user.username, user.uid, user.photoUrl);
                  setState(() {
                    _commentcontroller.text = "";
                  });
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
