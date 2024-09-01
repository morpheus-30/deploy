import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_details_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_header.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class EmployeeScreen extends StatelessWidget {
  // final String docPath = '';
  final String docPath = '/organizations/ABC-1234-999/agents';

  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "Employees",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      elevatedButtonText: 'Agents',
                      elevatedButtonCallback: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return const AlertDialog(
                        //         backgroundColor: Colors.white,
                        //         title: Text('Create Lead'),
                        //         content: SingleChildScrollView(
                        //           child: CreateLeads(),
                        //         ),
                        //       );
                        //     });
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
                  ],
                ),
                const SizedBox(height: 20),
                const HeaderRow(
                    titles: ['Name', 'Phone Number', 'Last Synced', 'Actions']),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: Provider.of<DefaultProvider>(context, listen: false)
                        .fetchEmployees(docPath),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.blue,
                            size: 30,
                          ),

                          // child: CircularProgressIndicator()
                        );

                        // Center(
                        //     child: Text('Error fetching employee data'));
                      } else {
                        return Consumer<DefaultProvider>(
                          builder: (context, employeeProvider, child) {
                            final employees = employeeProvider.employees;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: employees.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      EmployeeRow(employee: employees[index]),
                                      if (index < employees.length - 1)
                                        Divider(
                                            height: 1.0,
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeRow extends StatelessWidget {
  final EmployeeDetails employee;

  const EmployeeRow({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Text(employee.name[0]),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    // const Text("Admin"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.phone),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.lastSyncTime),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const EmployeeDetailScreen()),
                    // );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Handle more actions
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
