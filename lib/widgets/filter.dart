import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';

class FilterSort extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? hintIcon;
  final String collectionPath;
  final void Function(String) onSelected;
  final String? Function(Map<String, dynamic>?)? validator;
  final List<Map<String, dynamic>>? localItems; // Optional local items

  const FilterSort({
    Key? key,
    required this.hintText,
    this.hintIcon,
    required this.collectionPath,
    required this.onSelected,
    this.validator,
    this.localItems,
    this.controller, // Initialize with null if not provided
  }) : super(key: key);

  @override
  State<FilterSort> createState() => _FilterSortState();
}

class _FilterSortState extends State<FilterSort> {
  List<Map<String, dynamic>> items = []; // Initialize items as an empty list
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print('Starting to fetch data from Firestore');
    List<Map<String, dynamic>> fetchedItems =
        await context.read<DefaultProvider>().fetchItems(widget.collectionPath);
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> buildDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    // Add local items first, if provided
    if (widget.localItems != null) {
      for (var item in widget.localItems!) {
        String displayText = item['name'] ?? 'Unknown';
        dropdownItems.add(
          DropdownMenuItem<String>(
            value: displayText.toLowerCase(),
            child: Text(
              displayText,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    }

    // Add Firestore fetched items
    dropdownItems.addAll(items.map((item) {
      String displayText = item['name'] ?? 'Unknown';
      return DropdownMenuItem<String>(
        value: displayText.toLowerCase(),
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      );
    }));

    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: Expanded(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                if (widget.hintIcon != null)
                  Icon(
                    widget.hintIcon,
                    size: 16,
                    color: Theme.of(context).hintColor,
                  ),
                const SizedBox(width: 8),
                Text(
                  widget.hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            items: buildDropdownItems(),
            value: selectedValue?.toLowerCase(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              if (value != null) {
                widget.onSelected(value);
              }
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: 250,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    hintText: 'Search for an item...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';

// class FilterSort extends StatefulWidget {
//   final String hintText;
//   final IconData? hintIcon;
//   final String collectionPath;
//   final void Function(List<String>) onSelected;
//   final String? Function(Map<String, dynamic>?)? validator;
//   final List<Map<String, dynamic>>? localItems; // Optional local items

//   const FilterSort({
//     Key? key,
//     required this.hintText,
//     this.hintIcon,
//     required this.collectionPath,
//     required this.onSelected,
//     this.validator,
//     this.localItems, // Initialize with null if not provided
//   }) : super(key: key);

//   @override
//   State<FilterSort> createState() => _FilterSortState();
// }

// class _FilterSortState extends State<FilterSort> {
//   List<Map<String, dynamic>> items = []; // Initialize items as an empty list
//   List<String> selectedValues = [];
//   final TextEditingController textEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     List<Map<String, dynamic>> fetchedItems =
//         await context.read<DefaultProvider>().fetchItems(widget.collectionPath);
//     setState(() {
//       items = fetchedItems;
//     });
//   }

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   List<DropdownMenuItem<String>> buildDropdownItems() {
//     List<DropdownMenuItem<String>> dropdownItems = [];

//     // Add local items first, if provided
//     if (widget.localItems != null) {
//       for (var item in widget.localItems!) {
//         String displayText = item['name'] ?? 'Unknown';
//         dropdownItems.add(
//           DropdownMenuItem<String>(
//             value: displayText.toLowerCase(),
//             child: StatefulBuilder(
//               builder: (context, menuState) {
//                 final isSelected =
//                     selectedValues.contains(displayText.toLowerCase());
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       isSelected
//                           ? selectedValues.remove(displayText.toLowerCase())
//                           : selectedValues.add(displayText.toLowerCase());
//                     });
//                     widget.onSelected(selectedValues);
//                   },
//                   child: Container(
//                     height: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Row(
//                       children: [
//                         isSelected
//                             ? const Icon(Icons.check_box_outlined,
//                                 color: Colors.black45)
//                             : const Icon(Icons.check_box_outline_blank,
//                                 color: Colors.black45),
//                         const SizedBox(width: 16.0),
//                         Text(
//                           displayText,
//                           style: const TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     }

//     // Add Firestore fetched items
//     dropdownItems.addAll(items.map((item) {
//       String displayText = item['name'] ?? 'Unknown';
//       return DropdownMenuItem<String>(
//         value: displayText.toLowerCase(),
//         child: StatefulBuilder(
//           builder: (context, menuState) {
//             final isSelected =
//                 selectedValues.contains(displayText.toLowerCase());
//             return InkWell(
//               onTap: () {
//                 setState(() {
//                   isSelected
//                       ? selectedValues.remove(displayText.toLowerCase())
//                       : selectedValues.add(displayText.toLowerCase());
//                 });
//                 widget.onSelected(selectedValues);
//               },
//               child: Container(
//                 height: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     isSelected
//                         ? const Icon(Icons.check_box_outlined,
//                             color: Colors.black45)
//                         : const Icon(Icons.check_box_outline_blank,
//                             color: Colors.black45),
//                     const SizedBox(width: 16.0),
//                     Text(
//                       displayText,
//                       style: const TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }));

//     return dropdownItems;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.withOpacity(0.3)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2<String>(
//           isExpanded: true,
//           hint: Row(
//             children: [
//               if (widget.hintIcon != null)
//                 Icon(
//                   widget.hintIcon,
//                   size: 16,
//                   color: Theme.of(context).hintColor,
//                 ),
//               const SizedBox(width: 8),
//               Text(
//                 widget.hintText,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).hintColor,
//                 ),
//               ),
//             ],
//           ),
//           items: buildDropdownItems(),
//           value: selectedValues.isEmpty ? null : selectedValues.last,
//           onChanged: (value) {},
//           selectedItemBuilder: (context) {
//             return items.map((item) {
//               String displayText = item['name'] ?? 'Unknown';
//               return Container(
//                 alignment: AlignmentDirectional.centerStart,
//                 child: Text(
//                   selectedValues.join(', '),
//                   style: const TextStyle(
//                     fontSize: 14,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               );
//             }).toList();
//           },
//           buttonStyleData: const ButtonStyleData(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             width: 250,
//           ),
//           dropdownStyleData: DropdownStyleData(
//             maxHeight: 250,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.white,
//             ),
//           ),
//           menuItemStyleData: const MenuItemStyleData(),
//           dropdownSearchData: DropdownSearchData(
//             searchController: textEditingController,
//             searchInnerWidgetHeight: 50,
//             searchInnerWidget: Container(
//               height: 50,
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//               child: TextFormField(
//                 expands: true,
//                 maxLines: null,
//                 controller: textEditingController,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 5,
//                     vertical: 5,
//                   ),
//                   hintText: 'Search for an item...',
//                   hintStyle: const TextStyle(fontSize: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             searchMatchFn: (item, searchValue) {
//               return item.value
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchValue.toLowerCase());
//             },
//           ),
//           onMenuStateChange: (isOpen) {
//             if (!isOpen) {
//               textEditingController.clear();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
