



// <!-- <!DOCTYPE html>
// <html>
//   <head>
//     <meta charset="UTF-8">
//     <title>Seeds AI</title>
//     <base href="/" />
//     <meta name="description" content="A new Flutter project">
//     <meta name="viewport" content="width=device-width, initial-scale=1">
//     <link rel="manifest" href="manifest.json">
//     <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
//     <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth.js"></script>
//     <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-firestore.js"></script>
 
//     <script>
//       window.env = {
//         FIREBASE_API_KEY: 'YOUR_FIREBASE_API_KEY',
//         FIREBASE_AUTH_DOMAIN: 'YOUR_FIREBASE_AUTH_DOMAIN',
//         FIREBASE_PROJECT_ID: 'YOUR_FIREBASE_PROJECT_ID',
//         FIREBASE_STORAGE_BUCKET: 'YOUR_FIREBASE_STORAGE_BUCKET',
//         FIREBASE_MESSAGING_SENDER_ID: 'YOUR_FIREBASE_MESSAGING_SENDER_ID',
//         FIREBASE_APP_ID: 'YOUR_FIREBASE_APP_ID',
//       };
//     </script>
//   </head>
//   <body>
    
//     <script src="main.dart.js" type="application/javascript"></script>
//   </body>
// </html> -->



























// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:csv/csv.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/sort_by_date.dart';

// // class ImportCustomers extends StatefulWidget {
// //   const ImportCustomers({super.key});

// //   @override
// //   State<ImportCustomers> createState() => _ImportCustomersState();
// // }

// // class _ImportCustomersState extends State<ImportCustomers> {
// //   String? fileName;
// //   int currentStep = 1;
// //   List<Map<String, String>> columnHeaders = [];

// //   Future<void> pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['csv'],
// //     );

// //     if (result != null) {
// //       PlatformFile file = result.files.single;
// //       // if (file.extension != 'csv') {
// //       //   showDialog(
// //       //     context: context,
// //       //     builder: (context) => AlertDialog(
// //       //       title: const Text('Invalid File'),
// //       //       content: const Text('Please choose a CSV file to proceed.'),
// //       //       actions: [
// //       //         TextButton(
// //       //           onPressed: () {
// //       //             Navigator.pop(context);
// //       //           },
// //       //           child: const Text('OK'),
// //       //         ),
// //       //       ],
// //       //     ),
// //       //   );
// //       //   return;
// //       // }

// //       setState(() {
// //         fileName = file.name;
// //       });

// //       // Read the CSV file and extract headers
// //       final input = File(file.path!).openRead();
// //       final fields = await input
// //           .transform(utf8.decoder)
// //           .transform(CsvToListConverter())
// //           .toList();

// //       if (fields.isNotEmpty) {
// //         setState(() {
// //           columnHeaders = fields[0]
// //               .map((e) => e.toString())
// //               .cast<Map<String, String>>()
// //               .toList();
// //         });
// //       }

// //       // Move to next step
// //       goToNextStep();
// //     }
// //   }

// //   void goToNextStep() {
// //     if (fileName != null && columnHeaders.isNotEmpty) {
// //       setState(() {
// //         currentStep = 2; // Move to step 2
// //       });
// //     } else {
// //       // Handle case where no file is selected or no headers are found
// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: const Text('Error'),
// //           content: const Text('Please choose a valid CSV file to proceed.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: const Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (currentStep == 1) ...[
// //             CustomText(
// //               text: "Step 1: Upload Leads",
// //               style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black),
// //             ),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text: "Leads can be imported using CSV files",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text:
// //                     "Please note that the name and number fields are required",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text:
// //                     "If you want to assign multiple telecallers, please separate their numbers by semicolon",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 30),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Container(
// //                     height: 48,
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey),
// //                       borderRadius: BorderRadius.circular(5),
// //                     ),
// //                     child: Align(
// //                       alignment: Alignment.centerLeft,
// //                       child: Row(
// //                         children: [
// //                           Text(
// //                             fileName ?? 'No file chosen',
// //                             style: TextStyle(
// //                               color:
// //                                   fileName != null ? Colors.black : Colors.grey,
// //                             ),
// //                           ),
// //                           const Spacer(),
// //                           CustomButton(
// //                             elevatedButtonText: 'Choose file',
// //                             elevatedButtonCallback: pickFile,
// //                             elevatedButtonStyle: ElevatedButton.styleFrom(
// //                               elevation: 0,
// //                               backgroundColor: Colors.black,
// //                               foregroundColor: Colors.white,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 30),
// //             CustomButton(
// //               elevatedButtonText: 'Next',
// //               elevatedButtonCallback: goToNextStep,
// //               elevatedButtonStyle: ElevatedButton.styleFrom(
// //                 elevation: 0,
// //                 backgroundColor: Colors.black,
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //             ),
// //           ] else if (currentStep == 2) ...[
// //             CustomersMap(columnHeaders: columnHeaders),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class CustomersMap extends StatefulWidget {
// //   final List<Map<String, String>> columnHeaders;

// //   const CustomersMap({super.key, required this.columnHeaders});

// //   @override
// //   State<CustomersMap> createState() => _CustomersMapState();
// // }

// // class _CustomersMapState extends State<CustomersMap> {
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController agentController = TextEditingController();
// //   final TextEditingController tagsController = TextEditingController();
// //   final TextEditingController statusController = TextEditingController();
// //   final TextEditingController notesController = TextEditingController();

// //   int currentStep = 2;
// //   Map<String, String> selectedColumns = {
// //     'Name': 'None',
// //     'Phone': 'None',
// //     'Agent name': 'None',
// //     'Tags': 'None',
// //     'Status': 'None',
// //     'Notes': 'None',
// //   };

// //   final List<Map<String, String>> items = [
// //     {'Name': 'None'},
// //     {'Phone': 'None'},
// //     {'Agent name': 'None'},
// //     {'Tags': 'None'},
// //     {'Status': 'None'},
// //     {'Notes': 'None'},
// //   ];

