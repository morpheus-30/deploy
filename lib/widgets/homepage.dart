import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/widgets/appbar.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
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
      body: Row(
        children: [
          _buildSideNavigationBar(),
          Expanded(
            child: Center(
              child: Text('Press the menu icon to toggle the navigation bar.'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavigationBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: _showText ? 200 : 60,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              showText: _showText,
            ),
            _buildDrawerItem(
              icon: Icons.assignment,
              text: 'Allocations',
              showText: _showText,
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Customers',
              showText: _showText,
            ),
            _buildDrawerItem(
              icon: Icons.assignment,
              text: 'Followups',
              showText: _showText,
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Call Logs',
              showText: _showText,
            ),
            _buildDrawerItem(
              icon: Icons.assignment,
              text: 'Setting',
              showText: _showText,
            ),
            // Add more drawer items here
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool showText,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: showText ? Text(text) : null,
    );
  }
}
