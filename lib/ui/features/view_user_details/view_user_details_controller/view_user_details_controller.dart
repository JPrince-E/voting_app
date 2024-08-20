import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ViewUserDetailsController extends GetxController {
  // Define the reactive variables
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Fetch user details method
  Future<void> fetchUserDetails(String username) async {
    try {
      isLoading.value = true;  // Set loading state to true
      errorMessage.value = ''; // Clear any previous errors

      final ref = FirebaseDatabase.instance.ref('users/${encodeUsername(GlobalVariables.myUsername)}');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
        final data = snapshot.value as Map<Object?, Object?>;

        // Convert the map to Map<String, dynamic>
        final stringKeyMap = data.map((key, value) => MapEntry(key.toString(), value));

        // Parse the snapshot data to UserModel
        userModel.value = UserModel.fromJson(stringKeyMap);
      } else {
        errorMessage.value = 'User not found.';
      }
    } catch (e) {
      // Catch and store any errors
      errorMessage.value = 'Error fetching user details: $e';
      print('error $e');
    } finally {
      isLoading.value = false;  // Set loading state to false
    }
  }

  String encodeUsername(String username) {
    return username.replaceAll('/', '_');
  }
}
