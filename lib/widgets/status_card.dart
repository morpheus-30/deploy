import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/category_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/follow_missed_card.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                // const Spacer(),
                // _buildUniqueAllToggle(context),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const FollowMissedCall(),
            const SizedBox(
              height: 40,
            ),
            _buildStatusItems(context),
            // const SizedBox(
            //   height: 20,
            // ),
            // _buildTotalStatusCount(context),
          ],
        ),
      ),
    );
  }

  // Widget _buildUniqueAllToggle(BuildContext context) {
  //   return Consumer<DashboardProvider>(
  //     builder: (context, model, child) {
  //       return Row(
  //         children: [
  //           Radio<bool>(
  //             activeColor: Colors.blue,
  //             value: true,
  //             groupValue: model.isUnique,
  //             onChanged: (bool? value) {
  //               if (value != null) model.setUnique(value);
  //             },
  //           ),
  //           const Text('Unique'),
  //           Radio<bool>(
  //             activeColor: Colors.blue,
  //             value: false,
  //             groupValue: model.isUnique,
  //             onChanged: (bool? value) {
  //               if (value != null) model.setUnique(value);
  //             },
  //           ),
  //           const Text('All'),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildStatusItems(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, model, child) {
        print('Building status items with data: ${model.statusData}');
        return Column(
          children: model.statusData.entries.map((entry) {
            return Column(
              children: [
                _buildStatusItem(entry.key, entry.value.toString()),
                if (model.statusData.entries.last != entry) _buildDivider(),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatusItem(String label, String value) {
    print('Building status item: $label with count: $value');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 1.0,
      color: Colors.grey.withOpacity(0.2), // Adjust opacity as needed
    );
  }

  Widget _buildTotalStatusCount(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Count',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                model.getTotalStatusCount().toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
