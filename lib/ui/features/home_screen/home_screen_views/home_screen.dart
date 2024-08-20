import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:VoteMe/ui/features/profile/profile_view/profile_view.dart';
import 'package:VoteMe/ui/features/register_candidate/register_candidate_views/register_candidate_view.dart';
import 'package:VoteMe/ui/features/register_voter/register_voter_view/register_voter_view.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'VOTING APP',
        ),
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
                    MaterialPageRoute(builder: (context) => RegisterVoterView()),
                  );
                },
              ),
              HomeScreenButton(
                imagePath: 'assets/images/register_candidate.png',
                label: 'Register \nas a Candidate',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterCandidateView()),
                  );
                },
              ),
              HomeScreenButton(
                imagePath: 'assets/images/view_profile.png',
                label: 'View Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePageView()),
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
