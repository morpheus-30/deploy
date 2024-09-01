import 'package:flutter/material.dart';

class UserPopup extends StatefulWidget {
  const UserPopup({super.key});

  @override
  State<UserPopup> createState() => _UserPopupState();
}

class _UserPopupState extends State<UserPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text("Edit"),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text("Delete"),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.share, color: Colors.green),
              SizedBox(width: 8),
              Text("Share"),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        // Handle item selection
        switch (value) {
          case 1:
            // Handle edit action
            break;
          case 2:
            // Handle delete action
            break;
          case 3:
            // Handle share action
            break;
        }
      },
    );
  }
}