// //   void goToNextStep() {
// //     setState(() {
// //       currentStep = 3;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (currentStep == 2) ...[
// //             CustomText(
// //               text: "Step 2: Map Fields",
// //               style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black),
// //             ),
// //             const SizedBox(height: 20),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Name",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Name'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 20),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Phone",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Phone'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Agent name",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Agent name'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 20),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Tags",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Tags'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Status",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Status'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 20),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CustomText(
// //                             text: "Notes",
// //                           ),
// //                           CustomText(
// //                             text: "*",
// //                             style: const TextStyle(color: Colors.red),
// //                           ),
// //                         ],
// //                       ),
// //                       CustomDropdown(
// //                         items: widget.columnHeaders,
// //                         hintText: 'None',
// //                         onSelected: (value) {
// //                           setState(() {
// //                             selectedColumns['Notes'] = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 30),
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: [
// //                 CustomButton(
// //                   elevatedButtonText: 'Reset',
// //                   elevatedButtonCallback: () {
// //                     setState(() {
// //                       selectedColumns = {
// //                         'Name': 'None',
// //                         'Phone': 'None',
// //                         'Agent name': 'None',
// //                         'Tags': 'None',
// //                         'Status': 'None',
// //                         'Notes': 'None',
// //                       };
// //                     });
// //                   },
// //                   elevatedButtonStyle: ElevatedButton.styleFrom(
// //                     elevation: 0,
// //                     backgroundColor: Colors.white,
// //                     foregroundColor: Colors.black,
// //                     shape: RoundedRectangleBorder(
// //                       side: const BorderSide(color: Colors.grey, width: .5),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 CustomButton(
// //                   elevatedButtonText: 'Next',
// //                   elevatedButtonCallback: () {
// //                     goToNextStep();
// //                   },
// //                   elevatedButtonStyle: ElevatedButton.styleFrom(
// //                     elevation: 0,
// //                     backgroundColor: Colors.black,
// //                     foregroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ] else if (currentStep == 3) ...[
// //             CustomersInfo(selectedColumns: selectedColumns),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'package:flutter/material.dart';

// // // class CustomDropdown extends StatelessWidget {
// // //   final List<String> items;
// // //   final String hintText;
// // //   final ValueChanged<String> onSelected;

// // //   const CustomDropdown({
// // //     required this.items,
// // //     required this.hintText,
// // //     required this.onSelected,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DropdownButton<String>(
// // //       hint: Text(hintText),
// // //       items: items.map((String item) {
// // //         return DropdownMenuItem<String>(
// // //           value: item,
// // //           child: Text(item),
// // //         );
// // //       }).toList(),
// // //       onChanged: (value) {
// // //         if (value != null) {
// // //           onSelected(value);
// // //         }
// // //       },
// // //     );
// // //   }
// // // }

// // class CustomersInfo extends StatelessWidget {
// //   final Map<String, String> selectedColumns;

// //   const CustomersInfo({required this.selectedColumns});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Use the selectedColumns map to display the information
// //     return Container(
// //       child: Text(selectedColumns.toString()),
// //     );
// //   }
// // }

// // class CustomerRow extends StatelessWidget {
// //   final Customer customer;

// //   const CustomerRow({super.key, required this.customer});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Expanded(
// //             flex: 1,
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 CircleAvatar(
// //                   child: Text(customer.name[0]),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(customer.name.isEmpty ? '--' : customer.name,
// //                         style: const TextStyle(fontWeight: FontWeight.bold)),
// //                     // const Text("Admin"),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.phone.isEmpty ? '--' : customer.phone),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.email.isEmpty ? '--' : customer.email),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.address.isEmpty ? '--' : customer.address),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.company.isEmpty ? '--' : customer.company),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.category.isEmpty ? '--' : customer.category),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(customer.createdOn.isEmpty ? '--' : customer.createdOn),
// //               ],
// //             ),
// //           ),
// //           // Expanded(
// //           //   flex: 1,
// //           //   child: Row(
// //           //     mainAxisAlignment: MainAxisAlignment.end,
// //           //     children: [
// //           //       IconButton(
// //           //         icon: const Icon(Icons.edit),
// //           //         onPressed: () {
// //           //           // Navigator.push(
// //           //           //   context,
// //           //           //   MaterialPageRoute(builder: (context) => const EmployeeDetailScreen()),
// //           //           // );
// //           //         },
// //           //       ),
// //           //       IconButton(
// //           //         icon: const Icon(Icons.more_vert),
// //           //         onPressed: () {
// //           //           // Handle more actions
// //           //         },
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// ///////////////////////////////
// ///

// // class _CustomersLedsState extends State<CustomersLeds> {
// //   final String collectionPath = '/organizations/ABC-1234-999/customers';

// //   @override
// //   void initState() {
// //     super.initState();
// //     Provider.of<DefaultProvider>(context, listen: false)
// //         .fetchCustomers(collectionPath);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         backgroundColor: Colors.white,
// //         body: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
// //           child: Consumer<DefaultProvider>(builder: (context, provider, child) {
// //             if (provider.isLoading) {
// //               return const Center(child: CircularProgressIndicator());
// //             } else if (provider.customers.isEmpty) {
// //               return const Center(child: Text('No customers found.'));
// //             } else if (provider.selectedCustomer != null) {
// //               // Show customer detail view
// //               return CustomerDetail(customer: provider.selectedCustomer!);
// //             } else {
// //               return SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         // Consumer<DefaultProvider>(
// //                         //   builder: (context, customerProvider, child) {
// //                         //     return CustomText(
// //                         //       text: customerProvider.customers.length.toString(),
// //                         //       style: const TextStyle(
// //                         //         fontSize: 18,
// //                         //         fontWeight: FontWeight.bold,
// //                         //         color: Colors.black,
// //                         //       ),
// //                         //     );
// //                         //   },
// //                         // ),
// //                         CustomText(
// //                           text: provider.customers.length.toString(),
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black,
// //                           ),
// //                         ),

// //                         const SizedBox(width: 10),
// //                         CustomText(
// //                           text: "Customers",
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                         const Spacer(),
// //                         SearchPage(
// //                           hintText: 'Search by Name/Phone/Company',
// //                           dataList: const [
// //                             'Flutter',
// //                             'React',
// //                             'Ionic',
// //                             'Xamarin'
// //                           ],
// //                           onChanged: (query) {
// //                             // Handle search query change
// //                             print('Search query: $query');
// //                           },
// //                         ),
// //                         const SizedBox(width: 10),
// //                         const FilterSort(
// //                           items: [
// //                             'Hot Followup',
// //                             'Sales Closed',
// //                             'Cold Followup',
// //                             'Appointment Fixed',
// //                             'Not contacted',
// //                             'Not interested',
// //                           ],
// //                           hintText: 'Filters: Select Status',
// //                         ),
// //                         const SizedBox(width: 10),
// //                         CustomDropdown(
// //                           items: const [
                            // {
                            //   'value': 'Name: A-Z',
                            //   'icon': Icons.people_outline_rounded
                            // },
                            // {
                            //   'value': 'Date: New to Old',
                            //   'icon': Icons.calendar_today
                            // },
                            // {
                            //   'value': 'Date: Old to New',
                            //   'icon': Icons.calendar_today
                            // },
                            // {
                            //   'value': 'Priority: Low to High',
                            //   'icon': Icons.horizontal_split_rounded
                            // },
                            // {
                            //   'value': 'Priority: High to Low',
                            //   'icon': Icons.horizontal_split_rounded
                            // },
// //                           ],
// //                           hintText: 'Date: New to Old',
// //                           hintIcon: Icons.calendar_today,
// //                           onSelected: (String) {},
// //                         ),
// //                         const SizedBox(width: 10),
// //                         CustomButton(
// //                           elevatedButtonText: 'Import',
// //                           elevatedButtonCallback: () {
// //                             // Implement your apply filter logic here
// //                             showDialog(
// //                                 // barrierColor: Color(0xffF2F4F7),
// //                                 context: context,
// //                                 builder: (BuildContext context) {
// //                                   return const AlertDialog(
// //                                     backgroundColor: Colors.white,
// //                                     title: Text('Import Customers'),
// //                                     content: SingleChildScrollView(
// //                                       child: ImportCustomers(),
// //                                     ),
// //                                     // actions: [
// //                                     //   TextButton(
// //                                     //     onPressed: () {
// //                                     //       Navigator.of(context).pop();
// //                                     //     },
// //                                     //     child: const Text('CANCEL'),
// //                                     //   ),
// //                                     //   TextButton(
// //                                     //     onPressed: () {
// //                                     //       // Implement your accept logic here
// //                                     //       Navigator.of(context).pop();
// //                                     //     },
// //                                     //     child: const Text('SAVE'),
// //                                     //   ),
// //                                     // ],
// //                                   );
// //                                 });
// //                           },
// //                           elevatedButtonStyle: ElevatedButton.styleFrom(
// //                             elevation: 0,
// //                             iconColor: Colors.white,
// //                             backgroundColor: Colors.black,
// //                             foregroundColor: Colors.white,
// //                             shape: RoundedRectangleBorder(
// //                               // side: const BorderSide(color: Colors.grey, width: 1),
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                           icon: Icons.file_upload,
// //                         ),
// //                         const SizedBox(width: 10),
// //                         CustomButton(
// //                           elevatedButtonText: 'Create',
// //                           elevatedButtonCallback: () {
// //                             // Implement your apply filter logic here
// //                             showDialog(
// //                                 // barrierColor: Color(0xffF2F4F7),
// //                                 context: context,
// //                                 builder: (BuildContext context) {
// //                                   return const AlertDialog(
// //                                     backgroundColor: Colors.white,
// //                                     title: Text('Create Lead'),
// //                                     content: SingleChildScrollView(
// //                                       child: CreateLeads(),
// //                                     ),
// //                                     // actions: [
// //                                     //   TextButton(
// //                                     //     onPressed: () {
// //                                     //       Navigator.of(context).pop();
// //                                     //     },
// //                                     //     child: const Text('CANCEL'),
// //                                     //   ),
// //                                     //   TextButton(
// //                                     //     onPressed: () {
// //                                     //       // Implement your accept logic here
// //                                     //       Navigator.of(context).pop();
// //                                     //     },
// //                                     //     child: const Text('SAVE'),
// //                                     //   ),
// //                                     // ],
// //                                   );
// //                                 });
// //                           },
// //                           elevatedButtonStyle: ElevatedButton.styleFrom(
// //                             elevation: 0,
// //                             iconColor: Colors.white,
// //                             backgroundColor: Colors.black,
// //                             foregroundColor: Colors.white,
// //                             shape: RoundedRectangleBorder(
// //                               // side: const BorderSide(color: Colors.grey, width: 1),
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                           icon: Icons.add,
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 20),
// //                     const HeaderRow(
// //                       titles: [
// //                         'Name',
// //                         'Phone Number',
// //                         'Email',
// //                         'Address',
// //                         'Company',
// //                         'Category',
// //                         // 'Assigned Agent',
// //                         // 'Note',
// //                         // 'Status',
// //                         'Created on',
// //                       ],
// //                     ),
// //                     const SizedBox(height: 20),
// //                     // Consumer<DefaultProvider>(builder: (context, provider, child) {
// //                     //   if (provider.selectedCustomer != null) {
// //                     //     return CustomerDetail(customer: provider.selectedCustomer!);
// //                     //   } else {
// //                     //     return
// //                     // FutureBuilder(
// //                     //   future:
// //                     //       Provider.of<DefaultProvider>(context, listen: false)
// //                     //           .fetchCustomers(collectionPath),
// //                     //   builder: (context, snapshot) {
// //                     //     if (snapshot.connectionState ==
// //                     //         ConnectionState.waiting) {
// //                     //       return const Center(
// //                     //           child: CircularProgressIndicator());
// //                     //     } else if (snapshot.hasError) {
// //                     //       return const Center(
// //                     //           child: Text('Error fetching customers data'));
// //                     //     } else {
// //                     //       return Consumer<DefaultProvider>(
// //                     //         builder: (context, customerProvider, child) {
// //                     //           final customers = customerProvider.customers;

// //                     //           return

// //                     ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: const NeverScrollableScrollPhysics(),
// //                       itemCount: provider.customers.length,
// //                       // customers.length,
// //                       itemBuilder: (context, index) {
// //                         return Column(
// //                           children: [
// //                             // CustomerRow(customer: customers[index]),
// //                             // if (index < customers.length - 1)
// //                             CustomerRow(customer: provider.customers[index]),
// //                             if (index < provider.customers.length - 1)
// //                               Divider(
// //                                   height: 1.0,
// //                                   color: Colors.grey.withOpacity(0.2)),
// //                           ],
// //                         );
// //                       },
// //                     ),
// //                     //         },
// //                     //       );
// //                     //     }
// //                     //   },
// //                     // )
// //                     // ]

// //                     // }

// //                     // ),

// //                     // if (provider.selectedCustomer != null)
// //                     //   Details(), // Display the Details widget if selectedCustomer is not null
// //                   ],
// //                 ),
// //               );
// //             }
// //           }),
// //         ));
// //   }
// // }
// ////////////////////////////////////////////////////
// ///
// ///
// ///
// ///

// // class CustomerRow extends StatelessWidget {
// //   final Customer customer;

// //   const CustomerRow({super.key, required this.customer});

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: () {
// //         Provider.of<DefaultProvider>(context, listen: false)
// //             .selectCustomer(customer);
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 8.0),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Expanded(
// //               flex: 1,
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   CircleAvatar(
// //                     child:
// //                         Text(customer.name.isNotEmpty ? customer.name[0] : 'U'),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(customer.name.isEmpty ? 'Unknown' : customer.name,
// //                           style: const TextStyle(fontWeight: FontWeight.bold)),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.phone.isEmpty
// //                       ? '--'
// //                       : customer.phone), // ? 'Unknown' : employees.name
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.email.isEmpty ? '--' : customer.email),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.address.isEmpty ? '--' : customer.address),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.company.isEmpty ? '--' : customer.company),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.category.isEmpty ? '--' : customer.category),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               flex: 1,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(customer.createdOn.isEmpty ? '--' : customer.createdOn),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// /////////////////////////////////////////////////
// ///
// ///

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'followup.dart';

