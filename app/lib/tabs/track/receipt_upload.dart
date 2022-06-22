import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../config/style.dart';


class ReceiptUpload {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String thisUrl = "hello";

  String getImageURL() {
    return thisUrl;
  }

  Future<void> setImageURL() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    thisUrl = await storage.ref(destination).child('file/').getDownloadURL();
  }

  Future getFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 10);

    // setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        // print('No image selected.');
      }
    // });
  }

  Future getFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    // setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        // print('No image selected.');
      }
    // });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      await setImageURL();
    } catch (e) {
      // print('error occurred');
    }
  }

  // @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          imagePicker(context);
        },
        child: Container(
            height: 40,
            width: 500,
            color: Colors.grey,
            child: const Text(
              "Upload receipt",
              style: ordinaryStyle,
              textAlign: TextAlign.center,
            )));

  }

  void imagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getFromGallery();
                      // Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getFromCamera();
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
