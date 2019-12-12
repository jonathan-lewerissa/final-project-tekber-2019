import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reservasi_app/screens/login_screen.dart';
import 'package:reservasi_app/screens/notification_screen.dart';
import 'package:reservasi_app/screens/reservations_screen.dart';
import 'package:reservasi_app/screens/schedule_screen.dart';
import 'package:reservasi_app/screens/setting_screen.dart';

import '../signin.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/";
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  initUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      user = currentUser;
    });
  }

  Drawer getNavDrawer(BuildContext context) {
    var headerChild = UserAccountsDrawerHeader(
      accountName: Text(user?.displayName ?? 'Login to continue'),
      accountEmail: Text(user?.email ?? ''),
    );

    var aboutChild = AboutListTile(
      child: Text("About"),
      applicationName: "Application Name",
      applicationVersion: "v1.0.0",
      applicationIcon: Icon(Icons.adb),
      icon: Icon(Icons.info),
    );

    ListTile getNavItem(IconData icon, String s, String routeName) {
      return ListTile(
        leading: Icon(icon),
        title: Text(s),
        onTap: () {
          setState(() {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(routeName);
          });
        },
      );
    }

    var myNavChildren = [
      headerChild,
      getNavItem(Icons.settings, "Settings", SettingScreen.routeName),
      getNavItem(Icons.person, "Login", LoginScreen.routeName),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () async {
          await signOutGoogle();
          setState(() {
            user = null;
          });
        },
      ),
      aboutChild
    ];

    ListView listView = ListView(children: myNavChildren);

    return Drawer(
      child: listView,
    );
  }

  TabController controller;

  @override
  void initState() {
    super.initState();
    initUser();

    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).pushNamed(NotificationScreen.routeName);
              })
        ],
      ),
      body: TabBarView(
        children: <Widget>[ScheduleScreen(), ReservationScreen()],
        controller: controller,
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.calendar_today),
            ),
            Tab(
              icon: Icon(Icons.view_list),
            ),
          ],
          controller: controller,
        ),
      ),
      drawer: getNavDrawer(context),
    );
  }
}
