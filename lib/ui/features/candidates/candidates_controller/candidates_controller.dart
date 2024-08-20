import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:VoteMe/app/resources/app.logger.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';

final log = getLogger('CandidatesController');

class CandidatesController extends GetxController {
  var candidates = <UserModel>[].obs;
  var selectedCandidate = UserModel().obs;
  var showLoading = false.obs;
  var errMessage = ''.obs;
  var userVotes = <String, String>{}.obs; // Key: post, Value: candidateId

  @override
  void onInit() {
    super.onInit();
    fetchCandidates();
    update();
  }

  Future<void> fetchCandidates() async {
    showLoading.value = true;
    errMessage.value = '';

    try {
      final ref = FirebaseDatabase.instance.ref().child('users');
      final snapshot = await ref.orderByChild('status').equalTo('Candidate').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        candidates.value = data.values.map((e) => UserModel.fromJson(Map<String, dynamic>.from(e))).toList();
        print("Candidates updated: ${candidates.length}"); // Debugging log
      } else {
        errMessage.value = 'No candidates found.';
      }
    } catch (e) {
      errMessage.value = 'Error fetching candidates: $e';
      log.e(errMessage.value);
    } finally {
      showLoading.value = false;
    }
  }

  Future<void> voteForCandidate(String voterId, UserModel newCandidate) async {
    try {
      final post = newCandidate.post;

      if (post == null) {
        errMessage.value = 'Candidate has no post.';
        log.e(errMessage.value);
        return;
      }

      // Check if the user has already voted for a candidate in the same post
      final previousCandidateId = userVotes[post];
      if (previousCandidateId != null) {
        // Decrement the vote count of the previous candidate
        await _updateVoteCount(previousCandidateId, -1);
      }

      // Increment the vote count of the new candidate
      await _updateVoteCount(newCandidate.username!, 1);

      // Update the user's vote
      userVotes[post] = newCandidate.username!;

      // Update the local list of candidates
      int index = candidates.indexWhere((c) => c.username == newCandidate.username);
      if (index != -1) {
        candidates[index].voteCount = (candidates[index].voteCount ?? 0) + 1;
        candidates.refresh(); // Refresh the candidates list to update the UI
      }
    } catch (e) {
      errMessage.value = 'Error voting for candidate: $e';
      log.e(errMessage.value);
    }
  }

  Future<void> _updateVoteCount(String candidateId, int increment) async {
    try {
      final ref = FirebaseDatabase.instance.ref().child('users').child(candidateId);
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final candidateData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        UserModel candidate = UserModel.fromJson(candidateData);

        // Update the vote count
        candidate.voteCount = ((candidate.voteCount ?? 0) + increment);

        // Update the vote count in the database
        await ref.update({'voteCount': candidate.voteCount});

        // Update the local list of candidates
        int index = candidates.indexWhere((c) => c.username == candidate.username);
        if (index != -1) {
          candidates[index] = candidate;
          candidates.refresh();
        }
      } else {
        errMessage.value = 'Candidate not found.';
        log.e(errMessage.value);
      }
    } catch (e) {
      errMessage.value = 'Error updating vote count: $e';
      log.e(errMessage.value);
    }
  }
}

