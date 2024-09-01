import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class CustomField extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CustomField({super.key, required this.formKey});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  final Map<String, TextEditingController> textController = {};
  final Map<String, TextEditingController> dateController = {};
  final Map<String, TextEditingController> optionController = {};

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CRMFieldsProvider>(context, listen: false);
    provider
        .fetchCRMFields('ABC-1234-999'); // Replace with actual organization ID
  }

  @override
  void dispose() {
    textController.forEach((_, controller) => controller.dispose());
    dateController.forEach((_, controller) => controller.dispose());
    optionController.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultProvider = Provider.of<DefaultProvider>(context);
    final provider = Provider.of<CRMFieldsProvider>(context);
    final customFields = provider.customFields;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text('Custom Fields'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var field in customFields) ...[
                    if (field.type == 'textfield') ...[
                      Row(
                        children: [
                          CustomText(text: field.name),
                          if (field.field == 'mandatory')
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      // CustomFormField(
                      //   controller: textController[field.name] ??=
                      //       TextEditingController(),
                      //   fillColor: Colors.white,
                      //   initialValue: provider.fieldValues[field.name] ?? '',
                      //   validator: field.field == 'mandatory'
                      //       ? (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter ${field.name}';
                      //           }
                      //           return null;
                      //         }
                      //       : null,
                      //   hintText: 'Enter ${field.name}',
                      //   inputType: TextInputType.text,
                      //   onChanged: (value) {
                      //     defaultProvider.updateText(value);
                      //   },
                      // ),

                      CustomFormField(
                        controller: textController[field.name] ??=
                            TextEditingController(
                                text: provider.fieldValues[field.name] ?? ''),
                        fillColor: Colors.white,
                        validator: field.field == 'mandatory'
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${field.name}';
                                }
                                return null;
                              }
                            : null,
                        hintText: 'Enter ${field.name}',
                        inputType: TextInputType.text,
                        onChanged: (value) {
                          defaultProvider.updateText(value);
                        },
                      ),

                      const SizedBox(height: 10),
                    ],
                    if (field.type == 'date') ...[
                      Row(
                        children: [
                          CustomText(text: field.name),
                          if (field.field == 'mandatory')
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            // initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(selectedDate);

                            // Update the date controller's text
                            dateController[field.name]?.text = formattedDate;

                            // Update the provider with the selected date
                            provider.updateFieldValue(
                                field.name, formattedDate);
                            defaultProvider.updateDate(selectedDate);

                            //  await provider.saveData();
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomFormField(
                            controller: dateController[field.name] ??=
                                TextEditingController(
                                    text: provider.fieldValues[field.name] ??
                                        'Select Date'),
                            hintText: 'Enter ${field.name}',
                            validator: field.field == 'mandatory'
                                ? (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == 'Select Date') {
                                      return 'Please select ${field.name}';
                                    }
                                    return null;
                                  }
                                : null,
                          ),

                          //  CustomFormField(
                          //   controller: dateController[field.name] ??=
                          //       TextEditingController(
                          //           text: provider.fieldValues[field.name] ??
                          //               'Select Date'),
                          //   initialValue: provider.fieldValues[field.name] ??
                          //       'Select Date',
                          //   hintText: 'Enter ${field.name}',
                          //   validator: field.field == 'mandatory'
                          //       ? (value) {
                          //           if (value == null ||
                          //               value.isEmpty ||
                          //               value == 'Select Date') {
                          //             return 'Please select ${field.name}';
                          //           }
                          //           return null;
                          //         }
                          //       : null,
                          //   // onChanged: (value) {
                          //   //   defaultProvider.updateDate(selectedDate);
                          //   // },
                          // ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (field.type == 'options') ...[
                      Row(
                        children: [
                          CustomText(text: field.name),
                          if (field.field == 'mandatory')
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        value: provider.fieldValues[field.name],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          hintText: 'Select ${field.name}',
                        ),
                        items: field.options!.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        validator: field.field == 'mandatory'
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select ${field.name}';
                                }
                                return null;
                              }
                            : null,
                        onChanged: (value) {
                          optionController[field.name] ??=
                              TextEditingController(text: value!);
                          defaultProvider.updateOption(value!);
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  final FirestoreService _firestoreService = FirestoreService();
// Future<void> _updateBackendDate(String fieldName, String date) async {
//     try {
//       // Assuming you have a service method to update the date
//       await _firestoreService.updateField(fieldName, date);
//       print('Date successfully updated on the backend.');
//     } catch (e) {
//       print('Error updating date on the backend: $e');
//     }
//   }
