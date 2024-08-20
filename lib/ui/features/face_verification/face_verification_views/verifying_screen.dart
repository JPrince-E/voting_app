import 'package:flutter/material.dart';
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';

class VerifyingScreen extends StatelessWidget {
  final Future<void> Function() verifyFace;

  const VerifyingScreen({super.key, required this.verifyFace});

  @override
  Widget build(BuildContext context) {
    // Start the verification process when the screen is built
    Future.delayed(Duration.zero, verifyFace);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'Verifying Face',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: AppColors.blueGray,
              backgroundImage:
              const AssetImage("assets/images/facial-recognition.png"),
              radius: 80,
            ),
            CustomSpacer(20),
            Text(
              'Verifying your face, please wait...',
              style: TextStyle(fontSize: 18, color: AppColors.kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
