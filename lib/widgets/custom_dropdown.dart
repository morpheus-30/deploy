import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class CustomDropdown extends StatefulWidget {
  final TextEditingController? controller;
  final String? firestorePath;
  final String hintText;
  final IconData? hintIcon;
  final List<Map<String, dynamic>>? items;
  final void Function(String) onSelected;
  final String? Function(Map<String, dynamic>?)? validator;
  final List<Map<String, dynamic>> Function(List<DocumentSnapshot>)?
      mapFunction;

  const CustomDropdown({
    super.key,
    this.firestorePath,
    required this.hintText,
    this.hintIcon,
    this.items,
    required this.onSelected,
    this.validator,
    this.controller,
    this.mapFunction,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  Future<List<Map<String, dynamic>>>? itemsFuture;
  Map<String, dynamic>? selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.items != null) {
      print('Using predefined items');
      itemsFuture = Future.value(widget.items!);
    } else if (widget.firestorePath != null) {
      print('Fetching data from Firestore');
      itemsFuture = fetchData();
    } else {
      print('No items or Firestore path provided');
      itemsFuture = Future.value([]);
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      print('Starting to fetch data from Firestore');
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(widget.firestorePath!)
          .get();
      print('Snapshot fetched. Document count: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        print('No documents found at the path.');
      }

      List<Map<String, dynamic>> fetchedItems;
      if (widget.mapFunction != null) {
        fetchedItems = widget.mapFunction!(snapshot.docs);
      } else {
        // Default mapping logic
        fetchedItems = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            'value': data['name'] ?? '',
            'type': data['type'] ?? '',
          };
        }).toList();
      }

      // Ensure widget is mounted before calling setState
      if (mounted) {
        setState(() {
          // Assuming you want to update itemsFuture or some other state
        });
      }

      return fetchedItems;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      width: 150,
                      height: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No items available');
          } else {
            List<Map<String, dynamic>> items = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border:
                    Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<Map<String, dynamic>>(
                  isExpanded: true,
                  hint: selectedItem == null
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              if (widget.hintIcon != null) ...[
                                Icon(
                                  widget.hintIcon,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Text(
                                  widget.hintText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                  items: items
                      .map((item) => DropdownMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundColor: item['color'],
                                //   radius: 10,
                                // ),
                                // const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    item['value'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  value: selectedItem,
                  onChanged: (value) {
                    print('Dropdown selected: $value');
                    setState(() {
                      selectedItem = value;
                    });
                    widget.onSelected(value?['value']);
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.zero,
                    width: 250,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