// // class FollowupsProvider with ChangeNotifier {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   List<Followup> _followups = [];
// //   Followup? _selectedFollowup;
// //   bool _isLoading = false;

// //   List<Followup> get followups => _followups;
// //   Followup? get selectedFollowup => _selectedFollowup;
// //   bool get isLoading => _isLoading;

// //   Future<void> fetchFollowups(String collectionPath) async {
// //     _setLoading(true);

// //     try {
// //       QuerySnapshot querySnapshot = await _firestore
// //           .collection(collectionPath)
// //           .where('status.type', isEqualTo: 'Follow-Up')
// //           .orderBy('createdOn', descending: true)  // Optimize ordering for better performance
// //           .limit(50)  // Limit results to reduce data load
// //           .get();

// //       _followups = querySnapshot.docs
// //           .map((doc) => Followup.fromFirestore(doc.data() as Map<String, dynamic>))
// //           .toList();
// //     } catch (error) {
// //       _handleError(error);
// //     } finally {
// //       _setLoading(false);
// //     }
// //   }

// //   void selectFollowup(Followup followup) {
// //     _selectedFollowup = followup;
// //     notifyListeners();
// //   }

// //   void clearFollowup() {
// //     _selectedFollowup = null;
// //     notifyListeners();
// //   }

// //   void _setLoading(bool value) {
// //     _isLoading = value;
// //     notifyListeners();
// //   }

// //   void _handleError(dynamic error) {
// //     print("Error fetching followups: $error");
// //     // Optionally, handle the error (e.g., show a snackbar or dialog)
// //   }
// // }

// /////////////////////////////////

// // class ImportCustomers extends StatefulWidget {
// //   const ImportCustomers({Key? key}) : super(key: key);

// //   @override
// //   State<ImportCustomers> createState() => _ImportCustomersState();
// // }

// // class _ImportCustomersState extends State<ImportCustomers> {
// //   String? fileName;
// //   int currentStep = 1;

// //   Future<void> pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['csv'],
// //     );

// //     if (result != null) {
// //       setState(() {
// //         fileName = result.files.single.name;
// //       });
// //     }
// //   }

// //   void goToNextStep() {
// //     // Add your logic for file upload or processing here
// //     // For demonstration, let's just move to the next step after file selection
// //     if (fileName != null) {
// //       setState(() {
// //         currentStep = 2; // Move to step 2
// //       });
// //     } else {
// //       // Handle case where no file is selected
// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: Text('Error'),
// //           content: Text('Please choose a CSV file to proceed.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (currentStep == 1) ...[
// //             CustomText(
// //               text: "Step 1: Upload Leads",
// //               style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black),
// //             ),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text: "Leads can be imported using CSV files",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text:
// //                     "Please note that the name and number fields are required",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 10),
// //             CustomText(
// //                 text:
// //                     "If you want to assign multiple telecallers, please separate their numbers by semicolon",
// //                 style: const TextStyle(color: Colors.black)),
// //             const SizedBox(height: 30),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Container(
// //                     height: 48,
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey),
// //                       borderRadius: BorderRadius.circular(5),
// //                     ),
// //                     child: Align(
// //                       alignment: Alignment.centerLeft,
// //                       child: Row(
// //                         children: [
// //                           Text(
// //                             fileName ?? 'No file chosen',
// //                             style: TextStyle(
// //                               color:
// //                                   fileName != null ? Colors.black : Colors.grey,
// //                             ),
// //                           ),
// //                           const Spacer(),
// //                           CustomButton(
// //                             elevatedButtonText: 'Choose file',
// //                             elevatedButtonCallback: pickFile,
// //                             elevatedButtonStyle: ElevatedButton.styleFrom(
// //                               elevation: 0,
// //                               backgroundColor: Colors.black,
// //                               foregroundColor: Colors.white,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 30),
// //             CustomButton(
// //               elevatedButtonText: 'Next',
// //               elevatedButtonCallback: goToNextStep,
// //               elevatedButtonStyle: ElevatedButton.styleFrom(
// //                 elevation: 0,
// //                 backgroundColor: Colors.black,
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //             ),
// //           ] else if (currentStep == 2) ...[
// //             const CustomersMap(),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }
// //////////////////////////////////////////
// ///

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:your_project/csv_provider.dart'; // Update with your actual path

// // class CustomersMap extends StatefulWidget {
// //   const CustomersMap({super.key});

// //   @override
// //   State<CustomersMap> createState() => _CustomersMapState();
// // }

// // class _CustomersMapState extends State<CustomersMap> {
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController agentController = TextEditingController();
// //   final TextEditingController tagsController = TextEditingController();
// //   final TextEditingController statusController = TextEditingController();
// //   final TextEditingController notesController = TextEditingController();

// //   final FirestoreService _firestoreService = FirestoreService();

// //   int currentStep = 2;

// //   // void goToNextStep() {
// //   //   setState(() {
// //   //     currentStep = 3;
// //   //   });
// //   // }

