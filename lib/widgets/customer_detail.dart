import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/history_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/customer_history.dart';

import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class CustomerDetail extends StatefulWidget {
  final Customer customer;
  final String organizationId;
  final String customerId;
  final VoidCallback onGoBack;

  const CustomerDetail({
    super.key,
    required this.customer,
    required this.organizationId,
    required this.customerId,
    required this.onGoBack,
  });

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("OrganizationId: ${widget.organizationId}");
      print("CustomerId: ${widget.customerId}");

      if (widget.organizationId.isNotEmpty && widget.customerId.isNotEmpty) {
        Provider.of<HistoryProvider>(context, listen: false)
            .fetchCustomerHistories(widget.organizationId, widget.customerId);
      } else {
        print("Error: organizationId or customerId is empty.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final organizationId = arguments?['organizationId'] as String?;
    final customerId = arguments?['customerId'] as String?;

    final defaultProvider = Provider.of<DefaultProvider>(context);
    final provider = Provider.of<CRMFieldsProvider>(context);
    final customFields = provider.customFields;

    final customerProvider = Provider.of<CustomerProvider>(context);
    final selectedCustomer = customerProvider.selectedCustomer;

    // Verify values
    print("Arguments received: $arguments");
    print("OrganizationId: $organizationId");
    print("CustomerId: $customerId");
    return Scaffold(
      backgroundColor: const Color(0xffF2F4F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: widget.onGoBack,
                  child: CustomText(
                    text: "Customer",
                    style: const TextStyle(
                      color: Colors.blue, // Customize as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 5),
                CustomText(
                  text: widget.customer.name.isEmpty
                      ? "Unknown"
                      : widget.customer.name,
                  style: const TextStyle(
                    color: Colors.black, // Customize as needed
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffFFFBF4),
                          border: Border.all(color: Colors.blue, width: 0.3),
                        ),
                        padding: EdgeInsets.all(20),
                        child: _buildCustomerHeader(),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffFFFBF4),
                          border: Border.all(
                              color: Colors.orange.shade900, width: 0.3),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // _buildCustomerHeader(),

                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xfff5f6f9),
                                  ),
                                  child: _buildCustomerInfo(
                                      "Email", widget.customer.email),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xfff5f6f9),
                                  ),
                                  child: _buildCustomerInfo(
                                      "Company", widget.customer.company),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xfff5f6f9),
                                  ),
                                  child: _buildCustomerInfo(
                                      "Address", widget.customer.address),
                                ),
                                const SizedBox(height: 10),

                                // Display extraFields
                                if (widget.customer.extraFields.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: widget
                                        .customer.extraFields.entries
                                        .map(
                                          (entry) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0), // Add gap here
                                            child: Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color:
                                                      const Color(0xfff5f6f9),
                                                ),
                                                child: _buildCustomerInfo(
                                                  entry.key,
                                                  entry.value.toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 600, // Adjust the height as needed
                    child: CustomerHistory(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerHeader() {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          children: [
            CircleAvatar(
              child: Text(widget.customer.name.isNotEmpty
                  ? widget.customer.name[0]
                  : 'U'),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.customer.name.isEmpty
                        ? "Unknown"
                        : widget.customer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  CustomText(
                      text: widget.customer.phone.isEmpty
                          ? "--"
                          : widget.customer.phone),
                ],
              ),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.call, color: Colors.blue),
                onPressed: () {
                  // Handle call button press
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        CustomText(
          text: value.isEmpty ? '--' : value,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 20,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 500,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: double.infinity,
                height: 600,
                color: Colors.grey[300],
              ),
            ],
          )
        ],
      ),
    );
  }
}
