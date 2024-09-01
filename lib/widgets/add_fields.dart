import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class AddFields extends StatefulWidget {
  final Function(String) onFieldAdded;
  final Function(String)? onOptionAdded;

  const AddFields({
    super.key,
    required this.onFieldAdded,
    this.onOptionAdded,
  });

  @override
  State<AddFields> createState() => _AddFieldsState();
}

class _AddFieldsState extends State<AddFields> {
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _optionController = TextEditingController();
  int? _selectedValue;
  bool _autoFill = true;
  String _selectedOption = '';
  // bool _filterableField = false;
  bool _readonlyField = false;
  bool _mandatoryField = false;
  final List<String> _options = [];
  // final List<Map<String, dynamic>> _options = [];
  // List<Map<String, String>> _options = [];

  final List<String> _fields = [];

  void _addOption() {
    String optionName = _optionController.text.trim();
    if (optionName.isNotEmpty) {
      setState(() {
        _options.add(optionName); // Add option as a string
        _optionController.clear();
      });
      print('Option Added: $_options');
    }
  }

  void _saveField() {
    String fieldName = _fieldNameController.text.trim();
    String fieldType = _getSelectedFieldType();
    // String fieldAttributes = _getCheckboxAttributes();
    String fieldAttributes = _selectedOption;

    if (fieldName.isNotEmpty && fieldType.isNotEmpty) {
      CRMField crmField = CRMField(
        name: fieldName,
        type: fieldType,
        field: fieldAttributes,
        options: _options.isNotEmpty
            ? _options
            : null, // Include options if not empty
      );

      Provider.of<CRMFieldsProvider>(context, listen: false)
          .addCRMField("ABC-1234-999", crmField);

      setState(() {
        _fields.add(fieldName);
        _fieldNameController.clear();
        _selectedValue = null;
        _selectedOption = '';
        // _autoFill = false;
        // // _filterableField = false;
        // _readonlyField = false;
        // _mandatoryField = false;
        _options.clear();
      });

      widget.onFieldAdded(fieldName);
      Navigator.of(context).pop();
    }
  }

  String _getSelectedFieldType() {
    switch (_selectedValue) {
      case 0:
        return 'textfield';
      case 1:
        return 'number';
      case 2:
        return 'date';
      case 3:
        return 'options';
      case 4:
        return 'multi-options';
      default:
        return '';
    }
  }

  String _getCheckboxAttributes() {
    List<String> attributes = [];
    if (_autoFill) attributes.add('autofill');
    // if (_filterableField) attributes.add('filterable');
    if (_readonlyField) attributes.add('readonly');
    if (_mandatoryField) attributes.add('mandatory');
    return attributes.join(',');
  }

