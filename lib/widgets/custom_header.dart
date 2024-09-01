import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class HeaderRow extends StatelessWidget {
  final List<String> titles;

  const HeaderRow({
    super.key,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF9FAFB),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          titles.length,
          (index) => Expanded(
            flex: 1, // Set the same flex value for each Expanded widget
            child: CustomText(
              text: titles[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}












 //  SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: List.generate(
          //       titles.length,
          //       (index) => Expanded(
          //         flex: 1,
          //         child: CustomText(
          //           text: titles[index],
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),