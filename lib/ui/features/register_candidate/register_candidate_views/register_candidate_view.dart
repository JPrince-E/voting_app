import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/register_candidate/register_candidate_controller/register_candidate_controller.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/ui/shared/custom_button.dart';
import 'package:VoteMe/ui/shared/custom_textfield_.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';
import 'package:VoteMe/utils/screen_util/screen_util.dart';

class RegisterCandidateView extends StatelessWidget {
  RegisterCandidateView({Key? key}) : super(key: key);

  final RegisterCandidateController candidateController = Get.put(RegisterCandidateController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: const CustomAppbar(
            title: 'CANDIDATE\'S INFORMATION',
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
                  textEditingController: candidateController.politicalNameController,
                  labelText: 'Political Name',
                  hintText: 'Enter your political name',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: candidateController.postController,
                  labelText: 'Post',
                  hintText: 'Enter the post you are running for',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: candidateController.cgpaController,
                  labelText: 'Current CGPA',
                  hintText: 'Enter your current CGPA',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: candidateController.aboutController,
                  labelText: 'About',
                  hintText: 'Tell us what you stand for',
                ),
                CustomSpacer(20),
                CustomTextfield(
                  textEditingController: candidateController.whyPostController,
                  labelText: 'Why the Post',
                  hintText: 'Why you are qualified for the post',
                ),
                CustomSpacer(20),
                Obx(
                      () => Center(
                    child: Text(
                      candidateController.errMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                CustomSpacer(20),
                Center(
                  child: Obx(
                        () => candidateController.showLoading.value
                        ? const CircularProgressIndicator()
                        : CustomButton(
                      styleBoolValue: true,
                      height: 55,
                      width: screenSize(context).width * 0.8,
                      color: AppColors.kPrimaryColor,
                      child: Text(
                        'Register as Candidate',
                        style: AppStyles.regularStringStyle(
                          18,
                          AppColors.plainWhite,
                        ),
                      ),
                      onPressed: () {
                        candidateController.registerCandidate(context);
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
