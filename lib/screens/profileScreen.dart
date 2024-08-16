import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproj/resources/auth_method.dart';
import 'package:firebaseproj/resources/firestore_methods.dart';
import 'package:firebaseproj/screens/loginscreen.dart';
import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/utils/utils.dart';
import 'package:firebaseproj/widgets/follow_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};

  int postLength = 0;
  int followers = 0;
  int followings = 0;
  bool isUserLoading = false;
  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
    getUserdata();
  }

  getUserdata() async {
    try {
      setState(() {
        isUserLoading = true;
      });
      var snapUser = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      var snapPost = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();

      setState(() {
        userData = snapUser.data()!;

        followers = snapUser.data()!['followers'].length;
        followings = snapUser.data()!['following'].length;
        postLength = snapPost.docs.length;
        isFollowing = snapUser
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
        isUserLoading = false;
      });
    } catch (err) {
      showSnakBar(context, err.toString());
      isUserLoading = false;
    }
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUserLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLength, "posts"),
                                    buildStatColumn(followings, "followings"),
                                    buildStatColumn(followers, "followers"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundcolor:
                                                mobileBackgroundColor,
                                            bordercolor: Colors.grey,
                                            text: "Sign Out",
                                            textcolor: primaryColor,
                                            function: () async {
                                              await AuthMethod().signTfOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                return const LoginScreen();
                                              }));
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundcolor: Colors.grey,
                                                bordercolor: Colors.grey,
                                                text: "Unfollow",
                                                textcolor: primaryColor,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundcolor: Colors.blue,
                                                bordercolor: Colors.blue,
                                                text: "Follow",
                                                textcolor: primaryColor,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemCount: postLength,
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap = snapshot.data!.docs[index];
                            return Image.network(
                              snap['postUrl'],
                              fit: BoxFit.cover,
                            );
                          });
                    })
              ],
            ),
          );
  }
}
