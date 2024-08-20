import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/app/resources/app.logger.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';

final log = getLogger('CreateUserController');

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isSignUp = false.obs;
  var errMessage = ''.obs;
  var showLoading = false.obs;
  var imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    log.d('Checking if user is logged in...');

    // Delay the execution until the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Pass the context after the widget tree is built
      await _checkSavedUser(Get.context);

      final ref = FirebaseDatabase.instance.ref();
      final username = encodeUsername(GlobalVariables.myUsername);
      final snapshot = await ref.child('users/$username').get();

      if (snapshot.exists) {
        log.d("User exists: ${snapshot.value}");
        final userData = UserModel.fromJson(jsonDecode(jsonEncode(snapshot.value)));

        if (userData.password == encodeUsername(GlobalVariables.myPassword).trim()) {
          showLoading.value = false;
          GlobalVariables.myUsername = encodeUsername(GlobalVariables.myUsername);
          log.d("GlobalVariables Username: ${GlobalVariables.myUsername}");
          await saveSharedPrefsStringValue(
              "myUsername", encodeUsername(GlobalVariables.myUsername).trim());
          await saveSharedPrefsStringValue(
              "myPassword", encodeUsername(GlobalVariables.myPassword).trim());
          gotoHomepage(Get.context!); // Use the context here safely
        } else {
          log.d('Password does not match.');
          errMessage.value = "Error! Username or password incorrect";
          showLoading.value = false;
        }
      } else {
        log.d('User data does not exist.');
        errMessage.value = "Error! User ${encodeUsername(GlobalVariables.myUsername)} not found";
        showLoading.value = false;
      }
    });
  }

  Future<void> _checkSavedUser(BuildContext? context) async {
    final ref = FirebaseDatabase.instance.ref();
    final savedUsername = await getSharedPrefsSavedString("myUsername");
    if (savedUsername.isNotEmpty) {
      GlobalVariables.myUsername = savedUsername;
      log.d("User already signed in: $savedUsername");

      final snapshot = await ref.child('users/${encodeUsername(savedUsername)}')
          .get();

      if (snapshot.exists && context != null) {
        // Use a Future.delayed to ensure context is available
        Future.delayed(Duration.zero, () {
          gotoHomepage(context);
        });
      } else {
        log.d("Saved user data does not exist. Clearing saved username.");
        await saveSharedPrefsStringValue("myUsername", '');
      }
    }
  }


  void toggleSignUpSignIn() {
  isSignUp.value = !isSignUp.value;
}

void resetValues() {
  errMessage.value = '';
  showLoading.value = false;
}

void gotoSignInUserPage(BuildContext context) {
  log.d('Going to sign in user page');
  resetValues();
  context.push('/signInView');
}

void gotoHomepage(BuildContext context) {
  log.d('Going to home screen');
  resetValues();
  context.go('/homeScreen');
}

void attemptToSignInUser(BuildContext context) {
  log.i(context);
  log.d('Attempting to sign in user...');
  errMessage.value = '';

  String username;

  if (GlobalVariables.myUsername.isNotEmpty) {
    username = encodeUsername(GlobalVariables.myUsername);
    signInUser(context);
  } else {
    username = encodeUsername(usernameController.text.trim());
  }

  final password = passwordController.text.trim();

  if (username.isNotEmpty &&
      !username.contains(' ') &&
      password.isNotEmpty &&
      !password.contains(' ')) {
    log.d('Signing in user...');
    showLoading.value = true;
    errMessage.value = '';
    signInUser(context);
    print(
        "------------------------------------------------------------------------------");
    log.wtf(context);
  } else {
    errMessage.value = 'All fields must be filled, and with no spaces';
    log.d("Error message: $errMessage");
    showLoading.value = false;
  }
}

Future<void> signInUser(BuildContext context) async {
  log.d('Checking if user exists...');
  final ref = FirebaseDatabase.instance.ref();
  final username = encodeUsername(usernameController.text.trim());
  final snapshot = await ref.child('users/$username').get();

  if (snapshot.exists) {
    log.d("User exists: ${snapshot.value}");
    final userData =
    UserModel.fromJson(jsonDecode(jsonEncode(snapshot.value)));

    if (userData.password == passwordController.text.trim()) {
      showLoading.value = false;
      GlobalVariables.myUsername = usernameController.text.trim();
      log.d("GlobalVariables Username: ${GlobalVariables.myUsername}");
      await saveSharedPrefsStringValue(
          "myUsername", usernameController.text.trim());
      await saveSharedPrefsStringValue(
          "myPassword", passwordController.text.trim());
      gotoHomepage(context);
    } else {
      log.d('Password does not match.');
      errMessage.value = "Error! Username or password incorrect";
      showLoading.value = false;
    }
  } else {
    log.d('User data does not exist.');
    errMessage.value =
    "Error! User ${usernameController.text.trim()} not found";
    showLoading.value = false;
  }
}

Future<void> pickImage(ImageSource source) async {
  final pickedFile = await ImagePicker()
      .pickImage(source: source, maxWidth: 1800, maxHeight: 1800);
  if (pickedFile != null) {
    imageFile.value = File(pickedFile.path);
  }
}

Future<void> signUpUser(BuildContext context) async {
  log.d('Attempting to sign up user...');

  final username = encodeUsername(usernameController.text.trim());
  final password = passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    errMessage.value = 'All fields must be filled out.';
    log.d('Error: $errMessage');
    return;
  }

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('users/$username').get();

  if (snapshot.exists) {
    errMessage.value = 'User $username already exists.';
    log.d('Error: ${errMessage.value}');
    return;
  }

  final newUser = UserModel(
    username: username,
    password: password,
    status: 'Not Qualified',
  );

  await ref.child('users/$username').set(newUser.toJson());
  log.d('User $username successfully signed up.');

  attemptToSignInUser(context);
}

String encodeUsername(String username) {
  return username.replaceAll('/', '_');
}

String decodeUsername(String encodedUsername) {
  return encodedUsername.replaceAll('_', '/');
}}
