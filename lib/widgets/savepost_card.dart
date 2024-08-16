import 'package:firebaseproj/resources/firestore_methods.dart';
import 'package:firebaseproj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SavepostCard extends StatefulWidget {
  final snap;
  const SavepostCard({super.key, this.snap});

  @override
  State<SavepostCard> createState() => _SavepostCardState();
}

class _SavepostCardState extends State<SavepostCard> {
  void unSavePost() async {
    String res = await FirestoreMethods()
        .unsavePost(widget.snap['postId'], widget.snap['uid']);
    showSnakBar(context, res);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: ClipRRect(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the border radius as needed
          child: Image.network(
            widget.snap['postUrl'],
            width: 100, // Adjust the width as needed
            height: 100, // Adjust the height as needed
            fit: BoxFit.cover, // Ensure the image covers the container
          ),
        ),
        title: Text(widget.snap['username']),
        subtitle: Text(widget.snap['caption']),
        trailing: IconButton(
          onPressed: () {
            unSavePost();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
