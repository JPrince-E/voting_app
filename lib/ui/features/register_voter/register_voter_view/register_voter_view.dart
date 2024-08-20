import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/register_voter/register_voter_controller/register_voter_controller.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/ui/shared/custom_button.dart';
import 'package:VoteMe/ui/shared/custom_textfield_.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';
import 'package:VoteMe/utils/screen_util/screen_util.dart';


class RegisterVoterView extends StatelessWidget {
  final RegisterVoterController voterController = Get.put(RegisterVoterController());
  RegisterVoterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: const CustomAppbar(
            title: 'VOTER\'S INFORMATION',
            showBackButton: true,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: voterController.nameController,
                  labelText: 'Name',
                  hintText: 'Enter your First and Last name',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: voterController.matricNumberController,
                  labelText: 'Matric Number',
                  hintText: 'Enter your matric number',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: voterController.departmentController,
                  labelText: 'Department',
                  hintText: 'Enter your department',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: voterController.levelController,
                  labelText: 'Level',
                  hintText: 'Enter your level',
                ),
                CustomSpacer(20),
                Obx(
                      () => Center(
                    child: Text(
                      voterController.errMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                CustomSpacer(20),
                Center(
                  child: Obx(
                        () => voterController.showLoading.value
                        ? const CircularProgressIndicator()
                        : CustomButton(
                      styleBoolValue: true,
                      height: 55,
                      width: screenSize(context).width * 0.8,
                      color: AppColors.kPrimaryColor,
                      child: Text(
                        'Register',
                        style: AppStyles.regularStringStyle(
                          18,
                          AppColors.plainWhite,
                        ),
                      ),
                      onPressed: () {
                        voterController.registerUser(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
