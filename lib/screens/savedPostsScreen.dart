import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/widgets/savepost_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Savedpostsscreen extends StatefulWidget {
  const Savedpostsscreen({super.key});

  @override
  State<Savedpostsscreen> createState() => _SavedpostsscreenState();
}

class _SavedpostsscreenState extends State<Savedpostsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Saved Posts"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("savedPosts")
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
                return SavepostCard(
                  snap: snapshot.data!.docs[index].data(),
                );
              });
        },
      ),
    );
  }
}
