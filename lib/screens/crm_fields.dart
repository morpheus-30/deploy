import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/category_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/add_fields.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class CRMFields extends StatefulWidget {
  const CRMFields({super.key});

  @override
  State<CRMFields> createState() => _CRMFieldsState();
}

class _CRMFieldsState extends State<CRMFields> {
  List<Map<String, dynamic>> customFields =
      []; // Replace with your custom fields model

  void _addCustomField(String fieldName, int fieldType) {
    setState(() {
      customFields.add({
        'fieldName': fieldName,
        'fieldType': fieldType,
      });
    });
  }

  bool _isCustomFieldsTabSelected = true;

  @override
  void initState() {
    super.initState();
    _isCustomFieldsTabSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: "CRM Fields",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  elevatedButtonText: 'Add Field',
                  elevatedButtonCallback: () {
                    showDialog(
                        // barrierColor: Color(0xffF2F4F7),
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xffF2F4F7),
                            title: const Text('New Custom Field'),
                            content: SingleChildScrollView(
                              child: AddFields(
                                onFieldAdded: (String) {},
                              ),
                            ),
                          );
                        });
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomTabBar(
// customFields: customFields,
                onTabChanged: (bool isCustomFieldsTab) {
                  setState(() {
                    _isCustomFieldsTabSelected = isCustomFieldsTab;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  final Function(bool) onTabChanged;
  const CustomTabBar({super.key, required this.onTabChanged});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _optionController = TextEditingController();
  Color _selectedColor = Colors.black; // Default color
  String type = 'textfield';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCustomFields();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _optionController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomFields() async {
    final provider = Provider.of<CRMFieldsProvider>(context, listen: false);
    await provider.fetchCRMFields("ABC-1234-999");

    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.fetchCategories();
  }

  Widget customFieldItem({
    required String fieldName,
    required IconData fieldTypeIcon,
    required int index,
    required String fieldTitle,
    required List<String>? options, // Adjusted to handle List<String>
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.drag_indicator),
                    const SizedBox(width: 8),
                    Icon(fieldTypeIcon, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(fieldName),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded),
                      onPressed: () => _showEditDialog(index, fieldName),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(fieldTitle),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (String result) {
                        if (result == 'delete') {
                          _deleteField(index);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
            if (options != null && options.isNotEmpty) ...[
              const SizedBox(height: 4),
              ...options.map((option) => Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 5),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(option),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // child: Text(option),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  void _deleteField(int index) {
    final provider = Provider.of<CRMFieldsProvider>(context, listen: false);
    provider.deleteCRMField(index, "ABC-1234-999");
  }

  void _showEditDialog(int index, String currentName) {
    final TextEditingController editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Field Name'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Enter new field name'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                String newFieldName = editController.text.trim();
                if (newFieldName.isNotEmpty) {
                  _updateFieldName(index, newFieldName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateFieldName(int index, String newFieldName) {
    final provider = Provider.of<CRMFieldsProvider>(context, listen: false);
    provider.updateCRMFieldName(index, newFieldName, "ABC-1234-999");
  }

//////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CRMFieldsProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 280, // Specify the width you want
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.blue,
              controller: _tabController,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: const [
                Tab(text: 'Custom Fields'),
                // Tab(text: 'Default Fields'),
                Tab(text: 'Categories'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Consumer<CRMFieldsProvider>(
                  builder: (context, provider, child) {
                    // if (provider.customFields.isEmpty) {
                    //   return Center(child: CircularProgressIndicator());
                    // }

                    return ListView.builder(
                      itemCount: provider.customFields.length,
                      itemBuilder: (context, index) {
                        final field = provider.customFields[index];
                        return customFieldItem(
                            fieldName: field.name,
                            fieldTypeIcon: _getIconData(field.type),
                            index: index,
                            fieldTitle: field.field,
                            options: field.options);
                      },
                    );
                  },
                ),
              ),

              ////////////////
              Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    _buildCategoryItem('Categories', Icons.list),
                    Consumer<CategoryProvider>(
                      builder: (context, provider, child) {
                        // Print the categories list for debugging
                        print('Categories: ${provider.categories}');

                        return Column(
                          children: provider.categories.map((category) {
                            // Print each category item for debugging
                            print('Category item: $category');

                            // Safely extract values with default fallbacks
                            final name = category['name'] ??
                                'Unnamed'; // Provide default if 'value' is null
                            final type = category['type'] ?? 'unknown';
                            final color = category['color'] ?? '#000000';

                            return Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: CategoryItem(
                                color: _convertHexToColor(color),
                                name: name,
                                type: type,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              )

              // const Center(child: Text('Default Fields')),
            ],
          ),
        ),
      ],
    );
  }

  Color _convertHexToColor(String hexColor) {
    // Ensure that the hex string starts with "0xff" if it's a full color
    hexColor = hexColor.replaceFirst('#', '');

    // Check if the hexColor is a valid 6-character hex code
    if (hexColor.length == 6) {
      hexColor = 'ff$hexColor'; // Add alpha channel to make it fully opaque
    }

    // Convert to integer and then to Color
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget _buildCategoryItem(String fieldName, IconData fieldTypeIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.drag_indicator),
                const SizedBox(width: 8),
                Icon(fieldTypeIcon, color: Colors.grey),
                const SizedBox(width: 8),
                Text(fieldName),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                CustomButton(
                  textButtonText: 'Add Field',
                  textButtonCallback: addOption,
                  textButtonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addOption() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width *
                0.5, // Adjust width as needed
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _optionController,
                  hintText: 'Enter option',
                ),
                const SizedBox(height: 10),
                const Text('Select Color:'),
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 150, // Set a maximum height for the color picker
                  ),
                  child: ColorPicker(
                    pickerColor: _selectedColor,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    showLabel: false,
                    pickerAreaHeightPercent: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        elevatedButtonText: 'Save',
                        elevatedButtonCallback: () async {
                          final optionText = _optionController.text.trim();
                          if (optionText.isNotEmpty) {
                            await provider.checkCategoryDuplicate(optionText);
                            if (!provider.isDuplicate) {
                              // Convert color to hex string
                              final hexColor =
                                  '#${_selectedColor.value.toRadixString(16).padLeft(8, '0')}';
                              final type = 'textfield';

                              await provider.addCategory(
                                  optionText, type, hexColor);
                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Option already exists.'),
                                ),
                              );
                            }
                          }
                        },
                        elevatedButtonStyle: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String? fieldType) {
    switch (fieldType) {
      case 'textfield':
        return Icons.abc_rounded; // TEXT
      case 'number':
        return Icons.onetwothree_rounded; // NUMBER
      case 'date':
        return Icons.calendar_today_rounded; // DATE
      case 'options':
        return Icons.list_outlined; // OPTIONS
      case 'multi-options':
        return Icons.list_alt_rounded; // MULTI-OPTIONS
      default:
        return Icons.help_outline; // Default icon
    }
  }
}

class CategoryItem extends StatefulWidget {
  final String name;
  final String type;
  final Color color;

  const CategoryItem(
      {super.key, required this.name, required this.type, required this.color});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'textfield':
        break;
      case 'checkbox':
        break;
      case 'radio':
        break;
      default:
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.drag_indicator, color: widget.color),
                // const SizedBox(width: 8),
                // Icon(fieldTypeIcon, color: Colors.grey),
                const SizedBox(width: 15),
                Text(widget.name.isNotEmpty ? widget.name : 'Unnamed'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded),
                  onPressed: () => _showEditDialog(context, widget.name),
                ),
              ],
            ),
            Row(
              children: [
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'delete') {
                      Provider.of<CategoryProvider>(context, listen: false)
                          .deleteCategory(widget.name);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String oldName) {
    TextEditingController _nameController =
        TextEditingController(text: oldName);
    String? _errorText; // To hold the error message

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _nameController,
                  hintText: 'Enter option',
                ),
                const SizedBox(height: 10),
                Consumer<CategoryProvider>(builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final newName = _nameController.text.trim();
                        if (newName.isNotEmpty) {
                          await provider.checkCategoryDuplicate(newName);
                          if (!provider.isDuplicate) {
                            // Perform async operation if not a duplicate
                            await provider.addCategory(newName, 'textfield');
                            // Close the dialog after the async operation completes
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          } else {
                            // Show an error message if duplicate
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Option already exists.'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Save'),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
