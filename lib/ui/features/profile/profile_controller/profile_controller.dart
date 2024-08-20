import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';

class ProfileController extends GetxController {
  var profileImageUrl = ''.obs;
  var username = ''.obs;
  var status = ''.obs;
  UserModel? userModel;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    refresh();
  }

  Future<void> fetchUserData() async {
    username.value = await getSharedPrefsSavedString('myUsername') ?? '';
    if (username.value.isNotEmpty) {
      final userRef = FirebaseDatabase.instance.ref().child('users/${encodeUsername(username.value)}');
      DatabaseEvent event = await userRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        userModel = UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
        profileImageUrl.value = userModel?.imageUrl ?? '';
        status.value = userModel?.status ?? '...';
      }
    }
  }

  Future<void> chooseProfileImageSource(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  uploadProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  uploadProfileImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> uploadProfileImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = '${username.value}_${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the URL to the database
      final userRef = FirebaseDatabase.instance.ref().child('users/${encodeUsername(username.value)}');
      await userRef.update({'imageUrl': downloadUrl});

      profileImageUrl.value = downloadUrl;
    }
  }

  String encodeUsername(String username) {
    return username.replaceAll('/', '_');
  }
}
