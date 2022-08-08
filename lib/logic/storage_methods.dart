import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // add image to firebase storage

  Future<String> uploadPic(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    Reference ref =
        storage.ref().child(childName).child(firebaseAuth.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    // uploadtask: the ability to control how our file is being uploaded to storage
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    debugPrint(downloadUrl);

    return downloadUrl;
  }
}