// // void goToNextStep() {
// //   if (_formKey.currentState?.validate() ?? false) {
// //     setState(() {
// //       currentStep = 3;
// //     });
// //   }
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: Form(
// //         key: _formKey,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (currentStep == 2) ...[
// //               CustomText(
// //                 text: "Step 2: Map Fields",
// //                 style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black),
// //               ),
// //               const SizedBox(height: 20),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Name",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},

// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Phone",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Agent name",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Tags",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Status",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           children: [
// //                             CustomText(
// //                               text: "Notes",
// //                             ),
// //                             CustomText(
// //                               text: "*",
// //                               style: const TextStyle(color: Colors.red),
// //                             ),
// //                           ],
// //                         ),
// //                         CustomDropdown(
// //                           items: const [
// //                             {'value': 'None'},
// //                           ],
// //                           // firestorePath: '/organizations/ABC-1234-999/agents',
// //                           hintText: 'None',
// //                           onSelected: (String) {},
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please map with the fields';
// //                             }
// //                             return null; // Return null if validation passes
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 30),
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   CustomButton(
// //                     elevatedButtonText: 'Reset',
// //                     elevatedButtonCallback: () {
// //                       // Implement your apply filter logic here
// //                     },
// //                     elevatedButtonStyle: ElevatedButton.styleFrom(
// //                       elevation: 0,
// //                       backgroundColor: Colors.white,
// //                       foregroundColor: Colors.black,
// //                       shape: RoundedRectangleBorder(
// //                         side: const BorderSide(color: Colors.grey, width: .5),
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   CustomButton(
// //                     elevatedButtonText: 'Next',
// //                     elevatedButtonCallback: goToNextStep,
// //                     //  () {
// //                     //   // Implement your apply filter logic here
// //                     // },
// //                     elevatedButtonStyle: ElevatedButton.styleFrom(
// //                       elevation: 0,
// //                       backgroundColor: Colors.black,
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// // ] else if (currentStep == 3) ...[
// //   const CustomersInfo(),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class CustomersMap extends StatefulWidget {
// //   final List<String> headers;
// //   final List<Map<String, dynamic>> fileData;

// //   const CustomersMap(
// //       {super.key, required this.headers, required this.fileData});

// //   @override
// //   State<CustomersMap> createState() => _CustomersMapState();
// // }

// // class _CustomersMapState extends State<CustomersMap> {
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //   final Map<String, String> fieldMappings = {};

// //   final TextEditingController fieldController = TextEditingController();

// //   int currentStep = 2; // Start at step 2 by default

// //   void goToNextStep() {
// //     if (_formKey.currentState?.validate() ?? false) {
// //       setState(() {
// //         currentStep = 3; // Move to step 3
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //       child: Form(
// //         key: _formKey,
// //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           if (currentStep == 2) ...[
// //             CustomText(
// //               text: "Step 2: Map Fields",
// //               style: const TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black,
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             // Generate field mapping UI dynamically based on headers

// //             Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: buildFieldMapping("Name"),
// //                     ),
// //                     const SizedBox(width: 20),
// //                     Expanded(
// //                       child: buildFieldMapping("Phone"),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: buildFieldMapping("Email"),
// //                     ),
// //                     const SizedBox(width: 20),
// //                     Expanded(
// //                       child: buildFieldMapping("Address"),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: buildFieldMapping("Category"),
// //                     ),
// //                     const SizedBox(width: 20),
// //                     Expanded(
// //                       child: buildFieldMapping("Company"),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: buildFieldMapping("Status"),
// //                     ),
// //                     const SizedBox(width: 20),
// //                     // Expanded(
// //                     //   child: buildFieldMapping("Company"),
// //                     // ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             // Column(
// //             //   children: widget.headers.map((header) {
// //             //     return Column(
// //             //       crossAxisAlignment: CrossAxisAlignment.start,
// //             //       children: [
// //             //         Row(
// //             //           children +
// //             //: [
// //             //             CustomText(text: header),
// //             //             CustomText(
// //             //               text: "*",
// //             //               style: const TextStyle(color: Colors.red),
// //             //             ),
// //             //           ],
// //             //         ),
// //             //         CustomDropdown(
// //             //           items: widget.headers
// //             //               .map((header) => {'value': header})
// //             //               .toList(),
// //             //           hintText: 'None',
// //             //           onSelected: (String? selectedValue) {
// //             //             fieldMappings[header] = selectedValue!;
// //             //           },
// //             //           validator: (value) {
// //             //             if (value == null || value.isEmpty) {
// //             //               return 'Please map with the fields';
// //             //             }
// //             //             return null; // Return null if validation passes
// //             //           },
// //             //         ),
// //             //         const SizedBox(height: 10),
// //             //       ],
// //             //     );
// //             //   }).toList(),
// //             // ),
// //             const SizedBox(height: 30),
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: [
// //                 CustomButton(
// //                   elevatedButtonText: 'Reset',
// //                   elevatedButtonCallback: () {
// //                     // Implement your reset logic here
// //                   },
// //                   elevatedButtonStyle: ElevatedButton.styleFrom(
// //                     elevation: 0,
// //                     backgroundColor: Colors.white,
// //                     foregroundColor: Colors.black,
// //                     shape: RoundedRectangleBorder(
// //                       side: const BorderSide(color: Colors.grey, width: .5),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 CustomButton(
// //                   elevatedButtonText: 'Next',
// //                   elevatedButtonCallback: goToNextStep,
// //                   elevatedButtonStyle: ElevatedButton.styleFrom(
// //                     elevation: 0,
// //                     backgroundColor: Colors.black,
// //                     foregroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ] else if (currentStep == 3) ...[
// //             // CustomersInfo(
// //             //   fieldMappings:
// //             //       Provider.of<DefaultProvider>(context).fieldMappings,
// //             //   fileData: widget.fileData,
// //             // ),
// //             CustomersInfo(
// //                 fieldMappings: fieldMappings, fileData: widget.fileData),
// //             // CustomersInfo(fieldMappings: fieldMappings),
// //           ]
// //         ]),
// //       ),
// //     );
// //   }

// //   Widget buildFieldMapping(String field) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             CustomText(text: field),
// //             CustomText(
// //               text: "*",
// //               style: const TextStyle(color: Colors.red),
// //             ),
// //           ],
// //         ),
// //         CustomDropdown(
// //           controller: fieldController,
// //           items: widget.headers.map((header) => {'value': header}).toList(),
// //           hintText: 'None',
// //           onSelected: (String? selectedValue) {
// //             fieldController.text = selectedValue!;
// //             fieldMappings[field] = selectedValue;
// //             print('Dropdown selected: $selectedValue');
// //           },
// //           validator: (value) {
// //             if (value == null || value.isEmpty || value == 'None') {
// //               return 'Please map with the fields';
// //             }
// //             return null; // Return null if validation passes
// //           },
// //         ),
// //       ],
// //     );
// //   }
// /////////////////////////////////////////////

// // Widget buildFieldMapping(String field) {
// //   return Consumer<DefaultProvider>(
// //     builder: (context, provider, child) {
// //       return Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               CustomText(text: field),
// //               CustomText(
// //                 text: "*",
// //                 style: const TextStyle(color: Colors.red),
// //               ),
// //             ],
// //           ),
// //           CustomDropdown(
// //             items: widget.headers.map((header) => {'value': header}).toList(),
// //             hintText: 'None',
// //             onSelected: (String? selectedValue) {
// //               provider.updateFieldMapping(field, selectedValue);
// //               print('Dropdown selected: $selectedValue');
// //             },
// //             validator: (value) {
// //               if (value == null || value.isEmpty) {
// //                 return 'Please map with the fields';
// //               }
// //               return null;
// //             },
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
// // }

// // class CustomFieldMapping extends StatelessWidget {
// //   final String fieldName;
// //   final FormFieldValidator<String>? validator;
// //   final Function(String?) onSelected;

// //   const CustomFieldMapping({
// //     required this.fieldName,
// //     this.validator,
// //     required this.onSelected,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             CustomText(text: fieldName),
// //             CustomText(
// //               text: "*",
// //               style: const TextStyle(color: Colors.red),
// //             ),
// //           ],
// //         ),
// //         CustomDropdown(
// //           items: const [
// //             {'value': 'None'},
// //             // Add your dynamic options here based on Firestore or other data
// //           ],
// //           hintText: 'None',
// //           onSelected: onSelected,
// //           // validator: validator,
// //         ),
// //         const SizedBox(height: 10),
// //       ],
// //     );
// //   }
// // }
// // import 'package:flutter/material.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/sort_by_date.dart';
// // import 'customers_info.dart'; // Assuming you've separated the CustomersInfo widget

// // class CustomersInfo extends StatefulWidget {
// //   const CustomersInfo({super.key});

// //   @override
// //   State<CustomersInfo> createState() => _CustomersInfoState();
// // }

// // class _CustomersInfoState extends State<CustomersInfo> {
// //   final TextEditingController tagController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(0), // Add padding here
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           CustomText(
// //             text: "Step 3: Import Information",
// //             style: const TextStyle(
// //                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
// //           ),
// //           const SizedBox(height: 20),

// //           Container(
// //             padding: const EdgeInsets.all(8), // Add padding here
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade300, // Use a lighter shade
// //               borderRadius: BorderRadius.circular(4),
// //             ),
// //             child: Row(
// //               children: [
// //                 CustomText(
// //                   text: "0",
// //                   style: const TextStyle(color: Colors.black),
// //                 ),
// //                 const SizedBox(width: 5),
// //                 CustomText(
// //                   text: "Leads",
// //                   style: const TextStyle(
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 20), // Increase spacing here
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     CustomText(
// //                       text: "Tags",
// //                     ),
// //                     const SizedBox(height: 5), // Add spacing here
// //                     CustomFormField(
// //                       controller: tagController,
// //                       hintText: 'Type and press enter.....',
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(width: 20), // Add spacing between columns
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     CustomText(
// //                       text: "Tags",
// //                     ),
// //                     const SizedBox(height: 5), // Add spacing here
// //                     CustomFormField(
// //                       controller: tagController,
// //                       hintText: 'Type and press enter.....',
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 30),
// //           CustomButton(
// //             elevatedButtonText: 'Import',
// //             elevatedButtonCallback: () {
// //               // Implement your apply filter logic here
// //               Navigator.of(context).pop();
// //             },
// //             elevatedButtonStyle: ElevatedButton.styleFrom(
// //               elevation: 0,
// //               backgroundColor: Colors.black,
// //               foregroundColor: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// /////////////////////// COMPLEX ADD FIELDS

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
// // import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

// // class AddFields extends StatefulWidget {
// //   final Function(String) onFieldAdded;
// //   final Function(String)? onOptionAdded; // New callback for handling options
// //   const AddFields({
// //     super.key,
// //     required this.onFieldAdded,
// //     this.onOptionAdded,
// //   });

// //   @override
// //   State<AddFields> createState() => _AddFieldsState();
// // }

// // class _AddFieldsState extends State<AddFields> {
// //   final TextEditingController _fieldNameController = TextEditingController();
// //   final TextEditingController _optionController = TextEditingController();
// //   int? _selectedValue;
// //   bool _autoFill = false;
// //   bool _filterableField = false;
// //   bool _mandatoryField = false;
// //   bool _readonlyField = false;
// //   final List<String> _options = [];
// //   final List<String> _fields = [];

// //   // Method to handle adding options
// //   void _addOption2() {
// //     String optionName = _optionController.text.trim();
// //     if (optionName.isNotEmpty) {
// //       setState(() {
// //         _options.add(optionName);
// //         _optionController.clear();
// //       });
// //       if (widget.onOptionAdded != null) {
// //         widget.onOptionAdded!(optionName);
// //       }
// //     }
// //   }

// //   void _saveField() {
// //     String fieldName = _fieldNameController.text.trim();
// //     String fieldType = _getSelectedFieldType();
// //     String field = _getCheckboxTitle();

// //     if (fieldName.isNotEmpty && fieldType.isNotEmpty) {
// //       CRMField crmField = CRMField(
// //         name: fieldName,
// //         type: fieldType,
// //         field: field,
// //         // autoFill: _autoFill,
// //         // filterable: _filterableField,
// //       );

// //       Provider.of<DefaultProvider>(context, listen: false)
// //           .addCRMField("ABC-1234-999", crmField);

// //       // Clear text field and reset state
// //       // _fieldNameController.clear();
// //       // _optionController.clear();
// //       setState(() {
// //         _fields.add(fieldName);
// //         _fieldNameController.clear();
// //         _selectedValue = null;
// //         _autoFill = false;
// //         _filterableField = false;
// //         _mandatoryField = false;
// //         _readonlyField = false;
// //         _options.clear();
// //       });

// //       widget.onFieldAdded(fieldName);
// //       // Navigator.of(context).pop();
// //     }
// //     // else {
// //     //   // Handle error case if necessary
// //     // }
// //   }

// //   String _getSelectedFieldType() {
// //     switch (_selectedValue) {
// //       case 0:
// //         return 'textfield';
// //       case 1:
// //         return 'number';
// //       case 2:
// //         return 'date';
// //       case 3:
// //         return 'options';
// //       case 4:
// //         return 'multi-options';
// //       default:
// //         return '';
// //     }
// //   }

// //   String _getCheckboxTitle() {
// //     if (_autoFill) return 'autofill';
// //     if (_filterableField) return 'filterable';
// //     if (_readonlyField) return 'readonly';
// //     if (_mandatoryField) return 'mandatory';
// //     return '';
// //   }

// //   void _addfield() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.white,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Container(
// //             width: MediaQuery.of(context).size.width * 0.5,

// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(4),
// //             ),
// //             // Set width to 50% of the screen width
// //             // Adjust height as needed
// //             child: Scaffold(
// //               appBar: AppBar(
// //                 backgroundColor: Colors.white,
// //                 elevation: 0,
// //                 leading: IconButton(
// //                   icon: const Icon(Icons.arrow_back, color: Colors.black),
// //                   onPressed: () {
// //                     Navigator.of(context).pop();
// //                   },
// //                 ),
// //                 actions: [
// //                   IconButton(
// //                     icon: const Icon(Icons.close, color: Colors.black),
// //                     onPressed: () {
// //                       Navigator.of(context).pop();
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               body: Padding(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: AddFields(
// //                   onFieldAdded: (fieldName) {
// //                     setState(() {
// //                       _fields.add(fieldName);
// //                       // _fields.add(_fieldNameController.text.trim());
// //                       // _fieldNameController.clear();
// //                     });
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _addOption() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Container(
// //             width: MediaQuery.of(context).size.width *
// //                 0.3, // Set width to 50% of the screen width
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('Add Option',
// //                     style:
// //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 20),
// //                 CustomFormField(
// //                   controller: _optionController,
// //                   hintText: 'Enter option',
// //                 ),
// //                 const SizedBox(height: 10),
// //                 SizedBox(
// //                   width: double
// //                       .infinity, // Make the button width match the text field
// //                   child: CustomButton(
// //                     elevatedButtonText: 'Save',
// //                     elevatedButtonCallback: () {
// //                       setState(() {
// //                         _options.add(_optionController.text.trim());
// //                         _optionController.clear();
// //                       });
// //                       Navigator.of(context).pop();
// //                     },
// //                     elevatedButtonStyle: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.orange,
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: const Color(0xffF2F4F7),
// //       child: Padding(
// //         padding: const EdgeInsets.all(0),
// //         child: Column(
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   width: 350,
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                           vertical: 20, horizontal: 16),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           const Row(
// //                             children: [
// //                               Text("Field Name"),
// //                               Text(
// //                                 "*",
// //                                 style: TextStyle(color: Colors.red),
// //                               ),
// //                             ],
// //                           ),
// //                           CustomFormField(
// //                             controller: _fieldNameController,
// //                             hintText: 'Enter Field name',
// //                           ),
// //                           const SizedBox(height: 20),
// //                           const Text("Field Type"),
// //                           const SizedBox(height: 10),
// //                           Column(
// //                             children: [
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(0),
// //                                 ),
// //                                 child: fieldTypeRadio(
// //                                     0, 'TEXT', Icons.abc_rounded),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(0),
// //                                 ),
// //                                 child: fieldTypeRadio(
// //                                     1, 'NUMBER', Icons.onetwothree_rounded),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(0),
// //                                 ),
// //                                 child: fieldTypeRadio(
// //                                     2, 'DATE', Icons.calendar_today_rounded),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(0),
// //                                 ),
// //                                 child: Column(
// //                                   children: [
// //                                     fieldTypeRadio(
// //                                         3, 'OPTIONS', Icons.list_outlined),
// //                                     if (_selectedValue == 3) ...[
// //                                       const SizedBox(height: 10),
// //                                       ..._options.map(
// //                                         (option) => Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               horizontal: 40, vertical: 5),
// //                                           child: Row(
// //                                             children: [
// //                                               Expanded(
// //                                                 child: Container(
// //                                                   height: 40,
// //                                                   padding: const EdgeInsets
// //                                                       .symmetric(
// //                                                       horizontal: 12),
// //                                                   decoration: BoxDecoration(
// //                                                     border: Border.all(
// //                                                         color: Colors.grey),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                             5),
// //                                                   ),
// //                                                   child: Align(
// //                                                     alignment:
// //                                                         Alignment.centerLeft,
// //                                                     child: Row(
// //                                                       children: [
// //                                                         Text(option),
// //                                                         const Spacer(),
// //                                                         CustomButton(
// //                                                           textButtonText:
// //                                                               'Add Field',
// //                                                           textButtonCallback:
// //                                                               _addfield,
// //                                                           textButtonStyle:
// //                                                               TextButton
// //                                                                   .styleFrom(
// //                                                             foregroundColor:
// //                                                                 Colors.blue,
// //                                                             textStyle:
// //                                                                 const TextStyle(
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .bold),
// //                                                           ),
// //                                                         ),
// //                                                         // GestureDetector(
// //                                                         //   onTap: _addOption,
// //                                                         //   child: const Icon(
// //                                                         //     Icons.add_circle,
// //                                                         //     color: Colors.blue,
// //                                                         //   ),
// //                                                         // ),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       GestureDetector(
// //                                         onTap: _addOption,
// //                                         child: Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               vertical: 10),
// //                                           child: CustomText(
// //                                             text: 'Add Option',
// //                                             style: const TextStyle(
// //                                                 color: Colors.blue,
// //                                                 fontSize: 14,
// //                                                 fontWeight: FontWeight.bold),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(height: 10),
// //                                       ..._fields.map(
// //                                         (field) => Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               horizontal: 40, vertical: 5),
// //                                           child: Row(
// //                                             children: [
// //                                               Expanded(
// //                                                 child: Container(
// //                                                   height: 40,
// //                                                   padding: const EdgeInsets
// //                                                       .symmetric(
// //                                                       horizontal: 12),
// //                                                   decoration: BoxDecoration(
// //                                                     border: Border.all(
// //                                                         color: Colors.grey),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                             5),
// //                                                   ),
// //                                                   child: Align(
// //                                                     alignment:
// //                                                         Alignment.centerLeft,
// //                                                     child: Row(
// //                                                       children: [
// //                                                         Text(field),
// //                                                         const Spacer(),
// //                                                         CustomButton(
// //                                                           textButtonText:
// //                                                               'Add Field',
// //                                                           textButtonCallback:
// //                                                               _addfield,
// //                                                           textButtonStyle:
// //                                                               TextButton
// //                                                                   .styleFrom(
// //                                                             foregroundColor:
// //                                                                 Colors.blue,
// //                                                             textStyle:
// //                                                                 const TextStyle(
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .bold),
// //                                                           ),
// //                                                         ),
// //                                                         // GestureDetector(
// //                                                         //   onTap: _addOption,
// //                                                         //   child: const Icon(
// //                                                         //     Icons.add_circle,
// //                                                         //     color: Colors.blue,
// //                                                         //   ),
// //                                                         // ),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       )
// //                                     ],
// //                                   ],
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Container(
// // decoration: BoxDecoration(
// //   color: Colors.white,
// //   borderRadius: BorderRadius.circular(0),
// // ),
// //                                 child: Column(
// //                                   children: [
// //                                     fieldTypeRadio(4, 'MULTI-OPTIONS',
// //                                         Icons.list_alt_rounded),
// //                                     if (_selectedValue == 4) ...[
// //                                       const SizedBox(height: 10),
// //                                       ..._options.map(
// //                                         (option) => Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               horizontal: 40, vertical: 5),
// //                                           child: Row(
// //                                             children: [
// //                                               Expanded(
// //                                                 child: Container(
// //                                                   height: 40,
// //                                                   padding: const EdgeInsets
// //                                                       .symmetric(
// //                                                       horizontal: 12),
// //                                                   decoration: BoxDecoration(
// //                                                     border: Border.all(
// //                                                         color: Colors.grey),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                             5),
// //                                                   ),
// //                                                   child: Align(
// //                                                     alignment:
// //                                                         Alignment.centerLeft,
// //                                                     child: Row(
// //                                                       children: [
// //                                                         Text(option),
// //                                                         const Spacer(),
// //                                                         CustomButton(
// //                                                           textButtonText:
// //                                                               'Add Field',
// //                                                           textButtonCallback:
// //                                                               _addfield,
// //                                                           textButtonStyle:
// //                                                               TextButton
// //                                                                   .styleFrom(
// //                                                             foregroundColor:
// //                                                                 Colors.blue,
// //                                                             textStyle:
// //                                                                 const TextStyle(
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .bold),
// //                                                           ),
// //                                                         ),
// //                                                         // GestureDetector(
// //                                                         //   onTap: _addOption,
// //                                                         //   child: const Icon(
// //                                                         //     Icons.add_circle,
// //                                                         //     color: Colors.blue,
// //                                                         //   ),
// //                                                         // ),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       GestureDetector(
// //                                         onTap: _addOption,
// //                                         child: Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               vertical: 10),
// //                                           child: CustomText(
// //                                             text: 'Add Option',
// //                                             style: const TextStyle(
// //                                                 color: Colors.blue,
// //                                                 fontSize: 14,
// //                                                 fontWeight: FontWeight.bold),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ]
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 SizedBox(
// //                   width: 350,
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 0),
// //                       child: Column(
// //                         children: [
// //                           CheckboxListTile(
// //                             title:
// //                                 const Text('Auto filled for next interaction'),
// //                             subtitle: const Text(
// //                                 'Auto fill happens when a customer is searched by mobile/name or when the interaction is created from the customer details page'),
// //                             value: _autoFill,
// //                             onChanged: (bool? value) {
// //                               setState(() {
// //                                 _autoFill = value!;
// //                               });
// //                             },
// //                           ),
// //                           const SizedBox(height: 20),
// //                           CheckboxListTile(
// //                             title: const Text('Filterable field'),
// //                             subtitle: const Text(
// //                                 'This field should be avaliable in the filters.Filtering can only be enabled for options field'),
// //                             value: _filterableField,
// //                             onChanged: (bool? value) {
// //                               setState(() {
// //                                 _filterableField = value!;
// //                               });
// //                             },
// //                           ),
// //                           const SizedBox(height: 20),
// //                           CheckboxListTile(
// //                             title: const Text('Readonly field'),
// //                             subtitle: const Text(
// //                                 'This field cannot be edited while adding new interactions for a lead'),
// //                             value: _readonlyField,
// //                             onChanged: (bool? value) {
// //                               setState(() {
// //                                 _readonlyField = value!;
// //                               });
// //                             },
// //                           ),
// //                           const SizedBox(height: 20),
// //                           CheckboxListTile(
// //                             title: const Text('Mandatory field'),
// //                             subtitle: const Text(
// //                                 'Interaction cannot be submitted, without filling this field.'),
// //                             value: _mandatoryField,
// //                             onChanged: (bool? value) {
// //                               setState(() {
// //                                 _mandatoryField = value!;
// //                               });
// //                             },
// //                           ),
// //                           const SizedBox(height: 20),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             CustomButton(
// //               textButtonText: 'Cancel',
// //               elevatedButtonText: 'Save',
// //               textButtonCallback: () {
// //                 // Handle TextButton action
// //                 Navigator.of(context).pop();
// //               },
// //               elevatedButtonCallback: _saveField,
// //               textButtonStyle: TextButton.styleFrom(
// //                 foregroundColor: Colors.blue,
// //                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               elevatedButtonStyle: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.blue,
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// // Widget fieldTypeRadio(int value, String label, IconData icon) {
// //   return RadioListTile<int>(
// //     contentPadding: const EdgeInsets.symmetric(
// //         horizontal: 16.0), // Adjust padding as needed
// //     title: Row(
// //       children: [
// //         Icon(icon, color: Colors.grey),
// //         const SizedBox(width: 16.0), // Space between icon and text
// //         Expanded(
// //           child: Text(
// //             label,
// //             style: const TextStyle(color: Colors.grey, fontSize: 16),
// //           ),
// //         ),
// //       ],
// //     ),
// //     value: value,
// //     groupValue: _selectedValue,
// //     onChanged: (int? newValue) {
// //       setState(() {
// //         _selectedValue = newValue;
// //       });
// //     },
// //   );
// // }
// // }

// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
// import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
// import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
// import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
// import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

// class AddFields extends StatefulWidget {
//   final Function(String) onFieldAdded;
//   final Function(String)? onOptionAdded;

//   const AddFields({
//     super.key,
//     required this.onFieldAdded,
//     this.onOptionAdded,
//   });

//   @override
//   State<AddFields> createState() => _AddFieldsState();
// }

// class _AddFieldsState extends State<AddFields> {
//   final TextEditingController _fieldNameController = TextEditingController();
//   final TextEditingController _optionController = TextEditingController();
//   int? _selectedValue;
//   bool _autoFill = false;
//   bool _filterableField = false;
//   bool _readonlyField = false;
//   bool _mandatoryField = false;
//   // final List<String> _options = [];
//   final List<Map<String, dynamic>> _options = [];

//   final List<String> _fields = [];

//   // void _addOption() {
//   //   String optionName = _optionController.text.trim();
//   //   if (optionName.isNotEmpty) {
//   //     setState(() {
//   //       _options.add(optionName);
//   //       _optionController.clear();
//   //     });
//   //     if (widget.onOptionAdded != null) {
//   //       widget.onOptionAdded!(optionName);
//   //     }
//   //   }
//   // }

//   void _addOption() {
//     String optionName = _optionController.text.trim();
//     if (optionName.isNotEmpty) {
//       setState(() {
//         _options.add({
//           'name': optionName,
//           'type': 'text', // Default type
//           'field': 'mandatory' // Default field
//         });
//         _optionController.clear();
//       });
//       if (widget.onOptionAdded != null) {
//         widget.onOptionAdded!(optionName);
//       }
//     }
//   }

//   // void _saveField() {
//   //   String fieldName = _fieldNameController.text.trim();
//   //   String fieldType = _getSelectedFieldType();
//   //   String fieldAttributes = _getCheckboxAttributes();

//   //   if (fieldName.isNotEmpty && fieldType.isNotEmpty) {
//   //     CRMField crmField = CRMField(
//   //       name: fieldName,
//   //       type: fieldType,
//   //       field: fieldAttributes,
//   //     );

//   //     Provider.of<CRMFieldsProvider>(context, listen: false)
//   //         .addCRMField("ABC-1234-999", crmField);

//   //     setState(() {
//   //       _fields.add(fieldName);
//   //       _fieldNameController.clear();
//   //       _selectedValue = null;
//   //       _autoFill = false;
//   //       _filterableField = false;
//   //       _readonlyField = false;
//   //       _mandatoryField = false;
//   //       _options.clear();
//   //     });

//   //     widget.onFieldAdded(fieldName);
//   //     Navigator.of(context).pop();
//   //   }
//   // }

//   void _saveField() {
//     String fieldName = _fieldNameController.text.trim();
//     String fieldType = _getSelectedFieldType();
//     String fieldAttributes = _getCheckboxAttributes();

//     List<CRMField> subFields = [];

//     if (fieldType == 'options' || fieldType == 'multi-options') {
//       subFields = _gatherSubFields(); // Function to gather subfields
//     }

//     if (fieldName.isNotEmpty && fieldType.isNotEmpty) {
//       CRMField crmField = CRMField(
//         name: fieldName,
//         type: fieldType,
//         field: fieldAttributes,
//         subFields: subFields,
//       );

//       // Print CRMField data for debugging
//       print('Saving CRMField:');
//       print('Name: ${crmField.name}');
//       print('Type: ${crmField.type}');
//       print('Field Attributes: ${crmField.field}');
//       print('SubFields: ${crmField.subFields.map((f) => f.toMap()).toList()}');

//       Provider.of<CRMFieldsProvider>(context, listen: false)
//           .addCRMField("ABC-1234-999", crmField);

//       setState(() {
//         _fields.add(fieldName);
//         _fieldNameController.clear();
//         _selectedValue = null;
//         _autoFill = false;
//         _filterableField = false;
//         _readonlyField = false;
//         _mandatoryField = false;
//         _options.clear();
//       });

//       widget.onFieldAdded(fieldName);
//       Navigator.of(context).pop();
//     }
//   }

//   List<CRMField> _gatherSubFields() {
//     List<CRMField> subFields = [];

//     for (var option in _options) {
//       print('Processing option: $option');
//       CRMField subField = CRMField(
//         name: option['name'] is List ? 'Nested Options' : option['name'],
//         type: option['type'],
//         field: option['field'],
//       );

//       if (option['type'] == 'options' || option['type'] == 'multi-options') {
//         subField = subField.copyWith(
//           subFields: _gatherSubFieldsForOption(option),
//         );
//       }

//       subFields.add(subField);
//     }

//     print('Gathered subFields: ${subFields.map((f) => f.toMap()).toList()}');

//     return subFields;
//   }

//   List<CRMField> _gatherSubFieldsForOption(Map<String, dynamic> option) {
//     List<CRMField> subFields = [];

//     // Handle nested options
//     var subOptions = option['option']; // This can be a List or a single Map

//     if (subOptions is List) {
//       for (var subOption in subOptions) {
//         // Ensure subOption is a Map<String, dynamic>
//         if (subOption is Map<String, dynamic>) {
//           CRMField subField = CRMField(
//             name: subOption['name'] as String,
//             type: subOption['type'] as String,
//             field: subOption['field'] as String,
//           );

//           if (subOption['type'] == 'options' ||
//               subOption['type'] == 'multi-options') {
//             subField = subField.copyWith(
//               subFields: _gatherSubFieldsForOption(subOption),
//             );
//           }

//           subFields.add(subField);
//         } else {
//           throw ArgumentError('Expected a Map<String, dynamic> for subOption');
//         }
//       }
//     } else if (subOptions is Map<String, dynamic>) {
//       CRMField subField = CRMField(
//         name: subOptions['name'] as String,
//         type: subOptions['type'] as String,
//         field: subOptions['field'] as String,
//       );

//       if (subOptions['type'] == 'options' ||
//           subOptions['type'] == 'multi-options') {
//         subField = subField.copyWith(
//           subFields: _gatherSubFieldsForOption(subOptions),
//         );
//       }

//       subFields.add(subField);
//     } else {
//       throw ArgumentError(
//           'Expected subOptions to be either List or Map<String, dynamic>');
//     }

//     return subFields;
//   }

//   //

//   // void _submitField() {
//   //   // Example data
//   //   CRMField newField = CRMField(
//   //     name: 'New Field',
//   //     type: 'MAIN_FIELD',
//   //     field: '',
//   //     subFields: _subFields,
//   //   );

//   //   final provider = Provider.of<CRMFieldsProvider>(context, listen: false);
//   //   provider.addCRMField('organizationId', newField);
//   // }

//   String _getSelectedFieldType() {
//     switch (_selectedValue) {
//       case 0:
//         return 'text';
//       case 1:
//         return 'number';
//       case 2:
//         return 'date';
//       case 3:
//         return 'options';
//       case 4:
//         return 'multi-options';
//       default:
//         return '';
//     }
//   }

//   String _getCheckboxAttributes() {
//     List<String> attributes = [];
//     if (_autoFill) attributes.add('autofill');
//     if (_filterableField) attributes.add('filterable');
//     if (_readonlyField) attributes.add('readonly');
//     if (_mandatoryField) attributes.add('mandatory');
//     return attributes.join(',');
//   }

//   void _showDialog({
//     required Widget child,
//     required double widthFactor,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * widthFactor,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: child,
//           ),
//         );
//       },
//     );
//   }

//   // void _addFieldDialog() {
//   //   _showDialog(
//   //     child: AddFields(
//   //       onFieldAdded: (fieldName) {
//   //         setState(() {
//   //           _fields.add(fieldName);
//   //         });
//   //       },
//   //     ),
//   //     widthFactor: 0.5,
//   //   );
//   // }

//   void _addFieldDialog() {
//     _showDialog(
//       child: AddFields(
//         onFieldAdded: (fieldName) {
//           setState(() {
//             _fields.add(fieldName);
//           });
//         },
//       ),
//       widthFactor: 0.5,
//     );
//   }

//   void _addOptionDialog() {
//     print('Showing Add Option Dialog');
//     _showDialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Add Option',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           CustomFormField(
//             controller: _optionController,
//             hintText: 'Enter option',
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             width: double.infinity,
//             child: CustomButton(
//               elevatedButtonText: 'Save',
//               elevatedButtonCallback: () {
//                 _addOption();
//                 print('Option Added: ${_optionController.text}');
//                 Navigator.of(context).pop();
//               },
//               elevatedButtonStyle: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       widthFactor: 0.3,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('Build Method Called'); // Log when the widget rebuilds

//     // Log field data
//     print('Options: $_options');
//     print('Fields: $_fields');
//     print('Selected Value: $_selectedValue');
//     return Container(
//       color: const Color(0xffF2F4F7),
//       child: Padding(
//         padding: const EdgeInsets.all(0),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: 350,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 20, horizontal: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Row(
//                             children: [
//                               Text("Field Name",
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.bold)),
//                               Text("*", style: TextStyle(color: Colors.red)),
//                             ],
//                           ),
//                           CustomFormField(
//                             controller: _fieldNameController,
//                             hintText: 'Enter Field name',
//                           ),
//                           const SizedBox(height: 20),
//                           const Text("Field Type",
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 10),
//                           Column(
//                             children: [
//                               Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(0),
//                                   ),
//                                   child: fieldTypeRadio(
//                                       0, 'TEXT', Icons.abc_rounded)),
//                               const SizedBox(height: 10),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 child: fieldTypeRadio(
//                                     1, 'NUMBER', Icons.onetwothree_rounded),
//                               ),
//                               const SizedBox(height: 10),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 child: fieldTypeRadio(
//                                     2, 'DATE', Icons.calendar_today_rounded),
//                               ),
//                               const SizedBox(height: 10),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     fieldTypeRadio(
//                                         3, 'OPTIONS', Icons.list_outlined),
//                                     if (_selectedValue == 3) ...[
//                                       const SizedBox(height: 10),
//                                       ..._options.map((option) {
//                                         print('Option: $option');

//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20,
//                                               top: 2,
//                                               bottom: 2,
//                                               right: 10),
//                                           // symmetric(
//                                           //     horizontal: 40, vertical: 0),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 40,
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 10,
//                                                       vertical: 5),
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             0),
//                                                   ),
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     child: Row(
//                                                       children: [
//                                                         Text(option['name']),
//                                                         const Spacer(),
//                                                         CustomButton(
//                                                           textButtonText:
//                                                               'Add Field',
//                                                           textButtonCallback:
//                                                               _addFieldDialog,
//                                                           textButtonStyle:
//                                                               TextButton
//                                                                   .styleFrom(
//                                                             foregroundColor:
//                                                                 Colors.blue,
//                                                             textStyle:
//                                                                 const TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                       const SizedBox(height: 5),
//                                       ..._fields.map((field) {
//                                         print('Field: $field');
//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 30,
//                                               top: 2,
//                                               bottom: 2,
//                                               right: 10),
//                                           // symmetric(
//                                           //     horizontal: 40, vertical: 5),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 40,
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 12),
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             0),
//                                                   ),
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     child: Row(
//                                                       children: [
//                                                         Text(field),
//                                                         const Spacer(),
//                                                         CustomButton(
//                                                           textButtonText:
//                                                               'View',
//                                                           textButtonCallback:
//                                                               _addFieldDialog,
//                                                           textButtonStyle:
//                                                               TextButton
//                                                                   .styleFrom(
//                                                             foregroundColor:
//                                                                 Colors.blue,
//                                                             textStyle:
//                                                                 const TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                       GestureDetector(
//                                         onTap: _addOptionDialog,
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: CustomText(
//                                             text: 'Add Option',
//                                             style: const TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     fieldTypeRadio(4, 'MULTI-OPTIONS',
//                                         Icons.list_alt_rounded),
//                                     if (_selectedValue == 4) ...[
//                                       const SizedBox(height: 10),
//                                       ..._options.map((option) => Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 20,
//                                                 top: 2,
//                                                 bottom: 2,
//                                                 right: 10),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Container(
//                                                     height: 40,
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 5),
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: Colors.grey),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               0),
//                                                     ),
//                                                     child: Align(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Row(
//                                                         children: [
//                                                           Text(option['name']),
//                                                           const Spacer(),
//                                                           CustomButton(
//                                                             textButtonText:
//                                                                 'Add Field',
//                                                             textButtonCallback:
//                                                                 _addFieldDialog,
//                                                             textButtonStyle:
//                                                                 TextButton
//                                                                     .styleFrom(
//                                                               foregroundColor:
//                                                                   Colors.blue,
//                                                               textStyle: const TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )),
//                                       const SizedBox(height: 5),
//                                       ..._fields.map((field) => Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 30,
//                                                 top: 2,
//                                                 bottom: 2,
//                                                 right: 10),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Container(
//                                                     height: 40,
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 12),
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: Colors.grey),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               0),
//                                                     ),
//                                                     child: Align(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Row(
//                                                         children: [
//                                                           Text(field),
//                                                           const Spacer(),
//                                                           CustomButton(
//                                                             textButtonText:
//                                                                 'View',
//                                                             textButtonCallback:
//                                                                 _addFieldDialog,
//                                                             textButtonStyle:
//                                                                 TextButton
//                                                                     .styleFrom(
//                                                               foregroundColor:
//                                                                   Colors.blue,
//                                                               textStyle: const TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )),
//                                       GestureDetector(
//                                         onTap: _addOptionDialog,
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: CustomText(
//                                             text: 'Add Option',
//                                             style: const TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 SizedBox(
//                   width: 350,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CheckboxListTile(
//                           title: const Text('Auto filled for next interaction'),
//                           subtitle: const Text(
//                               'Auto fill happens when a customer is searched by mobile/name or when the interaction is created from the customer details page'),
//                           value: _autoFill,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _autoFill = value!;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         CheckboxListTile(
//                           title: const Text('Filterable field'),
//                           subtitle: const Text(
//                               'This field should be available in the filters. Filtering can only be enabled for options field'),
//                           value: _filterableField,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _filterableField = value!;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         CheckboxListTile(
//                           title: const Text('Readonly field'),
//                           subtitle: const Text(
//                               'This field cannot be edited while adding new interactions for a lead'),
//                           value: _readonlyField,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _readonlyField = value!;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         CheckboxListTile(
//                           title: const Text('Mandatory field'),
//                           subtitle: const Text(
//                               'Interaction cannot be submitted, without filling this field.'),
//                           value: _mandatoryField,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _mandatoryField = value!;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             CustomButton(
//                               elevatedButtonText: 'Save',
//                               elevatedButtonCallback: _saveField,
//                               elevatedButtonStyle: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                                 textStyle: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text('Cancel',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue)))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget fieldTypeRadio(int value, String label, IconData icon) {
//     return RadioListTile<int>(
//       contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16.0), // Adjust padding as needed
//       title: Row(
//         children: [
//           Icon(icon, color: Colors.grey),
//           const SizedBox(width: 16.0), // Space between icon and text
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       value: value,
//       groupValue: _selectedValue,
//       onChanged: (int? newValue) {
//         setState(() {
//           _selectedValue = newValue;
//         });
//       },
//     );
//   }
// }

// //////////////////////////////////////////////////////////////////////////////////////////////////////

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
// // import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
// // import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

// // class AddFields extends StatefulWidget {
// //   final Function(String) onFieldAdded;
// //   final Function(String)? onOptionAdded; // Callback for handling options

// //   const AddFields({
// //     super.key,
// //     required this.onFieldAdded,
// //     this.onOptionAdded,
// //   });

// //   @override
// //   State<AddFields> createState() => _AddFieldsState();
// // }

// // class _AddFieldsState extends State<AddFields> {
// //   final TextEditingController _fieldNameController = TextEditingController();
// //   final TextEditingController _optionController = TextEditingController();
// //   int? _selectedValue;
// //   bool _autoFill = false;
// //   bool _filterableField = false;
// //   bool _readonlyField = false;
// //   bool _mandatoryField = false;
// //   final List<String> _options = [];
// //   final List<String> _fields = [];

// //   void _addOption() {
// //     String optionName = _optionController.text.trim();
// //     if (optionName.isNotEmpty) {
// //       setState(() {
// //         _options.add(optionName);
// //         _optionController.clear();
// //       });
// //       if (widget.onOptionAdded != null) {
// //         widget.onOptionAdded!(optionName);
// //       }
// //     }
// //   }

// //   void _saveField() {
// //     String fieldName = _fieldNameController.text.trim();
// //     String fieldType = _getSelectedFieldType();
// //     String fieldAttributes = _getCheckboxAttributes();

// //     if (fieldName.isNotEmpty && fieldType.isNotEmpty) {
// //       CRMField crmField = CRMField(
// //         name: fieldName,
// //         type: fieldType,
// //         field: fieldAttributes,
// //       );

// //       Provider.of<DefaultProvider>(context, listen: false)
// //           .addCRMField("ABC-1234-999", crmField);

// //       setState(() {
// //         _fields.add(fieldName);
// //         _fieldNameController.clear();
// //         _selectedValue = null;
// //         _autoFill = false;
// //         _filterableField = false;
// //         _readonlyField = false;
// //         _mandatoryField = false;
// //         _options.clear();
// //       });

// //       widget.onFieldAdded(fieldName);
// //       Navigator.of(context).pop();
// //     }
// //   }

// //   String _getSelectedFieldType() {
// //     switch (_selectedValue) {
// //       case 0:
// //         return 'textfield';
// //       case 1:
// //         return 'number';
// //       case 2:
// //         return 'date';
// //       case 3:
// //         return 'options';
// //       case 4:
// //         return 'multi-options';
// //       default:
// //         return '';
// //     }
// //   }

// //   String _getCheckboxAttributes() {
// //     List<String> attributes = [];
// //     if (_autoFill) attributes.add('autofill');
// //     if (_filterableField) attributes.add('filterable');
// //     if (_readonlyField) attributes.add('readonly');
// //     if (_mandatoryField) attributes.add('mandatory');
// //     return attributes.join(',');
// //   }

// //   void _showDialog({
// //     required Widget child,
// //     required double widthFactor,
// //   }) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Container(
// //             width: MediaQuery.of(context).size.width * widthFactor,
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: child,
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _addFieldDialog() {
// //     _showDialog(
// //       child: AddFields(
// //         onFieldAdded: (fieldName) {
// //           setState(() {
// //             _fields.add(fieldName);
// //           });
// //         },
// //       ),
// //       widthFactor: 0.5,
// //     );
// //   }

// //   void _addOptionDialog() {
// //     _showDialog(
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text('Add Option',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 20),
// //           CustomFormField(
// //             controller: _optionController,
// //             hintText: 'Enter option',
// //           ),
// //           const SizedBox(height: 10),
// //           SizedBox(
// //             width: double.infinity,
// //             child: CustomButton(
// //               elevatedButtonText: 'Save',
// //               elevatedButtonCallback: () {
// //                 _addOption();
// //                 Navigator.of(context).pop();
// //               },
// //               elevatedButtonStyle: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.orange,
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       widthFactor: 0.3,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: const Color(0xffF2F4F7),
// //       child: Padding(
// //         padding: const EdgeInsets.all(0),
// //         child: Column(
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   width: 350,
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                           vertical: 20, horizontal: 16),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           const Text("Field Name",
// //                               style: TextStyle(fontWeight: FontWeight.bold)),
// //                           const Text("*", style: TextStyle(color: Colors.red)),
// //                           CustomFormField(
// //                             controller: _fieldNameController,
// //                             hintText: 'Enter Field name',
// //                           ),
// //                           const SizedBox(height: 20),
// //                           const Text("Field Type",
// //                               style: TextStyle(fontWeight: FontWeight.bold)),
// //                           const SizedBox(height: 10),
// //                           Column(
// //                             children: [
// //                               fieldTypeRadio(0, 'TEXT', Icons.abc_rounded),
// //                               const SizedBox(height: 10),
// //                               fieldTypeRadio(
// //                                   1, 'NUMBER', Icons.onetwothree_rounded),
// //                               const SizedBox(height: 10),
// //                               fieldTypeRadio(
// //                                   2, 'DATE', Icons.calendar_today_rounded),
// //                               const SizedBox(height: 10),
// //                               fieldTypeRadio(3, 'OPTIONS', Icons.list_outlined),
// //                               if (_selectedValue == 3) ...[
// //                                 const SizedBox(height: 10),
// //                                 ..._options.map((option) => Padding(
// //                                       padding: const EdgeInsets.symmetric(
// //                                           horizontal: 40, vertical: 0),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Container(
// //                                               height: 40,
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       horizontal: 12),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                     color: Colors.grey),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                               ),
// //                                               child: Align(
// //                                                 alignment: Alignment.centerLeft,
// //                                                 child: Row(
// //                                                   children: [
// //                                                     Text(option),
// //                                                     const Spacer(),
// //                                                     CustomButton(
// //                                                       textButtonText:
// //                                                           'Add Field',
// //                                                       textButtonCallback:
// //                                                           _addFieldDialog,
// //                                                       textButtonStyle:
// //                                                           TextButton.styleFrom(
// //                                                         foregroundColor:
// //                                                             Colors.blue,
// //                                                         textStyle:
// //                                                             const TextStyle(
// //                                                                 fontWeight:
// //                                                                     FontWeight
// //                                                                         .bold),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     )),

