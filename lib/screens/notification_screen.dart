import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = "/notifications";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.notifications,
                size: 160.0,
                color: Colors.blue,
              ),
              Text(
                "Notification Screen",
                style: TextStyle(color: Colors.redAccent),
              )
            ],
          ),
        ),
      ),
    );
  }

}