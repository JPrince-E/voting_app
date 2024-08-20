import 'package:VoteMe/ui/features/profile/profile_controller/profile_controller.dart';
import 'package:VoteMe/ui/features/result_view/result_view/result_view.dart';
import 'package:VoteMe/ui/features/view_user_details/view_user_details_screen/view_user_details_screen.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/face_verification/face_verification_views/face_verification_app.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.plainWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 190,
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 50,
                  right: 50,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Obx(() {
                            return Text(
                              'Status: ${controller.status.value}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueGrey[900],
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 70,
                child: GestureDetector(
                  onTap: () {
                    controller.chooseProfileImageSource(context);
                  },
                  child: Obx(() {
                    return Stack(
                      children: [
                        CircleAvatar(
                          foregroundColor: AppColors.blueGray,
                          backgroundImage: controller
                                  .profileImageUrl.value.isEmpty
                              ? const AssetImage("assets/images/profile.png")
                              : NetworkImage(controller.profileImageUrl.value)
                                  as ImageProvider,
                          radius: 80,
                        ),
                        Positioned(
                          top: 130,
                          right: 20,
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomSpacer(80),
                wrapperContainer(
                  color: Colors.blueGrey[700],
                  child: ListTile(
                    leading: Icon(
                      Icons.person_add,
                      color: AppColors.plainWhite,
                      size: 30,
                    ),
                    title: Text(
                      "View Profile Details",
                      style: TextStyle(
                        color: AppColors.plainWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUserDetailsScreen(username: GlobalVariables.myUsername,),
                        ),
                      );
                    },
                  ),
                ),
                CustomSpacer(20),
                wrapperContainer(
                  color: Colors.blueGrey[700],
                  child: ListTile(
                    leading: Icon(
                      Icons.verified_user,
                      color: AppColors.plainWhite,
                      size: 30,
                    ),
                    title: Text(
                      "Vote Candidate",
                      style: TextStyle(
                        color: AppColors.plainWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FaceVerificationScreen(),
                        ),
                      );
                    },
                  ),
                ),
                CustomSpacer(20),
                wrapperContainer(
                  color: Colors.blueGrey[700],
                  child: ListTile(
                    leading: Icon(
                      Icons.file_copy,
                      color: AppColors.plainWhite,
                      size: 30,
                    ),
                    title: Text(
                      "View Vote Record",
                      style: TextStyle(
                        color: AppColors.plainWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultsView(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget wrapperContainer({required Widget child, Color? color}) {
  return Container(
    decoration: BoxDecoration(
      color: color ?? Colors.blueGrey[700],
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(5),
    child: child,
  );
}
