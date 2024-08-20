// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:VoteMe/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_key_strings.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key, required this.color});
  final Color color;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lighterGray,
      height: 68,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
        decoration: BoxDecoration(
          color: widget.color,
          // border: Border.all(color: AppColors.regularGray),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Home Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    0) {
                  print('Home selected');
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(0);
                  context.canPop() ? context.pop() : () {};
                } else {
                  print('You are already in homepage');
                }

                if (GlobalVariables.newStaffAdded == true) {
                  Future.delayed(Duration(milliseconds: 500)).then((value) {
                    // Get.find<HomepageController>().updateScreenValues();
                  });
                  GlobalVariables.newStaffAdded = false;
                }
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            0
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? 20
                      : 0,
                  vertical: 3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.home,
                      size: 20,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.5),
                    ),
                    Text(
                      AppKeyStrings.home,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                0
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Record Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    1) {
                  print('insights selected');
                  final bool currentPageIndexCheck =
                      Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? true
                          : false;
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(1);

                  print('currentPageIndexCheck: $currentPageIndexCheck');
                  currentPageIndexCheck == true
                      ? context.push('/insightsPageView')
                      : context.pushReplacement('/insightsPageView');
                } else {
                  print('You are already in insightsView');
                }
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            1
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          1
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          1
                      ? 20
                      : 0,
                  vertical: 3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.lightbulb_outlined,
                      size: 20,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              1
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.5),
                    ),
                    Text(
                      AppKeyStrings.insights,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                1
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Profile/Add_Staff Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    2) {
                  print(GlobalVariables.accountType == 'staff'
                      ? 'Profile selected'
                      : 'Add Staff selected');
                  final bool currentPageIndexCheck =
                      Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? true
                          : false;
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(2);

                  print('currentPageIndexCheck: $currentPageIndexCheck');
                  currentPageIndexCheck == true
                      ? context.push(GlobalVariables.accountType == 'staff'
                          ? '/profilePageView'
                          : '/addStaffPageView')
                      : context.pushReplacement(
                          GlobalVariables.accountType == 'staff'
                              ? '/profilePageView'
                              : '/addStaffPageView');
                } else {
                  print(
                      'You are already in ${GlobalVariables.accountType == 'staff' ? "ProfilePageView" : "AddStaffPageView"}');
                }
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            2
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          2
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          2
                      ? 20
                      : 0,
                  vertical: 3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      GlobalVariables.accountType == 'staff'
                          ? CupertinoIcons.person
                          : Icons.person_add_alt_outlined,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              2
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.5),
                      size: 20,
                    ),
                    Text(
                      GlobalVariables.accountType == 'staff'
                          ? AppKeyStrings.profile
                          : "Add Staff",
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                2
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // : const SizedBox.shrink(),
            ,
          ],
        ),
      ),
    );
  }
}
