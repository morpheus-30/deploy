import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String hintText;
  final List<String>? dataList;
  final ValueChanged<String> onChanged;

  const SearchPage({
    super.key,
    required this.hintText,
    this.dataList,
    required this.onChanged,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late List<String> _searchResults; // Use late keyword to ensure initialization

  @override
  void initState() {
    super.initState();
    _searchResults = widget.dataList!; // Initialize _searchResults
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = widget.dataList!
          .where((element) =>
              element.toLowerCase().contains(_controller.text.toLowerCase()))
          .toList();
      widget.onChanged(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: 350,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
