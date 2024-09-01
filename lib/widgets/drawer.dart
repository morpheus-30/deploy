import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/screens/allocation.dart';
import 'package:seeds_ai_callmate_web_app/screens/call_logs.dart';
import 'package:seeds_ai_callmate_web_app/screens/crm_fields.dart';
import 'package:seeds_ai_callmate_web_app/screens/customers.dart';
import 'package:seeds_ai_callmate_web_app/screens/customers_interaction.dart';
import 'package:seeds_ai_callmate_web_app/screens/dashboard.dart';
import 'package:seeds_ai_callmate_web_app/screens/employees.dart';
import 'package:seeds_ai_callmate_web_app/screens/followups.dart';
import 'package:seeds_ai_callmate_web_app/screens/setting.dart';
import 'package:seeds_ai_callmate_web_app/widgets/appbar.dart';
// Ensure this is correct
import 'package:seeds_ai_callmate_web_app/widgets/search_bar.dart'; // Ensure this is correct

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(initialPage: 0);
  bool _showText = false;
  int _selectedPageIndex = 0;

  final List<Color> _iconColors = [
    Colors.blue, // Dashboard
    Colors.green, // Allocations
    Colors.orange, // Customers
    Colors.purple, // Followups
    Colors.red, // Call Logs
    Colors.teal, // CRM Fields
    Colors.indigo, // Employees
    Colors.red, // Settings
  ];

  void _toggleDrawer() {
    setState(() {
      _showText = !_showText;
    });
  }

  // void _onMenuItemSelected(int index) {
  //   if (index != _selectedPageIndex) {
  //     // Ensure this only sets state once during the build phase
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       setState(() {
  //         _selectedPageIndex = index;
  //       });
  //       _pageController.jumpToPage(index);
  //       _scaffoldKey.currentState
  //           ?.closeDrawer(); // Close the drawer when an item is selected
  //     });
  //   }
  // }

  void _onMenuItemSelected(int index) {
    if (index != _selectedPageIndex) {
      setState(() {
        _selectedPageIndex = index;
      });
      _pageController.jumpToPage(index);
      _scaffoldKey.currentState
          ?.closeDrawer(); // Close the drawer when an item is selected
    }
    // setState(() {
    //   _selectedPageIndex = index;
    //   _pageController.jumpToPage(index);
    //   _scaffoldKey.currentState
    //       ?.openEndDrawer(); // Close the drawer when an item is selected
    // });
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const TeamAllocation(),
    const CustomersLeds(),
    const Followups(),
    const CallLogs(),
    const CRMFields(),
    const EmployeeScreen(),
    const Setting(),
    const CustomerInteraction()
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0.5, 0.5),
                ),
              ],
            ),
            child: AppBar(
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
                // Flexible(
                //   child: SearchPage(
                //     hintText: 'Search by Name/Phone',
                //     dataList: const ['Flutter', 'React', 'Ionic', 'Xamarin'],
                //     onChanged: (query) {
                //       // Handle search query change
                //       print('Search query: $query');
                //     },
                //   ),
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                if (_selectedPageIndex == 2)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xff2498DF),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Handle add button press

                          _onMenuItemSelected(8);
                        },
                      ),
                    ),
                  ),
                // Only show on CustomersLeds screen
                // CircleAvatar(
                //   radius: 20,

                //   backgroundColor: const Color(0xff2498DF),
                //   child: IconButton(
                //     icon: const Icon(
                //       Icons.add,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {
                //       // Handle add button press
                //       _onMenuItemSelected(8);
                //     },
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Handle notifications button press
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                // const Row(
                //   children: [
                //     Text(
                //       'Raj\ntechnologies',
                //       style: TextStyle(color: Colors.black),
                //     ),
                //     SizedBox(width: 10),
                //     CircleAvatar(
                //       backgroundColor: Color(0xff2498DF),
                //       child: Text(
                //         'R',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //     Icon(Icons.arrow_drop_down, color: Colors.black),
                //   ],
                // ),
                UserProfile()
              ],
            ),
          )),
      body: Row(
        children: [
          _buildSideNavigationBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedPageIndex = index;
                });
              },
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavigationBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: _showText ? 180 : 60,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: <Widget>[
                  _buildDrawerItem(
                    icon: Icons.bar_chart_sharp,
                    text: 'Dashboard',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(0),
                    iconColor: _iconColors[0],
                    color:
                        _selectedPageIndex == 0 ? _iconColors[0] : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.assignment,
                    text: 'Allocations',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(1),
                    iconColor: _iconColors[1],
                    color:
                        _selectedPageIndex == 1 ? _iconColors[1] : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.people,
                    text: 'Customers',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(2),
                    iconColor: _iconColors[2],
                    color:
                        _selectedPageIndex == 2 ? _iconColors[2] : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.follow_the_signs,
                    text: 'Followups',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(3),
                    iconColor: _iconColors[3],
                    color:
                        _selectedPageIndex == 3 ? _iconColors[3] : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.call,
                    text: 'Call Logs',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(4),
                    iconColor: _iconColors[4],
                    color:
                        _selectedPageIndex == 4 ? _iconColors[4] : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.computer_outlined,
                    text: 'CRM Fields',
                    showText: _showText,
                    onTap: () => _onMenuItemSelected(5),
                    iconColor: _iconColors[5],
                    color:
                        _selectedPageIndex == 5 ? _iconColors[5] : Colors.grey,
                  ),

                  // ... (other menu items)
                ],
              ),
            ),
            Divider(
              height: 1.0,
              endIndent: 8,
              indent: 8,
              color: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              icon: Icons.person_pin,
              text: 'Employees',
              showText: _showText,
              onTap: () => _onMenuItemSelected(6),
              iconColor: _iconColors[6],
              color: _selectedPageIndex == 6 ? _iconColors[6] : Colors.grey,
            ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              showText: _showText,
              onTap: () => _onMenuItemSelected(7),
              iconColor: _iconColors[7],
              color: _selectedPageIndex == 7 ? _iconColors[7] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool showText,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _selectedPageIndex == _iconColors.indexOf(iconColor)
                ? color.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 24),
                if (showText)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        text,
                        style: TextStyle(color: color),
                      ),
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
