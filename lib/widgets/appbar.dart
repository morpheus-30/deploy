import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/organization_provider.dart';
import 'package:seeds_ai_callmate_web_app/screens/dashboard.dart';
import 'package:seeds_ai_callmate_web_app/screens/login_screen.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class ResponsiveAppBar extends StatefulWidget {
  const ResponsiveAppBar({super.key});

  @override
  State<ResponsiveAppBar> createState() => _ResponsiveAppBarState();
}

class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return const LargeScreenAppBar();
        } else {
          return const SmallScreenAppBar();
        }
      },
    );
  }
}

class LargeScreenAppBar extends StatefulWidget {
  const LargeScreenAppBar({super.key});

  @override
  State<LargeScreenAppBar> createState() => _LargeScreenAppBarState();
}

class _LargeScreenAppBarState extends State<LargeScreenAppBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showText = false;

  void _toggleDrawer() {
    setState(() {
      _showText = !_showText;
    });
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToDashboard,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 30.0,
                ),
              ),
            ),
            const Spacer(),
            // const Expanded(
            //   child: SearchBar(),
            // ),
            // const SizedBox(width: 20),
            // ProcessButton(),

            IconButton(
              icon: const Icon(Icons.add_circle,
                  color: Color(0xff2498DF), size: 30),
              onPressed: () {
                // Handle add button press
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Handle notifications button press
              },
            ),
            const SizedBox(width: 20),
            const UserProfile(),
          ],
        ),
      ),
      // body: Placeholder(),
    );
  }
}

class SmallScreenAppBar extends StatefulWidget {
  const SmallScreenAppBar({super.key});

  @override
  State<SmallScreenAppBar> createState() => _SmallScreenAppBarState();
}

class _SmallScreenAppBarState extends State<SmallScreenAppBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showText = false;
  void _toggleDrawer() {
    setState(() {
      _showText = !_showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // title: Image.asset('assets/logo.png',
        //     height: 30), // Replace with your logo
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: _toggleDrawer,
        // ),

        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
        title: Image.asset(
          "assets/images/logo.png", // Add your logo image in the assets folder
          height: 30.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search button press
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.apps),
          //   color: Colors.black,
          //   onPressed: () {
          //     // Handle process button press
          //   },
          // ),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xff2498DF),
            child: IconButton(
              icon: const Icon(
                Icons.add,

                // color: Color(0xff2498DF),
              ),
              onPressed: () {
                // Handle add button press
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications button press
            },
          ),
          const UserProfile(),
        ],
      ),
      // body: Row(
      //   children: [
      //     _buildSideNavigationBar(),
      //     Expanded(
      //       child: Center(
      //         child: Text('Press the menu icon to toggle the navigation bar.'),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by Name/Phone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final organization =
        Provider.of<OrganizationProvider>(context).organization;

    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          onTapCallback: () {
            // Navigate to profile screen
          },
          value: 1,
          icon: Icons.settings,
          text: 'Settings',
        ),
        const PopupMenuDivider(),
        _buildPopupMenuItem(
          onTapCallback: () {
            // Navigate to settings screen
          },
          value: 2,
          icon: Icons.shield_moon_outlined,
          text: 'Privacy Policy',
        ),
        const PopupMenuDivider(),
        _buildPopupMenuItem(
          onTapCallback: () {
            //pop until first screen
            Navigator.of(context).popUntil((route) => route.isFirst);
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginBuild(),
              ),
            );
          },
          value: 3,
          icon: Icons.logout,
          text: 'Logout',
        ),
        const PopupMenuDivider(),
      ],
      onSelected: (value) {
        // Handle item selection
        switch (value) {
          case 1:
            // Navigate to profile screen
            break;
          case 2:
            // Navigate to settings screen
            break;
          case 3:
            // Perform logout action
            break;
        }
      },
      child: Row(
        children: [
          CustomText(
            text: organization?.name ?? "seedsai",
            // 'Raj\ntechnologies',
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: Color(0xff2498DF),
            child: Text(
              'R',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.black),
        ],
      ),
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem({
    required int value,
    required IconData icon,
    required String text,
    required void Function() onTapCallback,
  }) {
    return PopupMenuItem<int>(
      onTap: onTapCallback,
      value: value,
      child: ListTile(
        leading: Icon(icon, size: 20, color: Colors.black),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  // PopupMenuItem<int> _buildPopupMenuItem({
  //   required int value,
  //   required IconData icon,
  //   required String text,
  // }) {
  //   return PopupMenuItem<int>(
  //     value: value,
  //     child: Row(
  //       children: [
  //         Icon(icon, size: 20, color: Colors.black),
  //         const SizedBox(width: 10),
  //         Text(
  //           text,
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Suggestions for "$query"'),
    );
  }
}

// void showAlertDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: CustomText(text: "Popup Title"),
//         content: CustomText(text: "This is a small screen popup."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: CustomText(text: "Close"),
//           ),
//         ],
//       );
//     },
//   );
// }
