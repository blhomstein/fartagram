import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/logic/firestore_methods.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/utils/colors.dart';
import 'package:social_media/utils/urils.dart';
import 'package:social_media/models/user.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String userName, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String response = await FirestoreMethods().uploadPost(
          descriptionController.text, _file!, uid, userName, profImage);
      if (response == "success") {
        showSnackBar(context, "posted !!");
        setState(() {
          _isLoading = false;
        });
        clearImage();
      } else {
        showSnackBar(context, response);
        _isLoading = false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                    print("file 1 hoa hadak");
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    print("file 2 hoa hadak");
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(
                Icons.upload,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("post to "),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.userName, user.photoUrl),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: const Text(
                      "post",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 0),
                      ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
