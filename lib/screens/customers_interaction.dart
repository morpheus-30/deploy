import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds_ai_callmate_web_app/widgets/add_customers_form.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class CustomerInteraction extends StatefulWidget {
  const CustomerInteraction({super.key});

  @override
  State<CustomerInteraction> createState() => _CustomerInteractionState();
}

class _CustomerInteractionState extends State<CustomerInteraction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F4F7),
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          const Expanded(flex: 1, child: AddCustomers()),
          // const SizedBox(
          //   width: 10,
          // ),
          Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        // border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/personal_info.svg', // Ensure this path is correct
                              width: 80,
                              height: 80,
                            ),
                            // const SizedBox(height: 20),
                            // CustomText(text: 'No Data to display'),
                          ],
                        ),
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
