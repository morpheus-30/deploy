// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:shimmer/shimmer.dart';

import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_header.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/customer_detail.dart';
import 'package:seeds_ai_callmate_web_app/widgets/filter.dart';
import 'package:seeds_ai_callmate_web_app/widgets/import_customers_list.dart';
import 'package:seeds_ai_callmate_web_app/widgets/search_bar.dart';

// Ensure you have this package

class CustomersLeds extends StatefulWidget {
  const CustomersLeds({super.key});

  @override
  State<CustomersLeds> createState() => _CustomersLedsState();
}

class _CustomersLedsState extends State<CustomersLeds> {
  late FirestoreService _firestoreService; // Add this line
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final customerProvider =
  //         Provider.of<CustomerProvider>(context, listen: false);

  //     // Set the organization ID dynamically
  //     String organizationId = 'ABC-1234-999'; // Example dynamic ID
  //     customerProvider.setOrganizationId(organizationId);

  //     // Load customers based on the set organization ID
  //     customerProvider.loadCustomers();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Initialize Firestore service here
    _firestoreService =
        FirestoreService(); // Ensure this is correctly initialized

    // Fetch organization IDs and set the first one
    _fetchOrganizationIds();
  }

  Future<void> _fetchOrganizationIds() async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    try {
      // Fetch all organization IDs
      List<String> organizationIds =
          await _firestoreService.getAllOrganizationIDs();

      if (organizationIds.isNotEmpty) {
        // Example: Set the first organization ID from the list
        String organizationId = organizationIds.first;

        // Set the organization ID dynamically
        customerProvider.setOrganizationId(organizationId);

        // Load customers based on the set organization ID
        customerProvider.loadCustomers();
      } else {
        print("No organization IDs found.");
      }
    } catch (e) {
      print("Error fetching organization IDs: $e");
    }
  }

  void _deselectCustomer() {
    Provider.of<CustomerProvider>(context, listen: false).deselectCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4F7),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                // Conditionally render the header row (Search, Filter, Import)
                if (provider.selectedCustomer == null)
                  provider.isLoading
                      ? _buildLoadingHeader()
                      : _buildHeader(provider),
                const SizedBox(height: 20),

                // Content
                Expanded(
                  child: provider.isLoading
                      ? _buildLoadingContent()
                      : provider.customers.isEmpty
                          ? _buildNoDataContent()
                          : provider.selectedCustomer != null
                              ? CustomerDetail(
                                  customer: provider.selectedCustomer!,
                                  organizationId: provider.organizationId ?? '',
                                  customerId: provider.selectedCustomerId ?? '',
                                  onGoBack: _deselectCustomer,
                                )
                              : _buildCustomerList(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Shimmer loading effect for the header (Search, Filter, Import)
  Widget _buildLoadingHeader() {
    return Row(
      children: [
        _buildShimmerBox(width: 100, height: 18), // Customer count
        const SizedBox(width: 10),
        _buildShimmerBox(width: 100, height: 18), // Customers label
        const Spacer(),
        Expanded(
          flex: 2,
          child: _buildShimmerBox(width: double.infinity, height: 50), // Search
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildShimmerBox(width: double.infinity, height: 50), // Filter
        ),
        const SizedBox(width: 10),
        _buildShimmerBox(width: 100, height: 50), // Import button
      ],
    );
  }

  // Actual Header with Search, Filter, Import buttons
  Widget _buildHeader(CustomerProvider provider) {
    return Row(
      children: [
        CustomText(
          text: provider.customers.length.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        CustomText(
          text: "Customers",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: SearchPage(
            hintText: 'Search by Name/Phone/Company',
            dataList:
                provider.customers.map((customer) => customer.name).toList(),
            onChanged: (query) {
              print('Search query: $query');
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // child: FilterSort(
          //   collectionPath: '/organizations/ABC-1234-999/agents',
          //   hintText: 'Filters: Select Status',
          //   onSelected: (String) {},
          // ),

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
                collectionPath: '/organizations/$orgID/agents', // Dynamic path
                hintText: 'Filters: Select Employee',
                onSelected: (String selected) {
                  print('Filter selected: $selected');
                },
              );
            },
          ),
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
    );
  }

  // Shimmer loading effect for the content (Customer List)
  Widget _buildLoadingContent() {
    return Column(
      children: [
        const HeaderRow(
          titles: [
            'Name',
            'Address',
            'Company',
            'Category',
            'Created on',
            'Actions'
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 6, // Arbitrary count for shimmer effect
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // No data available widget
  Widget _buildNoDataContent() {
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

  // Customer list view
  Widget _buildCustomerList(CustomerProvider provider) {
    return Column(
      children: [
        const HeaderRow(
          titles: [
            'Name',
            'Address',
            'Company',
            'Category',
            'Created on',
            'Actions'
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.selectCustomer(provider.customers[index]);
                    },
                    child: CustomerRow(
                      customer: provider.customers[index],
                    ),
                  ),
                  if (index < provider.customers.length - 1)
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

  // Helper method to create a shimmer box
  Widget _buildShimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}

class CustomerRow extends StatelessWidget {
  final Customer customer;

  const CustomerRow({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final customerProvider =
            Provider.of<CustomerProvider>(context, listen: false);
        customerProvider.selectCustomer(customer);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Aligns vertically to center
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Aligns vertically to center
                children: [
                  CircleAvatar(
                    child:
                        Text(customer.name.isNotEmpty ? customer.name[0] : 'U'),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Aligns vertically to center
                      children: [
                        Text(
                          customer.name.isEmpty ? 'Unknown' : customer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(customer.phone.isEmpty ? '--' : customer.phone),
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Aligns vertically to center
                children: [
                  Text(customer.address.isEmpty ? '--' : customer.address),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Aligns vertically to center
                children: [
                  Text(customer.company.isEmpty ? '--' : customer.company),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Aligns vertically to center
                children: [
                  Text(customer.category.isEmpty ? '--' : customer.category),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Aligns vertically to center
                children: [
                  Text(customer.createdOn.isEmpty
                      ? '--'
                      : formatCreatedOn(customer.createdOn)),
                ],
              ),
            ),
            Expanded(
              // flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () {},
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
