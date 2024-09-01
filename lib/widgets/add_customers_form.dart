import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_fields.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/personal_information_section.dart';
import 'package:seeds_ai_callmate_web_app/widgets/priority_field.dart';

class AddCustomers extends StatefulWidget {
  const AddCustomers({super.key});

  @override
  State<AddCustomers> createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customFieldFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _priorityFieldFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otherNotesFormKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];
  StreamSubscription<QuerySnapshot>? _customersSubscription;
  List<DocumentSnapshot> _allCustomers = [];

  Timer? _debounce; // Timer for debouncing input

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DefaultProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF2F4F7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: "Mobile Number"),
                            const SizedBox(width: 2),
                            CustomText(
                              text: "*",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffFDFBF9),
                          ),
                          child: IntlPhoneField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                // labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              validator: (phoneNumber) {
                                if (phoneNumber == null ||
                                    phoneNumber.number.isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                try {
                                  if (!phoneNumber.isValidNumber()) {
                                    return 'Please enter a valid phone number';
                                  }
                                } catch (e) {
                                  if (e is NumberTooShortException) {
                                    return 'Phone number is too short';
                                  } else if (e is NumberTooLongException) {
                                    return 'Phone number is too long';
                                  } else {
                                    print('Error validating phone number: $e');
                                    return 'Invalid phone number format';
                                  }
                                }
                                return null;
                              },
                              onChanged: (phone) {
                                if (phone.completeNumber.isNotEmpty &&
                                    phone.isValidNumber()) {
                                  provider
                                      .updatePhoneNumber(phone.completeNumber);
                                } else {
                                  print('Invalid phone number');
                                }
                              }
                              // onChanged: (phone) {
                              //   provider.updatePhoneNumber(phone.completeNumber);
                              // },
                              ),
                        ),
                        if (suggestions.isNotEmpty) ...{
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                Column(
                                  children: suggestions.map((customer) {
                                    return ListTile(
                                      title: Text(customer['name'] ?? ''),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(customer['phone'] ?? ''),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          // Extract only the local part of the phone number (excluding the country code)
                                          final phoneNumber =
                                              customer['phone'] ?? '';
                                          final localPhoneNumber =
                                              phoneNumber.replaceFirst(
                                                  RegExp(r'^\+\d{1,2}'), '');

                                          phoneController.text =
                                              localPhoneNumber;

                                          // Update the provider with the full phone number, ensuring it includes +91
                                          final fullPhoneNumber =
                                              '+91$localPhoneNumber';
                                          Provider.of<DefaultProvider>(context,
                                                  listen: false)
                                              .updatePhoneNumber(
                                                  fullPhoneNumber);

                                          suggestions.clear();
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        }
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PersonalInforSec(formKey: _personalInfoFormKey),
                        const SizedBox(height: 10),
                        CustomField(formKey: _customFieldFormKey),
                        const SizedBox(height: 10),
                        PriorityField(formKey: _priorityFieldFormKey),
                        const SizedBox(height: 10),
                        const OtherNotes(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: CustomButton(
                      elevatedButtonText: 'Submit',
                      elevatedButtonCallback: _submitForm,
                      elevatedButtonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setupCustomersListener();
    phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _customersSubscription?.cancel();
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }

  void _setupCustomersListener() {
    final organizationId =
        Provider.of<CustomerProvider>(context, listen: false).organizationId;
    if (organizationId == null) {
      print('Organization ID is null');
      return;
    }
    _customersSubscription = FirebaseFirestore.instance
        .collection('organizations')
        .doc(organizationId)
        .collection('customers')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _allCustomers = snapshot.docs;
      });
      _filterCustomers(phoneController.text);
    });
  }

  void _onPhoneChanged() {
    _filterCustomers(phoneController.text);
  }

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      setState(() {
        suggestions.clear();
      });
      return;
    }

    final normalizedQuery = query.replaceAll(RegExp(r'\D'), '').toLowerCase();

    setState(() {
      suggestions = _allCustomers.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final phone = (data['phone'] as String?)
                ?.replaceAll(RegExp(r'\D'), '')
                .toLowerCase() ??
            '';
        final name = (data['name'] as String?)?.toLowerCase() ?? '';
        final email = (data['email'] as String?)?.toLowerCase() ?? '';

        return phone.contains(normalizedQuery) ||
            name.contains(normalizedQuery) ||
            email.contains(normalizedQuery);
      }).map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] as String? ?? 'Unknown',
          'phone': data['phone'] as String? ?? '',
        };
      }).toList();
    });

    print('Search completed. Found ${suggestions.length} suggestions.');
  }

//////////////
  Future<void> _submitForm() async {
    if (_validateAllForms()) {
      try {
        final provider = Provider.of<DefaultProvider>(context, listen: false);
        await provider.saveToFirestore();
        _showSuccessMessage();
        _resetForm();
      } catch (e) {
        _showErrorMessage(e.toString());
      }
    } else {
      _showValidationErrorMessage();
    }
  }

//   Future<void> _submitForm() async {
//   if (_validateAllForms()) {
//     try {
//       final provider = Provider.of<DefaultProvider>(context, listen: false);

//       // // Replace these with actual values
//       // final phoneNumber = _phoneNumberController.text; // Example value
//       // final name = _nameController.text; // Example value

//       await provider.saveToFirestore(assignedAgentId,organizationId); // Pass the required arguments
//       _showSuccessMessage(); // Show success message
//       _resetForm(); // Reset the form fields
//     } catch (e) {
//       _showErrorMessage(e.toString()); // Show error message if an exception occurs
//     }
//   } else {
//     _showValidationErrorMessage(); // Show validation error message if the form is invalid
//   }
// }

  bool _validateAllForms() {
    if (_formKey.currentState == null ||
            _personalInfoFormKey.currentState == null ||
            _customFieldFormKey.currentState == null ||
            _priorityFieldFormKey.currentState == null
        // ||
        // _otherNotesFormKey.currentState == null
        ) {
      // Handle the case where one or more form keys are null
      print('One or more form keys are null');
      return false;
    }

    return _formKey.currentState!.validate() &&
        _personalInfoFormKey.currentState!.validate() &&
        _customFieldFormKey.currentState!.validate() &&
        _priorityFieldFormKey.currentState!.validate();
    // &&
    // _otherNotesFormKey.currentState!.validate();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showValidationErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all required fields correctly.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _personalInfoFormKey.currentState!.reset();
    _customFieldFormKey.currentState!.reset();
    _priorityFieldFormKey.currentState!.reset();
    _otherNotesFormKey.currentState!.reset();
    phoneController.clear();
    setState(() {
      suggestions.clear();
    });
  }
}
