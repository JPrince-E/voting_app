import 'package:VoteMe/app/helpers/sharedprefs.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VoteMe/app/resources/app.router.dart';
import 'package:VoteMe/app/services/navigation_service.dart';
import 'package:VoteMe/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:VoteMe/utils/app_constants/app_theme_data.dart';

class VotingApp extends StatelessWidget {
  final GoRouter router;

  const VotingApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentPage(),
      child: MaterialApp.router(
        title: "Voting App",
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        routerConfig: router,
      ),
    );
  }
}