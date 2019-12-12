import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  static const String routeName = "/reservations";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.list,
                size: 160.0,
                color: Colors.blue,
              ),
              Text(
                "Reservations",
                style: TextStyle(color: Colors.redAccent),
              )
            ],
          ),
        ),
      ),
    );
  }

}