import 'dart:typed_data';

import 'package:firebaseproj/models/user.dart' as model;
import 'package:firebaseproj/providers/user_provider.dart';

import 'package:firebaseproj/resources/firestore_methods.dart';

import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;

  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  _selectImg(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Add Post Image"),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickAnImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Select from Camera"),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickAnImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Select from Gallery"),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionController.dispose();
  }

  void addPost(String uid, String username, String profImg) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(_captionController.text, _file!, uid, username, profImg);
      if (res == "success") {
        showSnakBar(context, "Post Added");
        setState(() {
          _isLoading = false;
        });
        clearImg();
      } else {
        showSnakBar(context, res.toString());
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      showSnakBar(context, err.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void clearImg() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User _user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImg(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back), onPressed: clearImg
                  // await FirebaseAuth.instance.signOut();
                  // Navigate to login screen after logout
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //       builder: (context) => const LoginScreen()),
                  // );

                  ),
              title: Text("Add Post"),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        addPost(_user.uid, _user.username, _user.photoUrl),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_user.photoUrl),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _captionController,
                          decoration: const InputDecoration(
                            hintText: "Enter Post Caption Here",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: Container(
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: MemoryImage(_file!))),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          );
  }
}
