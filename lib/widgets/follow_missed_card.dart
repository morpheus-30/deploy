import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/followups_provider.dart';
import 'package:shimmer/shimmer.dart';

class FollowMissedCall extends StatefulWidget {
  const FollowMissedCall({super.key});

  @override
  _FollowMissedCallState createState() => _FollowMissedCallState();
}

class _FollowMissedCallState extends State<FollowMissedCall> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FollowupsProvider>(context, listen: false).fetchFollowups();
      Provider.of<CallLogsProvider>(context, listen: false).fetchMissedCalls();
    });
  }

  Widget _buildStatusCard({
    required String label,
    required int value,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required IconData iconData,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: iconColor.withOpacity(0.2),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerStatusCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 16,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 24,
                  color: Colors.grey.shade400,
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    Provider.of<DefaultProvider>(context, listen: false)
        .setSelectedPageIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DefaultProvider, FollowupsProvider, CallLogsProvider>(
      builder: (context, defaultProvider, followupsProvider, callLogsProvider,
          child) {
        if (defaultProvider.isLoading ||
            followupsProvider.isLoading ||
            callLogsProvider.isLoading) {
          return Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildShimmerStatusCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildShimmerStatusCard(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        int followupsCount = followupsProvider.followups.length;
        int missedCallsCount = callLogsProvider.missedCallCount;

        return Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      label: 'Open Followups',
                      value: followupsCount,
                      onTap: () => _navigateToPage(3),
                      backgroundColor: const Color(0xffF3F7FF),
                      textColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconData: Icons.arrow_outward_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusCard(
                      label: 'Open Missed Calls',
                      value: missedCallsCount,
                      onTap: () => _navigateToPage(4),
                      backgroundColor: const Color(0xffFFF3F3),
                      textColor: const Color(0xff5A6478),
                      iconColor: Colors.grey,
                      iconData: Icons.call_missed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
