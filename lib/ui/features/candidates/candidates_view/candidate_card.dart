import 'package:flutter/material.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';

class CandidateCard extends StatelessWidget {
  final UserModel candidate;
  final VoidCallback onVote;

  const CandidateCard({Key? key, required this.candidate, required this.onVote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150, // Adjust width based on card size
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(candidate.imageUrl ?? 'https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    candidate.politicalName ?? 'No political name',
                    style: AppStyles.keyStringStyle(16, AppColors.kPrimaryColor),
                  ),
                  Text(
                    candidate.fullName ?? 'Unknown',
                    style: AppStyles.subStringStyle(14, AppColors.plainGray),
                  ),
                  Text(
                    candidate.department ?? 'Unknown',
                    style: AppStyles.subStringStyle(14, AppColors.plainGray),
                  ),
                  ElevatedButton(
                    onPressed: onVote,
                    child: const Text('Vote'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
