import 'package:VoteMe/ui/features/profile/profile_controller/profile_controller.dart';
import 'package:VoteMe/ui/features/profile/profile_view/profile_view.dart';
import 'package:VoteMe/ui/features/register_candidate/register_candidate_views/register_candidate_view.dart';
import 'package:VoteMe/ui/features/register_voter/register_voter_view/register_voter_view.dart';
import 'package:VoteMe/ui/features/result_view/result_view/result_view.dart';
import 'package:VoteMe/ui/features/view_user_details/view_user_details_controller/view_user_details_controller.dart';
import 'package:VoteMe/ui/features/view_user_details/view_user_details_screen/view_user_details_screen.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ViewUserDetailsController userController = Get.put(ViewUserDetailsController());
    final ProfileController profileController = Get.put(ProfileController());

    // Fetch user details when the screen is loaded
    const String username = 'currentUsername';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
        child: Obx(() {
          final user = userController.userModel.value;
          return CustomAppbar(
            title: 'VOTING APP',
            actionWidget: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewUserDetailsScreen(username: GlobalVariables.myUsername,),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: profileController.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(profileController.profileImageUrl.value)
                          : user?.imageUrl != null
                          ? NetworkImage(user!.imageUrl!)
                          : const AssetImage("assets/images/profile.png") as ImageProvider,
                      radius: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: GridView.count(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 50,
            shrinkWrap: true,
            children: [
              HomeScreenButton(
                imagePath: 'assets/images/voter.png',
                label: 'Register \nas a Voter',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterVoterView()),
                  );
                },
              ),
              HomeScreenButton(
                imagePath: 'assets/images/register_candidate.png',
                label: 'Register \nas a Candidate',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterCandidateView()),
                  );
                },
              ),
              HomeScreenButton(
                imagePath: 'assets/images/view_record.jpg',
                label: 'Vote Result',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResultsView(),
                    ),
                  );
                },
              ),
              HomeScreenButton(
                imagePath: 'assets/images/vote.png',
                label: 'Vote your Candidate',
                onTap: () {
                  context.push('/faceVerification');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const HomeScreenButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
