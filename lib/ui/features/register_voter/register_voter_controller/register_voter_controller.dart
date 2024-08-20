import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/app/resources/app.logger.dart';
import 'package:VoteMe/app/services/snackbar_service.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

final log = getLogger('RegisterVoterController');

class RegisterVoterController extends GetxController {
  final nameController = TextEditingController();
  final matricNumberController = TextEditingController();
  final departmentController = TextEditingController();
  final levelController = TextEditingController();

  var errMessage = ''.obs;
  var showLoading = false.obs;

  Future<void> registerUser(BuildContext context) async {
    log.d('Attempting to register user...');
    errMessage.value = '';

    final username = encodeUsername(GlobalVariables.myUsername);

    final fullName = nameController.text.trim();
    final matricNumber = encodeUsername(matricNumberController.text.trim());
    final department = departmentController.text.trim();
    final level = levelController.text.trim();

    if (fullName.isNotEmpty &&
        matricNumber.isNotEmpty &&
        department.isNotEmpty &&
        level.isNotEmpty) {
      log.d('Registering voter...');
      showLoading.value = true;
      errMessage.value = '';

      final ref = FirebaseDatabase.instance.ref();
      final voter = {
        'fullName': fullName,
        'matricNumber': matricNumber,
        'department': department,
        'level': level,
        'status': 'Voter',
      };

      await ref.child('users/$username').update(voter).then((_) {
        showLoading.value = false;
        log.d('User registered successfully.');
        GlobalVariables.myFullName = fullName;
        saveSharedPrefsStringValue("myFullName", fullName);
        context.pushReplacement('/homeScreen');
        resetFields();
      }).then((value) {
        showCustomSnackBar(context, "You are now registered as a Voter.", () {},
            AppColors.kPrimaryColor, 1000);
      }).catchError((error) {
        showLoading.value = false;
        errMessage.value = "Error registering voter: $error";
        log.e('Error registering voter: $error');
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
    nameController.clear();
    matricNumberController.clear();
    departmentController.clear();
    levelController.clear();
  }


}
