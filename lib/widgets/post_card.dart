import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproj/models/user.dart' as model;
import 'package:firebaseproj/providers/user_provider.dart';
import 'package:firebaseproj/resources/firestore_methods.dart';
import 'package:firebaseproj/screens/commentScreen.dart';
import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/utils/utils.dart';
import 'package:firebaseproj/widgets/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  final bool subsnap;
  const PostCard({super.key, required this.snap, required this.subsnap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool islikeAnimating = false;
  int _commentLength = 0;
  bool isSaved = false;
  bool isSavedClicked = false;

  @override
  void initState() {
    super.initState();
    getCmtLen();
  }

  void getCmtLen() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection("comments")
          .get();

      setState(() {
        _commentLength = snapshot.docs.length;
      });
    } catch (err) {
      showSnakBar(context, err.toString());
    }
  }

  void deletePost() async {
    String res = await FirestoreMethods().deletePost(widget.snap['postId']);
    showSnakBar(context, res);
  }

  _showOptionsgg(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('What do you like to do?'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                deletePost();
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        //HeaderSection
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snap["profImg"]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.snap["username"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => _showOptionsgg(context),
                  icon: const Icon(Icons.more_vert))
            ],
          ),
        ),
        //ImageSection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().updateLikes(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                islikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: FancyShimmerImage(
                  imageUrl: widget.snap["postUrl"],
                  boxFit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: islikeAnimating ? 1 : 0,
                child: LikeAnimation(
                    isAnimating: islikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        islikeAnimating = false;
                      });
                    },
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    )),
              )
            ]),
          ),
        ),
        //BottomSection
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().updateLikes(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommentScreen(
                    snap: widget.snap,
                  );
                })),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () async {
                          FirestoreMethods().savePosts(
                            widget.snap['postId'],
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.snap['username'],
                            widget.snap['description'],
                            widget.snap['postUrl'],
                          );
                          setState(() {
                            isSavedClicked = true;
                          });
                        },
                        icon: widget.subsnap || isSavedClicked
                            ? const Icon(
                                Icons.bookmark_added,
                                color: Colors.red,
                              )
                            : const Icon(Icons.bookmark_border_outlined),
                      )))
            ],
          ),
        ),
        //Description and likes
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.snap["likes"].length} likes",
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                width: double.infinity,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "  ${widget.snap['description']}",
                    ),
                  ]),
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "View all $_commentLength comments",
                    style: const TextStyle(color: secondaryColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(color: secondaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
