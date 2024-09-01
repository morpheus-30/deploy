import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_details_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/allocations_provider.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';
import 'package:seeds_ai_callmate_web_app/widgets/filter.dart';

class CreateLeads extends StatefulWidget {
  const CreateLeads({super.key});

  @override
  State<CreateLeads> createState() => _CreateLeadsState();
}

class _CreateLeadsState extends State<CreateLeads> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController customerController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController assignedEmployeeController =
      TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<String> tags = [];
  // List<String> tags = tags.isNotEmpty ? tags : [];
  String? selectedCustomerPhone;
  String? selectedCustomerId;
  String agentPhoneNumber = '';

  String _removeCountryCode(String phone) {
    if (phone.startsWith("+91")) {
      return phone.substring(3);
    }
    return phone;
  }

  String _formatPhoneNumber(String phone) {
    // If the phone number doesn't start with "+91", add it
    if (!phone.startsWith("+91")) {
      return "+91$phone";
    }
    return phone;
  }

  Future<void> _assignCustomerToAgent(
      String assignedEmployee, String phone) async {
    print('DEBUG: Starting _assignCustomerToAgent...');
    if (phoneController.text.isEmpty) {
      print('DEBUG: Phone number is empty, cannot assign customer to agent');
      return;
    }

    // Get the phone number from the controller
    phone = phoneController.text;
    print('DEBUG: Phone number retrieved from controller: $phone');

    final agentsCollection = FirebaseFirestore.instance
        .collection('/organizations/ABC-1234-999/agents');

    print('DEBUG: Fetching agent documents from Firestore...');
    final querySnapshot = await agentsCollection.get();

    for (var doc in querySnapshot.docs) {
      final agentData = doc.data();
      final agentName = agentData['name']?.toString() ?? '';

      print('DEBUG: Checking agent name: $agentName');

      if (agentName.toLowerCase() == assignedEmployee.toLowerCase()) {
        print('DEBUG: Found matching agent: $agentName');

        final customerCollection =
            agentsCollection.doc(doc.id).collection('customers');

        final customerData = {
          'id': phone,
          // Add any additional customer fields here
        };

        print('DEBUG: Agent ID: ${doc.id}, Phone Number: $phone');

        if (doc.id.isNotEmpty && phone.isNotEmpty) {
          print('DEBUG: Assigning customer to agent...');
          await customerCollection.doc(phone).set(customerData);
          print(
              'DEBUG: Customer assigned to agent: $agentName (ID: ${doc.id})');
          return;
        } else {
          print('DEBUG: Error: Agent ID or phone number is empty');
        }
      }
    }

    print(
        'DEBUG: No matching agent found for the assigned employee: $assignedEmployee');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Customers"),
                      FilterSort(
                          collectionPath:
                              '/organizations/ABC-1234-999/customers',
                          hintText: 'Select',
                          onSelected: (selectedCustomer) async {
                            print('Selected Customer: $selectedCustomer');
                            customerController.text = selectedCustomer;

                            // Fetch all customer documents
                            final customerCollection =
                                FirebaseFirestore.instance.collection(
                                    '/organizations/ABC-1234-999/customers');

                            final querySnapshot =
                                await customerCollection.get();

                            // Initialize a variable to hold the phone number
                            String? phone;

                            // Iterate through documents to find the matching customer
                            for (var doc in querySnapshot.docs) {
                              final customerData = doc.data();
                              final name =
                                  customerData['name']?.toString() ?? '';
                              phone = customerData['phone'] ?? '';

                              if (name.toLowerCase() ==
                                  selectedCustomer.toLowerCase()) {
                                // Found the matching customer
                                print('Found matching customer: $name');
                                break; // Exit loop once the match is found
                              }
                            }

                            if (phone != null && phone.isNotEmpty) {
                              // Remove country code and set phone number
                              phoneController.text = _removeCountryCode(phone);
                              print(
                                  'Phone number found for customer: $selectedCustomer, Phone: ${phoneController.text}');
                            } else {
                              print(
                                  'Phone number not found for customer: $selectedCustomer');
                            }
                          })
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Assigned Employees"),
                      const SizedBox(height: 5),
                      CustomDropdown(
                        firestorePath: '/organizations/ABC-1234-999/agents',
                        hintText: 'ALL',
                        onSelected: (selectedEmployee) async {
                          print(
                              'DEBUG: Selected assigned employee: $selectedEmployee');
                          assignedEmployeeController.text = selectedEmployee;

                          try {
                            final agentDocs =
                                await _firestoreService.fetchAllAgentIds();
                            print('DEBUG: Fetched agent IDs: $agentDocs');

                            for (var agentId in agentDocs) {
                              final agentDoc = await _firestoreService
                                  .fetchAgentDetails('ABC-1234-999', agentId);
                              final agentDetails =
                                  EmployeeDetails.fromFirestore(
                                      agentDoc.data()!);

                              print(
                                  'DEBUG: Checking agent: ${agentDetails.name}, Phone: ${agentDetails.phone}');

                              if (agentDetails.name == selectedEmployee) {
                                agentPhoneNumber = agentDetails.phone;
                                print(
                                    'DEBUG: Found matching agent: ${agentDetails.name} with phone: $agentPhoneNumber');
                                break;
                              }
                            }
                          } catch (e) {
                            print('ERROR: Error fetching agent details: $e');
                            throw Exception('Failed to fetch agent details');
                          }

                          if (agentPhoneNumber.isEmpty) {
                            print(
                                'ERROR: Failed to fetch the agent\'s phone number');
                            throw Exception(
                                'Failed to fetch the agent\'s phone number');
                          }

                          // Store the selected agent's phone number for later use
                          selectedCustomerPhone = agentPhoneNumber;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an employee';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Tags"),
                      const SizedBox(height: 5),
                      CustomFormField(
                        controller: tagsController,
                        hintText: 'Type and press enter...',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              // Check if the number of tags is less than 3 before adding
                              if (tags.length < 3) {
                                tags.add(value.trim());
                                tagsController
                                    .clear(); // Clear input field after adding
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'You can only add up to 3 tags.')),
                                );
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            onDeleted: () {
                              setState(() {
                                tags.remove(
                                    tag); // Remove tag when delete icon is pressed
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Notes"),
                      const SizedBox(height: 5),
                      CustomFormField(
                        controller: notesController,
                        hintText: 'Enter note',
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter a note';
                        //   }
                        //   return null;
                        // },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  elevatedButtonText: 'Add',
                  elevatedButtonCallback: () {
                    if (_formKey.currentState!.validate()) {
                      // Collect data from text controllers
                      String name = customerController.text.trim();
                      String assignedto =
                          assignedEmployeeController.text.trim();
                      String notes = notesController.text.trim();

                      // Ensure the selectedCustomerPhone (agent's phone) is collected
                      String agentPhone = selectedCustomerPhone ?? '';
                      if (agentPhone.isEmpty) {
                        print(
                            'ERROR: Agent phone number is empty. Cannot proceed.');
                        return;
                      }

                      // Create a map of customer data
                      Map<String, dynamic> customerData = {
                        'name': name,
                        'status': {
                          'agent':
                              agentPhone, // Correctly assign the agent's phone number
                        },
                        'tags': tags, // Use the tags list here
                        'notes': notes,
                      };

                      print('DEBUG: Form data collected: $customerData');

                      // Save data to Firestore using AllocationProvider
                      Provider.of<AllocationProvider>(context, listen: false)
                          .createOrUpdateCustomer(customerData)
                          .then((_) async {
                        print('DEBUG: Data updated successfully');

                        // Assign customer to the agent (if necessary)
                        await _assignCustomerToAgent(assignedto, agentPhone);

                        Navigator.of(context).pop();
                      }).catchError((e) {
                        print('ERROR: Error updating data: $e');
                      });
                    }
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  elevatedButtonText: 'Cancel',
                  elevatedButtonCallback: () {
                    Navigator.of(context).pop();
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: .5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
