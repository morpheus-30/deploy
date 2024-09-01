import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seeds_ai_callmate_web_app/models/import_file_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';
import 'package:seeds_ai_callmate_web_app/widgets/filter.dart';

class ImportCustomers extends StatefulWidget {
  // final List<Map<String, dynamic>> fileData;
  const ImportCustomers({
    super.key,
  });

  @override
  State<ImportCustomers> createState() => _ImportCustomersState();
}

class _ImportCustomersState extends State<ImportCustomers> {
  String? fileName;
  List<String> headers = [];
  List<Map<String, dynamic>> fileData = []; // Store CSV headers here
  int currentStep = 1;

  // Future<void> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['csv'],
  //   );

  //   if (result != null) {
  //     String csvText = String.fromCharCodes(result.files.single.bytes!);
  //     List<List<dynamic>> csvTable =
  //         const CsvToListConverter().convert(csvText);

  //     if (csvTable.isNotEmpty && csvTable[0].isNotEmpty) {
  //       setState(() {
  //         headers = List<String>.from(csvTable[0]);
  //         fileData = csvTable
  //             .skip(1)
  //             .map((row) => Map<String, dynamic>.fromIterables(headers, row))
  //             .toList();
  //         fileName = result.files.single.name;
  //         currentStep = 2; // Move to step 2 after file selection
  //       });
  //     }
  //   }
  // }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String csvText = String.fromCharCodes(result.files.single.bytes!);
        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvText);

        if (csvTable.isNotEmpty && csvTable[0].isNotEmpty) {
          setState(() {
            headers = List<String>.from(csvTable[0]);
            fileData = csvTable
                .skip(1)
                .map((row) => Map<String, dynamic>.fromIterables(headers, row))
                .toList();
            fileName = result.files.single.name;
            currentStep = 2;
          });
        }
      }
    } catch (e) {
      print('Error picking or parsing file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick or parse file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentStep == 1) ...[
            CustomText(
              text: "Step 1: Upload Leads",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              text: "Leads can be imported using CSV files",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            CustomText(
              text: "Please note that the name and number fields are required",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            CustomText(
              text:
                  "If you want to assign multiple telecallers, please separate their numbers by semicolon",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            fileName ?? 'No file chosen',
                            style: TextStyle(
                              color:
                                  fileName != null ? Colors.black : Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          CustomButton(
                            elevatedButtonText: 'Choose file',
                            elevatedButtonCallback: pickFile,
                            elevatedButtonStyle: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (currentStep == 2) ...[
            CustomersMap(
              headers: headers,
              fileData: fileData,
            ),
          ],
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class CustomersMap extends StatefulWidget {
  final List<String> headers;
  final List<Map<String, dynamic>> fileData;

  const CustomersMap(
      {super.key, required this.headers, required this.fileData});

  @override
  State<CustomersMap> createState() => _CustomersMapState();
}

class _CustomersMapState extends State<CustomersMap> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController categoriesController = TextEditingController();
  final Map<String, String> fieldMappings = {};
  final Map<String, TextEditingController> controllers = {};

  int currentStep = 2; // Start at step 2 by default

  void goToNextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      bool allFieldsMapped =
          fieldMappings.values.every((value) => value.isNotEmpty);
      if (allFieldsMapped) {
        setState(() {
          currentStep = 3; // Move to step 3
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please map all the required fields.')),
        );
      }
    } else {
      // Trigger validation for all fields if the form is not valid
      _formKey.currentState?.validate();
    }
  }

  void resetFields() {
    // Clear all TextEditingController values
    for (var controller in controllers.values) {
      controller.clear();
    }

    // Clear all field mappings
    setState(() {
      fieldMappings.clear();
    });

    // Trigger form validation to clear any error messages
    if (_formKey.currentState != null) {
      _formKey.currentState!.reset(); // Reset the form state
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (currentStep == 2) ...[
            CustomText(
              text: "Step 2: Map Fields",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Generate field mapping UI dynamically based on headers
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildFieldMapping("Name"),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: buildFieldMapping("Phone"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildFieldMapping("Email"),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: buildFieldMapping("Address"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Expanded(
                    //   child: buildFieldMapping("Category"),
                    // ),

                    Expanded(
                      child: buildFieldMapping("Company"),
                    ),

                    // const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 10),
                // Row(
                //   children: [
                //     Expanded(
                //       child: buildFieldMapping("Status"),
                //     ),
                //   ],
                // ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  elevatedButtonText: 'Reset',
                  elevatedButtonCallback: resetFields,
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
                const SizedBox(width: 10),
                CustomButton(
                  elevatedButtonText: 'Next',
                  elevatedButtonCallback: goToNextStep,
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (currentStep == 3) ...[
            CustomersInfo(
              fieldMappings: fieldMappings,
              fileData: widget.fileData,
            ),
          ]
        ]),
      ),
    );
  }

  Widget buildFieldMapping(String field) {
    controllers[field] = TextEditingController();
    return FormField<String>(
      initialValue: '', // Set an initial value if needed
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(text: field),
                CustomText(
                  text: "*",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            CustomDropdown(
              controller: controllers[field]!,
              items: widget.headers.map((header) => {'value': header}).toList(),
              hintText: 'None',
              onSelected: (String? selectedValue) {
                controllers[field]!.text = selectedValue!;
                fieldMappings[field] = selectedValue;
                state.didChange(selectedValue); // Notify that value has changed
              },
              validator: (value) {
                if (value == null || value.isEmpty || value == 'None') {
                  return 'Please map with the fields';
                }
                return null; // Return null if validation passes
              },
            ),
            // Display validation error message if any
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty || value == 'None') {
          return 'Please map with the fields';
        }
        return null; // Return null if validation passes
      },
    );
  }
}

class CustomersInfo extends StatefulWidget {
  final Map<String, String> fieldMappings;
  final List<Map<String, dynamic>> fileData;

  const CustomersInfo(
      {super.key, required this.fieldMappings, required this.fileData});

  @override
  State<CustomersInfo> createState() => _CustomersInfoState();
}

class _CustomersInfoState extends State<CustomersInfo> {
  final TextEditingController tagController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController assignController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();

  List<String> tags = [];
  String selectedCategory = '';
  void importData() async {
    print('Import button pressed');
    try {
      // Map file data to ImportData objects
      List<ImportData> dataToImport = widget.fileData.map((row) {
        print('Processing row: $row'); // Log the entire row

        Map<String, dynamic> mappedRow = {};
        widget.fieldMappings.forEach((csvHeader, mappedField) {
          var value = row[csvHeader];
          if (value != null) {
            mappedRow[mappedField] = value;
          }
          print(
              'CSV Header: $csvHeader, Mapped Field: $mappedField, Value: $value');
        });

        print('Mapped Row: $mappedRow'); // Log the mapped row

        // Extract and trim phone number
        String phone = (mappedRow['Phone'] as String?)?.trim() ?? '';

        print('Processing phone number: "$phone"');

        if (phone.isEmpty) {
          print('Phone number is empty for data: $mappedRow');
          throw Exception('Phone number must not be empty');
        }

        return ImportData(
          name: mappedRow['Name'] ?? '',
          phone: phone,
          email: mappedRow['Email'] ?? '',
          address: mappedRow['Address'] ?? '',
          category: selectedCategory,
          company: mappedRow['Company'] ?? '',
          // status: {
          //   'agent': mappedRow['status']?['agent'] ?? '',
          //   'type': mappedRow['status']?['type'] ?? '',
          // },
          tags: tags,
          notes: notesController.text.trim(),
          // tags: List<String>.from(mappedRow['tags'] ?? []),
          createdOn: DateTime.now().toIso8601String(),

          // createdOn:
          //     mappedRow['createdOn'] ?? ImportData.getFormattedDateTime(),
        );
      }).toList();

      print('Mapped Data to be saved: $dataToImport');

      FirestoreService firestoreService = FirestoreService();
      for (var importData in dataToImport) {
        await firestoreService.saveImportData(importData);
        print('Saved data for ${importData.name}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data imported successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error during import: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DefaultProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(0), // Add padding here
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Step 3: Import Information",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8), // Add padding here
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // Use a lighter shade
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                CustomText(
                  text: widget.fileData.length.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 5),
                CustomText(
                  text: "Leads",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Increase spacing here
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Tags",
                    ),
                    const SizedBox(height: 5), // Add spacing here
                    CustomFormField(
                      controller: tagController,
                      hintText: 'Type and press enter.....',
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            // Check if the number of tags is less than 3 before adding
                            if (tags.length < 3) {
                              tags.add(value.trim());
                              tagController
                                  .clear(); // Clear input field after adding
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('You can only add up to 3 tags.')),
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
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(text: "Categories"),
                      CustomText(
                        text: "*",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
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
                        selectedCategory = value;
                      });
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
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       CustomText(
              //         text: "Select Employee",
              //       ),
              //       const SizedBox(height: 5), // Add spacing here
              //       FilterSort(
              //         controller: assignController,
              //         collectionPath: '/organizations/ABC-1234-999/agents',
              //         hintText: 'Select',
              //         onSelected: (value) {
              //           // setState(() {
              //           //   provider.updateAssignTo(value);
              //           // });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Notes",
                    ),
                    const SizedBox(height: 5), // Add spacing here
                    CustomFormField(
                      controller: notesController,
                      hintText: 'Enter notes',
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          CustomButton(
            elevatedButtonText: 'Import',
            elevatedButtonCallback: importData,
            elevatedButtonStyle: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// void importData() async {
  //   // Prepare data for Firestore
  //   List<Map<String, dynamic>> dataToImport = widget.fileData.map((row) {
  //     Map<String, dynamic> mappedRow = {};
  //     widget.fieldMappings.forEach((csvHeader, mappedField) {
  //       mappedRow[mappedField] = row[csvHeader];
  //     });
  //     return mappedRow;
  //   }).toList();

  //   print('Mapped Data to be saved: $dataToImport');

  //   // Using Provider to store data in Firestore
  //   FirestoreService firestoreService = FirestoreService();
  //   for (var data in dataToImport) {
  //     data['tags'] = tagController.text; // Add tags to each data row
  //     // await firestoreService.saveImportData(data as ImportData);
  //     await firestoreService.addCustomerData(data);
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Data imported successfully')),
  //   );
  //   Navigator.of(context).pop();
  // }