// //                                 const SizedBox(height: 5),
// //                                 ..._fields.map((field) => Padding(
// //                                       padding: const EdgeInsets.symmetric(
// //                                           horizontal: 40, vertical: 5),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Container(
// //                                               height: 40,
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       horizontal: 12),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                     color: Colors.grey),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                               ),
// //                                               child: Align(
// //                                                 alignment: Alignment.centerLeft,
// //                                                 child: Row(
// //                                                   children: [
// //                                                     Text(field),
// //                                                     const Spacer(),
// //                                                     CustomButton(
// //                                                       textButtonText:
// //                                                           'Add Field',
// //                                                       textButtonCallback:
// //                                                           _addFieldDialog,
// //                                                       textButtonStyle:
// //                                                           TextButton.styleFrom(
// //                                                         foregroundColor:
// //                                                             Colors.blue,
// //                                                         textStyle:
// //                                                             const TextStyle(
// //                                                                 fontWeight:
// //                                                                     FontWeight
// //                                                                         .bold),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     )),

// //                                 GestureDetector(
// //                                   onTap: _addOptionDialog,
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         vertical: 10),
// //                                     child: CustomText(
// //                                       text: 'Add Option',
// //                                       style: const TextStyle(
// //                                           color: Colors.blue,
// //                                           fontSize: 14,
// //                                           fontWeight: FontWeight.bold),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                               fieldTypeRadio(
// //                                   4, 'MULTI-OPTIONS', Icons.list_alt_rounded),
// //                               if (_selectedValue == 4) ...[
// //                                 const SizedBox(height: 10),
// //                                 ..._options.map((option) => Padding(
// //                                       padding: const EdgeInsets.symmetric(
// //                                           horizontal: 40, vertical: 5),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Container(
// //                                               height: 40,
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       horizontal: 12),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                     color: Colors.grey),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                               ),
// //                                               child: Align(
// //                                                 alignment: Alignment.centerLeft,
// //                                                 child: Row(
// //                                                   children: [
// //                                                     Text(option),
// //                                                     const Spacer(),
// //                                                     CustomButton(
// //                                                       textButtonText:
// //                                                           'Add Field',
// //                                                       textButtonCallback:
// //                                                           _addFieldDialog,
// //                                                       textButtonStyle:
// //                                                           TextButton.styleFrom(
// //                                                         foregroundColor:
// //                                                             Colors.blue,
// //                                                         textStyle:
// //                                                             const TextStyle(
// //                                                                 fontWeight:
// //                                                                     FontWeight
// //                                                                         .bold),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     )),
// //                                 GestureDetector(
// //                                   onTap: _addOptionDialog,
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         vertical: 10),
// //                                     child: CustomText(
// //                                       text: 'Add Option',
// //                                       style: const TextStyle(
// //                                           color: Colors.blue,
// //                                           fontSize: 14,
// //                                           fontWeight: FontWeight.bold),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 10),
// //                                 ..._fields.map((field) => Padding(
// //                                       padding: const EdgeInsets.symmetric(
// //                                           horizontal: 40, vertical: 5),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Container(
// //                                               height: 40,
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       horizontal: 12),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                     color: Colors.grey),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                               ),
// //                                               child: Align(
// //                                                 alignment: Alignment.centerLeft,
// //                                                 child: Row(
// //                                                   children: [
// //                                                     Text(field),
// //                                                     const Spacer(),
// //                                                     CustomButton(
// //                                                       textButtonText:
// //                                                           'Add Field',
// //                                                       textButtonCallback:
// //                                                           _addFieldDialog,
// //                                                       textButtonStyle:
// //                                                           TextButton.styleFrom(
// //                                                         foregroundColor:
// //                                                             Colors.blue,
// //                                                         textStyle:
// //                                                             const TextStyle(
// //                                                                 fontWeight:
// //                                                                     FontWeight
// //                                                                         .bold),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ))
// //                               ]
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //     const SizedBox(width: 20),
// //     SizedBox(
// //       width: 350,
// //       child: SingleChildScrollView(
// //         child: Column(
// //           // crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             CheckboxListTile(
// //               title: const Text('Auto filled for next interaction'),
// //               subtitle: const Text(
// //                   'Auto fill happens when a customer is searched by mobile/name or when the interaction is created from the customer details page'),
// //               value: _autoFill,
// //               onChanged: (bool? value) {
// //                 setState(() {
// //                   _autoFill = value!;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //             CheckboxListTile(
// //               title: const Text('Filterable field'),
// //               subtitle: const Text(
// //                   'This field should be available in the filters. Filtering can only be enabled for options field'),
// //               value: _filterableField,
// //               onChanged: (bool? value) {
// //                 setState(() {
// //                   _filterableField = value!;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //             CheckboxListTile(
// //               title: const Text('Readonly field'),
// //               subtitle: const Text(
// //                   'This field cannot be edited while adding new interactions for a lead'),
// //               value: _readonlyField,
// //               onChanged: (bool? value) {
// //                 setState(() {
// //                   _readonlyField = value!;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //             CheckboxListTile(
// //               title: const Text('Mandatory field'),
// //               subtitle: const Text(
// //                   'Interaction cannot be submitted, without filling this field.'),
// //               value: _mandatoryField,
// //               onChanged: (bool? value) {
// //                 setState(() {
// //                   _mandatoryField = value!;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     ),
// //   ],
// // ),
// //             const SizedBox(width: 20),

// //             CustomButton(
// //               textButtonText: 'Cancel',
// //               elevatedButtonText: 'Save',
// //               textButtonCallback: () {
// //                 // Handle TextButton action
// //                 Navigator.of(context).pop();
// //               },
// //               elevatedButtonCallback: _saveField,
// //               textButtonStyle: TextButton.styleFrom(
// //                 foregroundColor: Colors.blue,
// //                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               elevatedButtonStyle: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.blue,
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //             ),

// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget fieldTypeRadio(int value, String label, IconData icon) {
// //     return RadioListTile<int>(
// //       contentPadding: const EdgeInsets.symmetric(
// //           horizontal: 16.0), // Adjust padding as needed
// //       title: Row(
// //         children: [
// //           Icon(icon, color: Colors.grey),
// //           const SizedBox(width: 16.0), // Space between icon and text
// //           Expanded(
// //             child: Text(
// //               label,
// //               style: const TextStyle(color: Colors.grey, fontSize: 16),
// //             ),
// //           ),
// //         ],
// //       ),
// //       value: value,
// //       groupValue: _selectedValue,
// //       onChanged: (int? newValue) {
// //         setState(() {
// //           _selectedValue = newValue;
// //         });
// //       },
// //     );
// //   }
// // }
