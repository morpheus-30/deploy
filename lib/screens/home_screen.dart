import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final double _appBarHeight = 80.0;
  // late final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(_appBarHeight),
      //   child: const ResponsiveAppBar(),
      // ),
      body:

          // const Center(child: Text("Content here")),
          // drawer:
          SideNavigationBar(),
    );
  }
}
