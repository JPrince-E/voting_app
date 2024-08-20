import 'package:VoteMe/ui/features/view_user_details/view_user_details_controller/view_user_details_controller.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

class ViewUserDetailsScreen extends StatelessWidget {
  final String username;

  const ViewUserDetailsScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final ViewUserDetailsController controller = Get.put(ViewUserDetailsController());

    // Fetch user details when the screen is loaded
    controller.fetchUserDetails(username);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'User Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.userModel.value == null) {
          return const Center(child: Text('User not found.'));
        } else {
          final user = controller.userModel.value!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 130,
                      padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      child: CircleAvatar(
                        backgroundImage: user.imageUrl != null
                            ? NetworkImage(user.imageUrl!)
                            : const AssetImage("assets/images/profile.png") as ImageProvider,
                        radius: 80,
                      ),
                    ),
                  ],
                ),
                CustomSpacer(50),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserDetail(Icons.person, 'Full Name', user.fullName),
                          _buildUserDetail(Icons.school, 'Matric Number', user.username),
                          _buildUserDetail(Icons.business, 'Department', user.department),
                          _buildUserDetail(Icons.grade, 'Level', user.level),
                          _buildUserDetail(Icons.account_box, 'Political Name', user.politicalName),
                          _buildUserDetail(Icons.how_to_vote, 'Post', user.post),
                          _buildUserDetail(Icons.star, 'CGPA', user.cgpa),
                          _buildUserDetail(Icons.info, 'About', user.about),
                          _buildUserDetail(Icons.question_answer, 'Why Post', user.whyPost),
                          _buildUserDetail(Icons.how_to_vote, 'Vote Count', user.voteCount.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildUserDetail(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.kPrimaryColor,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