  void _showDialog({
    required Widget child,
    required double widthFactor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * widthFactor,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _addFieldDialog() {
    _showDialog(
      child: AddFields(
        onFieldAdded: (fieldName) {
          setState(() {
            _fields.add(fieldName);
          });
        },
      ),
      widthFactor: 0.5,
    );
  }

  //

  void _addOptionDialog() {
    _showDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CustomFormField(
            controller: _optionController,
            hintText: 'Enter option',
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              elevatedButtonText: 'Save',
              elevatedButtonCallback: () {
                _addOption();
                Navigator.of(context).pop();
              },
              elevatedButtonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      widthFactor: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF2F4F7),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text("Field Name",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("*", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          CustomFormField(
                            fillColor: Colors.white,
                            controller: _fieldNameController,
                            hintText: 'Enter Field name',
                          ),
                          const SizedBox(height: 20),
                          const Text("Field Type",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: fieldTypeRadio(
                                      0, 'TEXT', Icons.abc_rounded)),
                              const SizedBox(height: 10),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(0),
                              //   ),
                              //   child: fieldTypeRadio(
                              //       1, 'NUMBER', Icons.onetwothree_rounded),
                              // ),
                              // const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: fieldTypeRadio(
                                    2, 'DATE', Icons.calendar_today_rounded),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  children: [
                                    fieldTypeRadio(
                                        3, 'OPTIONS', Icons.list_outlined),
                                    if (_selectedValue == 3) ...[
                                      const SizedBox(height: 10),
                                      // Display "View" containers only for added options
                                      ..._options.map((option) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 2,
                                              bottom: 2,
                                              right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(option),
                                                        const Spacer(),
                                                        CustomButton(
                                                          textButtonText:
                                                              'View',
                                                          textButtonCallback:
                                                              () {
                                                            // Logic to handle viewing details of the option
                                                          },
                                                          textButtonStyle:
                                                              TextButton
                                                                  .styleFrom(
                                                            foregroundColor:
                                                                Colors.blue,
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      // Add Option button
                                      GestureDetector(
                                        onTap: _addOptionDialog,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: CustomText(
                                            text: 'Add Option',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(0),
                              //   ),
                              //   child: Column(
                              //     children: [
                              //       fieldTypeRadio(4, 'MULTI-OPTIONS',
                              //           Icons.list_alt_rounded),
                              //       if (_selectedValue == 4) ...[
                              //         const SizedBox(height: 10),
                              //         ..._options.map((option) => Padding(
                              //               padding: const EdgeInsets.only(
                              //                   left: 20,
                              //                   top: 2,
                              //                   bottom: 2,
                              //                   right: 10),
                              //               child: Row(
                              //                 children: [
                              //                   Expanded(
                              //                     child: Container(
                              //                       height: 40,
                              //                       padding: const EdgeInsets
                              //                           .symmetric(
                              //                           horizontal: 10,
                              //                           vertical: 5),
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(
                              //                             color: Colors.grey),
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 0),
                              //                       ),
                              //                       child: Align(
                              //                         alignment:
                              //                             Alignment.centerLeft,
                              //                         child: Row(
                              //                           children: [
                              //                             Text(option),
                              //                             const Spacer(),
                              //                             CustomButton(
                              //                               textButtonText:
                              //                                   'View',
                              //                               textButtonCallback:
                              //                                   () {
                              //                                 // Handle view action here
                              //                               },
                              //                               textButtonStyle:
                              //                                   TextButton
                              //                                       .styleFrom(
                              //                                 foregroundColor:
                              //                                     Colors.blue,
                              //                                 textStyle: const TextStyle(
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .bold),
                              //                               ),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             )),
                              //         GestureDetector(
                              //           onTap: _addOptionDialog,
                              //           child: Padding(
                              //             padding: const EdgeInsets.symmetric(
                              //                 vertical: 10),
                              //             child: CustomText(
                              //               text: 'Add Option',
                              //               style: const TextStyle(
                              //                   color: Colors.blue,
                              //                   fontSize: 14,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: const Text('Auto filled for next interaction'),
                          subtitle: const Text(
                              'Auto fill happens when a customer is searched by mobile/name or when the interaction is created from the customer details page'),
                          // value: _autoFill,
                          // onChanged: (bool? value) {
                          //   setState(() {
                          //     _autoFill = value!;
                          //   });
                          // },
                          value: _selectedOption == 'autoFill',
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedOption = 'autoFill';
                              } else {
                                _selectedOption = '';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text('Readonly field'),
                          subtitle: const Text(
                              'This field cannot be edited while adding new interactions for a lead'),
                          // value: _readonlyField,
                          // onChanged: (bool? value) {
                          //   setState(() {
                          //     _readonlyField = value!;
                          //   });
                          // },
                          value: _selectedOption == 'readonly',
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedOption = 'readonly';
                              } else {
                                _selectedOption = '';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text('Mandatory field'),
                          subtitle: const Text(
                              'Interaction cannot be submitted, without filling this field.'),
                          // value: _mandatoryField,
                          // onChanged: (bool? value) {
                          //   setState(() {
                          //     _mandatoryField = value!;
                          //   });
                          // },
                          value: _selectedOption == 'mandatory',
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedOption = 'mandatory';
                              } else {
                                _selectedOption = '';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue))),
                            const SizedBox(width: 10),
                            CustomButton(
                              elevatedButtonText: 'Save',
                              elevatedButtonCallback: _saveField,
                              elevatedButtonStyle: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget fieldTypeRadio(int value, String label, IconData icon) {
    return RadioListTile<int>(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust padding as needed
      title: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16.0), // Space between icon and text
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
      value: value,
      groupValue: _selectedValue,
      onChanged: (int? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
    );
  }
}
