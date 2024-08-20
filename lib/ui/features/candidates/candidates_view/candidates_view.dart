import 'package:VoteMe/ui/features/candidates/candidates_view/candidate_card.dart';
import 'package:VoteMe/ui/features/home_screen/home_screen_views/home_screen.dart';
import 'package:VoteMe/ui/features/register_candidate/register_candidate_views/register_candidate_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/candidates/candidates_controller/candidates_controller.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';
import 'package:go_router/go_router.dart';

class CandidatesView extends StatelessWidget {
  CandidatesView({Key? key}) : super(key: key);

  final CandidatesController controller = Get.put(CandidatesController());
  final Rx<UserModel?> _selectedCandidate = Rx<UserModel?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'Candidates',
          showBackButton: true,
        ),
      ),
      body: Obx(() {
        if (controller.showLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errMessage.isNotEmpty) {
          return Center(child: Text(controller.errMessage.value));
        }

        final candidatesByPost = _groupCandidatesByPost(controller.candidates);

        return RefreshIndicator(
          onRefresh: _refreshCandidates,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: candidatesByPost.entries.map((entry) {
                    final post = entry.key;
                    final candidates = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post,
                          style: AppStyles.keyStringStyle(24, AppColors.kPrimaryColor),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 300, // Adjust height based on card size
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: candidates.length,
                            itemBuilder: (context, index) {
                              final candidate = candidates[index];
                              final isSelected = _selectedCandidate.value?.username == candidate.username;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Stack(
                                  children: [
                                    CandidateCard(
                                      candidate: candidate,
                                      onVote: () async {
                                        _selectedCandidate.value = candidate;
                                        await controller.voteForCandidate('voterId', candidate);
                                        _refreshCandidates();
                                      },
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: AppColors.kPrimaryColor,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacement('/homeScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A88E5), Color(0xFF3D65E0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 50.0, maxWidth: 200),
                      alignment: Alignment.center,
                      child: const Text(
                        'End Vote',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Group candidates by their post
  Map<String, List<UserModel>> _groupCandidatesByPost(List<UserModel> candidates) {
    final Map<String, List<UserModel>> groupedCandidates = {};

    for (var candidate in candidates) {
      final post = candidate.post ?? 'Unknown Post';
      if (groupedCandidates.containsKey(post)) {
        groupedCandidates[post]!.add(candidate);
      } else {
        groupedCandidates[post] = [candidate];
      }
    }

    return groupedCandidates;
  }

  // Method to refresh candidates
  Future<void> _refreshCandidates() async {
    await controller.fetchCandidates();
  }
}
