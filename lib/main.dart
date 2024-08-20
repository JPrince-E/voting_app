import 'package:VoteMe/app/resources/app.router.dart';
import 'package:VoteMe/voting_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:VoteMe/app/resources/app.locator.dart';
import 'package:VoteMe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await setupLocator();

    final router = await AppRouter.createRouter(); // Create the router dynamically


    runApp(VotingApp(router: router,));
  } catch (e, stack) {
// Handle initialization error
    print('Initialization failed: $e');
// Optionally log the stack trace or handle errors in a way that informs the user
  }
}
