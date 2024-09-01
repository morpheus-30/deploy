import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/followups_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/followups_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_header.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/search_bar.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';

class Followups extends StatefulWidget {
  const Followups({super.key});

  @override
  State<Followups> createState() => _FollowupsState();
}

class _FollowupsState extends State<Followups> {
  String selectedFilter = 'Date: New to Old';
  // String selectedFilter = '';

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<FollowupsProvider>(context, listen: false).fetchFollowups();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FollowupsProvider>(context, listen: false);
      provider.fetchFollowups();
      provider.sortFollowups(selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            // Search and Filter widgets outside of Consumer
            Row(
              children: [
                CustomText(
                  text:
                      "${Provider.of<FollowupsProvider>(context).followups.length}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 10),
                CustomText(
                  text: "Followups",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                // SearchPage(
                //   hintText: 'Search by Name/Phone/Company',
                //   dataList: Provider.of<FollowupsProvider>(context)
                //       .followups
                //       .map((followup) => followup.name)
                //       .toList(),
                //   onChanged: (query) {
                //     // Handle search query change
                //     print('Search query: $query');
                //   },
                // ),
                Consumer<FollowupsProvider>(
                  builder: (context, provider, child) {
                    return SearchPage(
                      hintText: 'Search by Name/Phone/Company',
                      onChanged: (query) {
                        provider.searchFollowups(query);
                      },
                      dataList: [],
                    );
                  },
                ),

                // Consumer<FollowupsProvider>(
                //   builder: (context, provider, child) {
                //     return SearchPage(
                //       hintText: 'Search by Name/Phone/Company',
                //       dataList: provider.followups
                //           .map((followup) => followup.name)
                //           .toList(),
                //       onChanged: (query) {
                //         // Handle search query change
                //         print('Search query: $query');
                //       },
                //     );
                //   },
                // ),
                const SizedBox(width: 10),
                CustomDropdown(
                  items: const [
                    {
                      'value': 'Name: A-Z',
                      'icon': Icons.people_outline_rounded
                    },
                    {'value': 'Date: New to Old', 'icon': Icons.calendar_today},
                    {'value': 'Date: Old to New', 'icon': Icons.calendar_today},
                  ],
                  hintText: selectedFilter,
                  hintIcon: Icons.calendar_today,
                  onSelected: (String value) {
                    setState(() {
                      selectedFilter = value;
                    });
                    Provider.of<FollowupsProvider>(context, listen: false)
                        .sortFollowups(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Wrap HeaderRow and ListView.builder with Consumer
            Expanded(
              child: Consumer<FollowupsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.blue,
                        size: 30,
                      ),
                    );
                  } else if (provider.followups.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/no_data.svg', // Ensure this path is correct
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 20),
                          CustomText(text: 'No Data to display'),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      const HeaderRow(
                        titles: [
                          'Customer Name',
                          'Followup On',
                          'Current Owner',
                          'Created on',
                          'Company',
                          'Action'
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.followups.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                FollowupRow(
                                    followup: provider.followups[index]),
                                if (index < provider.followups.length - 1)
                                  Divider(
                                    height: 1.0,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowupRow extends StatelessWidget {
  final Followup followup;

  const FollowupRow({super.key, required this.followup});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<FollowupsProvider>(context, listen: false)
            .selectFollowup(followup);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Details()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child:
                        Text(followup.name.isNotEmpty ? followup.name[0] : 'U'),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          followup.name.isEmpty ? 'Unknown' : followup.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(followup.phone.isEmpty ? '--' : followup.phone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(followup.status['nextFollowUp'] ?? '--'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(followup.status['agent'] ?? '--'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(followup.createdOn.isEmpty
                      ? '--'
                      : formatCreatedOn(followup.createdOn)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(followup.company.isEmpty ? '--' : followup.company),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () {
                      // Handle edit action
                    },
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
