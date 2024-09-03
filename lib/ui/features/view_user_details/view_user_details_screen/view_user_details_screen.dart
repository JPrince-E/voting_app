import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/view_user_details/view_user_details_controller/view_user_details_controller.dart';
import 'package:VoteMe/ui/features/profile/profile_controller/profile_controller.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ViewUserDetailsScreen extends StatelessWidget {
  final String username;

  const ViewUserDetailsScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final ViewUserDetailsController controller = Get.put(ViewUserDetailsController());
    final ProfileController profileController = Get.put(ProfileController());

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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {
              _showOptionsDialog(context, profileController);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchUserDetails(username),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
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
                      child: Obx(() {
                        return CircleAvatar(
                          backgroundImage: profileController.profileImageUrl.value.isNotEmpty
                              ? NetworkImage(profileController.profileImageUrl.value)
                              : user.imageUrl != null
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage("assets/images/profile.png") as ImageProvider,
                          radius: 80,
                        );
                      }),
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

  void _showOptionsDialog(BuildContext context, ProfileController profileController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Edit Profile Picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showImageSourceDialog(context, profileController);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
                  _logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context, ProfileController profileController) {
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
                  profileController.uploadProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  profileController.uploadProfileImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    try {
      GlobalVariables.myUsername = '';
      GlobalVariables.myPassword = '';
      Get.offAllNamed('/signInView');
    } catch (e) {
      Get.snackbar('Logout Error', e.toString());
    }
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
