import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';

class PriorityField extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PriorityField({super.key, required this.formKey});

  @override
  State<PriorityField> createState() => _PriorityFieldState();
}

class _PriorityFieldState extends State<PriorityField> {
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController assignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DefaultProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Assign to"),
              CustomDropdown(
                controller: assignController,
                firestorePath: '/organizations/ABC-1234-999/agents',
                hintText: 'Select',
                onSelected: (selectedAgentName) async {
                  String phoneNumber = provider.phoneNumber;
                  String sanitizedPhoneNumber = _removeCountryCode(phoneNumber);

                  QuerySnapshot agentSnapshot = await FirebaseFirestore.instance
                      .collection('/organizations/ABC-1234-999/agents')
                      .get();

                  DocumentSnapshot? matchedAgent;
                  for (var agentDoc in agentSnapshot.docs) {
                    var agentData = agentDoc.data() as Map<String, dynamic>;
                    String agentName = agentData['name']?.toString() ?? '';

                    if (agentName.toLowerCase() ==
                        selectedAgentName.toLowerCase()) {
                      matchedAgent = agentDoc;
                      break;
                    }
                  }

                  if (matchedAgent != null) {
                    String agentId = matchedAgent.id;

                    await FirebaseFirestore.instance
                        .collection('/organizations/ABC-1234-999/agents')
                        .doc(agentId)
                        .collection('customers')
                        .doc(sanitizedPhoneNumber)
                        .set({
                      'id': sanitizedPhoneNumber,
                    });

                    print('Customer added to agent with ID: $agentId');
                  } else {
                    print('No matching agent found for the selected name.');
                  }
                  setState(() {
                    provider.updatePriority(selectedAgentName);
                  });
                  print('Selected agent: $selectedAgentName');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an agent';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomText(text: "Categories"),
              CustomDropdown(
                controller: categoriesController,
                firestorePath: '/organizations',
                hintText: 'Select a category',
                mapFunction: (docs) {
                  List<Map<String, dynamic>> mapCategories(
                      List<DocumentSnapshot> docs) {
                    List<Map<String, dynamic>> allCategories = [];
                    for (var doc in docs) {
                      var data = doc.data() as Map<String, dynamic>;
                      if (data.containsKey('categories')) {
                        List<dynamic> categories = data['categories'] ?? [];
                        for (var category in categories) {
                          allCategories.add({
                            'value': category['name'] ?? 'Unknown',
                            'type': category['type'] ?? 'Unknown',
                            'color': category['color'] ?? 'Unknown',
                          });
                        }
                      }
                    }
                    return allCategories;
                  }

                  return mapCategories(docs);
                },
                onSelected: (value) {
                  setState(() {
                    provider.updateCategory(value);
                  });
                  print('Selected category: $value');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _removeCountryCode(String phoneNumber) {
    if (phoneNumber.startsWith("+91")) {
      return phoneNumber.substring(3);
    }
    return phoneNumber;
  }
}

class OtherNotes extends StatefulWidget {
  const OtherNotes({super.key});

  @override
  State<OtherNotes> createState() => _OtherNotesState();
}

class _OtherNotesState extends State<OtherNotes> {
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DefaultProvider>(context);
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Notes'),
              CustomFormField(
                controller: notesController,
                onChanged: (value) {
                  setState(() {
                    provider.updateNotes(value);
                  });
                },
              ),
            ],
          ),
        ));
  }
}
