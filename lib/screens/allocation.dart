import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/allocation_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/providers/allocations_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/create_leds.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_header.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/filter.dart';
import 'package:seeds_ai_callmate_web_app/widgets/import_customers_list.dart';
import 'package:seeds_ai_callmate_web_app/widgets/search_bar.dart';

class TeamAllocation extends StatefulWidget {
  const TeamAllocation({super.key}); // Update constructor

  @override
  State<TeamAllocation> createState() => _TeamAllocationState();
}

class _TeamAllocationState extends State<TeamAllocation> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  void initState() {
    super.initState();
    // Fetch allocations when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllocationProvider>(context, listen: false)
          .fetchAllocations();
      // Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
    });
  }

  void _deselectAllocation() {
    Provider.of<AllocationProvider>(context, listen: false)
        .deselectAllocation();
  }

  @override
  Widget build(BuildContext context) {
    const double desktopMinWidth = 800;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Consumer<AllocationProvider>(
                  builder: (context, provider, child) {
                    return CustomText(
                      text: "${provider.allocations.length}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    );
                  },
                ),
                const SizedBox(width: 10),
                CustomText(
                  text: "Allocation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: SearchPage(
                    hintText: 'Search by Name/Phone/Company',
                    dataList:
                        Provider.of<AllocationProvider>(context, listen: false)
                            .allocations
                            .map((allocation) => allocation.name)
                            .toList(),
                    onChanged: (query) {
                      print('Search query: $query');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _firestoreService
                        .getAllOrganizationIDs(), // Fetch organization IDs dynamically
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Text('No organization IDs found');
                      }

                      // Assuming you want to use the first organization ID for this example
                      String orgID = snapshot.data!.first;

                      return FilterSort(
                        collectionPath:
                            '/organizations/$orgID/agents', // Dynamic path
                        hintText: 'Filters: Select Employee',
                        onSelected: (String selected) {
                          print('Filter selected: $selected');
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    CustomButton(
                      elevatedButtonText: 'Create',
                      elevatedButtonCallback: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text('Create Lead'),
                                content: SingleChildScrollView(
                                  child: CreateLeads(),
                                ),
                              );
                            });
                      },
                      elevatedButtonStyle: ElevatedButton.styleFrom(
                        elevation: 0,
                        iconColor: Colors.white,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icons.add,
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      elevatedButtonText: 'Import',
                      elevatedButtonCallback: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text('Import Customers'),
                                content: SingleChildScrollView(
                                  child: ImportCustomers(),
                                ),
                              );
                            });
                      },
                      elevatedButtonStyle: ElevatedButton.styleFrom(
                        elevation: 0,
                        iconColor: Colors.white,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icons.file_upload,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<AllocationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                        child: LoadingAnimationWidget.inkDrop(
                      color: Colors.blue,
                      size: 30,
                    ));
                  } else if (provider.allocations.isEmpty) {
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
                  } else {
                    return Column(
                      children: [
                        const HeaderRow(
                          titles: [
                            'Name',
                            'Category',
                            'Created on',
                            'Current Owner',
                            'Company',
                            'Action'
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.allocations.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  AllocationRow(
                                      allocation: provider.allocations[index]),
                                  if (index < provider.allocations.length - 1)
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllocationRow extends StatelessWidget {
  final Allocation allocation;

  const AllocationRow({super.key, required this.allocation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AllocationProvider>(context, listen: false)
            .selectAllocation(allocation);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Text(
                        allocation.name.isNotEmpty ? allocation.name[0] : 'U'),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          allocation.name.isEmpty ? 'Unknown' : allocation.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                            allocation.phone.isEmpty ? '--' : allocation.phone),
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
                  Text(allocation.category),
                  // Text(allocation.status['type'] ?? '--'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(allocation.createdOn.isEmpty
                      ? '--'
                      : formatCreatedOn(allocation.createdOn)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(allocation.status['agent'] ?? '--'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(allocation.company.isEmpty ? '--' : allocation.company),
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
                      print(
                          'Edit button pressed for allocation: ${allocation.name}');
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
