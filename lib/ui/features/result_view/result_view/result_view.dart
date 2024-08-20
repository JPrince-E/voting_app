import 'dart:math' as math;
import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VoteMe/ui/features/create_account/create_account_model/user_model.dart';
import 'package:VoteMe/ui/features/candidates/candidates_controller/candidates_controller.dart';
import 'package:VoteMe/utils/app_constants/app_colors.dart';
import 'package:VoteMe/utils/app_constants/app_styles.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({Key? key}) : super(key: key);

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  int touchedGroupIndex = -1;
  final CandidatesController controller = Get.put(CandidatesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'ELECTION RESULTS',
          showBackButton: true,
        ),
      ),
      body: Obx(() {
        print("Building UI with candidates: ${controller.candidates.length}"); // Debugging log

        if (controller.showLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errMessage.isNotEmpty) {
          return Center(child: Text(controller.errMessage.value));
        }

        final candidatesByPost = _groupCandidatesByPost(controller.candidates);
        final maxVotes = candidatesByPost.values
            .expand((candidates) => candidates.map((c) => c.voteCount ?? 0))
            .reduce((a, b) => a > b ? a : b);

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CustomSpacer(40),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AspectRatio(
                      aspectRatio: 1.4,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          borderData: FlBorderData(
                            show: true,
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: AppColors.plainGray.withOpacity(0.2),
                              ),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              drawBelowEverything: true,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: AppStyles.subStringStyle(12, AppColors.kPrimaryColor),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 120,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  return _PositionLabelWidget(
                                    position: _getPositionForIndex(index),
                                    candidates: _getCandidatesForIndex(index),
                                    color: _getBarColor(index),
                                    isSelected: touchedGroupIndex == index,
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: AppColors.plainGray.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          barGroups: _getBarGroups(candidatesByPost),
                          maxY: maxVotes.toDouble(),
                          barTouchData: BarTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (group) => Colors.transparent,
                              tooltipMargin: 0,
                              getTooltipItem: (
                                  BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex,
                                  ) {
                                return BarTooltipItem(
                                  '${rod.toY.toString()} votes\n${_getCandidateName(groupIndex, rodIndex)}',
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,  // Change this to the desired color
                                    fontSize: 18,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            touchCallback: (event, response) {
                              if (event.isInterestedForInteractions &&
                                  response != null &&
                                  response.spot != null) {
                                setState(() {
                                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                                });
                              } else {
                                setState(() {
                                  touchedGroupIndex = -1;
                                });
                              }
                            },
                          ),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      }),
    );
  }

  Future<void> _refreshData() async {
    print("Refreshing data..."); // Debugging log
    await controller.fetchCandidates();
    print("Data refreshed."); // Debugging log
    setState(() {});
    print('Fetching candidates...');
    print('Candidates length: ${controller.candidates.length}');

  }

  // Method to generate color shades
  Color getColorWithShade(Color color, double factor) {
    int r = (color.red * factor).toInt();
    int g = (color.green * factor).toInt();
    int b = (color.blue * factor).toInt();
    return Color.fromARGB(color.alpha, r, g, b);
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

  // Get bar groups with color and values
  List<BarChartGroupData> _getBarGroups(
      Map<String, List<UserModel>> candidatesByPost) {
    final List<BarChartGroupData> barGroups = [];
    int groupIndex = 0;

    candidatesByPost.forEach((post, candidates) {
      print("Processing post: $post, candidates: ${candidates.length}"); // Debugging log

      barGroups.add(
        BarChartGroupData(
          x: groupIndex,
          barRods: candidates.asMap().entries.map((entry) {
            final index = entry.key;
            final candidate = entry.value;

            final shadeFactor = 0.7 + (index * 0.1); // Adjust the factor to create the shades
            final barColor = getColorWithShade(AppColors.kPrimaryColor, shadeFactor);

            return BarChartRodData(
              toY: (candidate.voteCount ?? 0).toDouble(),
              color: barColor,
              width: 30, // Increased bar width
              borderRadius: BorderRadius.circular(12),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: (candidate.voteCount ?? 0).toDouble(),
                color: Colors.grey.withOpacity(0.2),
              ),
            );
          }).toList(),
        ),
      );
      groupIndex++;
    });

    return barGroups;
  }

  // Find the candidate with the highest votes
  UserModel? _findWinner(List<UserModel> candidates) {
    return candidates.reduce((a, b) => (a.voteCount ?? 0) > (b.voteCount ?? 0) ? a : b);
  }

  // Get candidates for an index
  List<UserModel> _getCandidatesForIndex(int index) {
    final candidatesByPost = _groupCandidatesByPost(controller.candidates);
    final post = candidatesByPost.keys.elementAt(index);
    return candidatesByPost[post] ?? [];
  }

  // Get bar color based on the index
  Color _getBarColor(int index) {
    // Implement your logic to return color based on index or other conditions
    return AppColors.kPrimaryColor;
  }

  // Get position for a bar group index
  String _getPositionForIndex(int index) {
    final candidatesByPost = _groupCandidatesByPost(controller.candidates);
    final post = candidatesByPost.keys.elementAt(index);
    return post; // Returning the post (position) for the index
  }

  // Get candidate name for a bar group index and rod index
  String _getCandidateName(int groupIndex, int rodIndex) {
    final candidatesByPost = _groupCandidatesByPost(controller.candidates);
    final post = candidatesByPost.keys.elementAt(groupIndex);
    final candidates = candidatesByPost[post] ?? [];
    return candidates.length > rodIndex ? candidates[rodIndex].politicalName ?? 'Unknown' : 'Unknown';
  }
}

class _PositionLabelWidget extends StatelessWidget {
  const _PositionLabelWidget({
    required this.position,
    required this.candidates,
    required this.color,
    required this.isSelected,
  });

  final String position;
  final List<UserModel> candidates;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Displaying the position (post) at the top
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            position,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Displaying candidate names inside the bar
        ...candidates.map((candidate) => Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            candidate.politicalName ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );
  }
}
