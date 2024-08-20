import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/app/resources/app.logger.dart';
import 'package:VoteMe/app/services/snackbar_service.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:go_router/go_router.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

final log = getLogger('RegisterCandidateController');

class RegisterCandidateController extends GetxController {
  final politicalNameController = TextEditingController();
  final postController = TextEditingController();
  final cgpaController = TextEditingController();
  final aboutController = TextEditingController();
  final whyPostController = TextEditingController();

  var errMessage = ''.obs;
  var showLoading = false.obs;

  Future<void> registerCandidate(BuildContext context) async {
    log.d('Attempting to register candidate...');
    errMessage.value = '';

    final username = encodeUsername(GlobalVariables.myUsername);

    final name = politicalNameController.text.trim();
    final post = postController.text.trim();
    final cgpa = cgpaController.text.trim();
    final about = aboutController.text.trim();
    final whyPost = whyPostController.text.trim();

    if (name.isNotEmpty &&
        post.isNotEmpty &&
        cgpa.isNotEmpty &&
        about.isNotEmpty &&
        whyPost.isNotEmpty) {
      log.d('Registering candidate...');
      showLoading.value = true;
      errMessage.value = '';

      final ref = FirebaseDatabase.instance.ref();
      final candidateData = {
        'politicalName': name,
        'post': post,
        'cgpa': cgpa,
        'about': about,
        'whyPost': whyPost,
        'status': 'Candidate',
      };

      await ref.child('users/$username').update(candidateData).then((_) {
        showLoading.value = false;
        log.d('Candidate registered successfully.');
        GlobalVariables.myPoliticalName = name;
        saveSharedPrefsStringValue("myPoliticalName", name);
        context.pushReplacement('/homeScreen');
        resetFields();
      }).then((value) {
        showCustomSnackBar(context, "You are now registered as a Candidate.", () {},
            AppColors.kPrimaryColor, 1000);
      }).catchError((error) {
        showLoading.value = false;
        errMessage.value = "Error registering candidate: $error";
        log.e('Error registering candidate: $error');
      });
    } else {
      errMessage.value = 'All fields must be filled.';
      log.d('Error: $errMessage');
    }
  }

  String encodeUsername(String username) {
    return username.replaceAll('/', '_');
  }

  void resetFields() {
    politicalNameController.clear();
    postController.clear();
    cgpaController.clear();
    aboutController.clear();
    whyPostController.clear();
  }
}
