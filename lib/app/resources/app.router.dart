import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/ui/features/view_user_details/view_user_details_screen/view_user_details_screen.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:VoteMe/app/services/navigation_service.dart';
import 'package:VoteMe/ui/features/candidates/candidates_view/candidates_view.dart';
import 'package:VoteMe/ui/features/create_account/login_views/signin_user_view.dart';
import 'package:VoteMe/ui/features/face_verification/face_verification_views/face_verification_app.dart';
import 'package:VoteMe/ui/features/home_screen/home_screen_views/home_screen.dart';
import 'package:VoteMe/ui/features/profile/profile_view/profile_view.dart';
import 'package:VoteMe/ui/features/register_candidate/register_candidate_views/register_candidate_view.dart';
import 'package:VoteMe/ui/features/register_voter/register_voter_view/register_voter_view.dart';

class AppRouter {
  static Future<String> determineInitialRoute() async {
    final savedUsername = await getSharedPrefsSavedString("myUsername");
    if (savedUsername.isNotEmpty) {
      GlobalVariables.myUsername = savedUsername;
      return '/homeScreen'; // Navigate to home screen if user is logged in
    } else {
      return '/signInView'; // Navigate to sign-in screen if user is not logged in
    }
  }

  static Future<GoRouter> createRouter() async {
    final initialRoute = await determineInitialRoute();
    return GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SignInView(),
        ),
        GoRoute(
          path: '/faceVerification',
          pageBuilder: (context, state) =>
              CustomNormalTransition(
                  child: const FaceVerificationScreen(), key: state.pageKey),
        ),
        GoRoute(
          path: '/homeScreen',
          pageBuilder: (context, state) =>
              CustomNormalTransition(
                  child: const HomeScreen(), key: state.pageKey),
        ),
        GoRoute(
          path: '/scheduleView',
          pageBuilder: (context, state) =>
              CustomSlideTransition(
                  child: const Scaffold(), key: state.pageKey),
        ),
        GoRoute(
          path: '/profilePageView',
          pageBuilder: (context, state) =>
              CustomNormalTransition(
                  child: ProfilePageView(), key: state.pageKey),
        ),
        GoRoute(
          path: '/viewUserDetailsScreen',
          pageBuilder: (context, state) =>
              CustomNormalTransition(
                  child: ViewUserDetailsScreen(username: '${GlobalVariables.myUsername}',), key: state.pageKey),
        ),
        GoRoute(
          path: '/signInView',
          builder: (context, state) => SignInView(),
        ),
        GoRoute(
          path: '/registerVoter',
          builder: (context, state) => RegisterVoterView(),
        ),
        GoRoute(
          path: '/registerCandidate',
          builder: (context, state) => RegisterCandidateView(),
        ),
        GoRoute(
          path: '/candidates',
          builder: (context, state) => CandidatesView(),
        ),
      ],
    );
  }
}

class CustomNormalTransition extends CustomTransitionPage {
  CustomNormalTransition({required LocalKey key, required Widget child})
      : super(
    key: key,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 0),
    child: child,
  );
}

class CustomSlideTransition extends CustomTransitionPage {
  CustomSlideTransition({required LocalKey key, required Widget child})
      : super(
    key: key,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 200),
    child: child,
  );
}
