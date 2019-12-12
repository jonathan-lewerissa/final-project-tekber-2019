import 'package:flutter/material.dart';
import 'package:reservasi_app/screens/login_screen.dart';
import 'package:reservasi_app/screens/notification_screen.dart';
import 'package:reservasi_app/screens/reservations_screen.dart';
import 'package:reservasi_app/screens/schedule_screen.dart';
import 'package:reservasi_app/screens/setting_screen.dart';

final routes = <String, WidgetBuilder> {
  ScheduleScreen.routeName: (BuildContext context) => ScheduleScreen(),
  ReservationScreen.routeName: (BuildContext context) => ReservationScreen(),
  SettingScreen.routeName: (BuildContext context) => SettingScreen(),
  NotificationScreen.routeName: (BuildContext context) => NotificationScreen(),
  LoginScreen.routeName: (BuildContext context) => LoginScreen(),
};