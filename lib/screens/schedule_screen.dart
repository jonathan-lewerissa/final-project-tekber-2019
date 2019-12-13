import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  static const String routeName = "/schedule";

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = new Map<DateTime, List>();
    _fetchData(_selectedDay);

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animationController.forward();
  }

  _fetchData(DateTime day) async {
    final response = await http.get('http://10.151.253.50/reservasi/LP2/' + day.toString());
    if(response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> res = jsonDecode(response.body);

      List<dynamic> kegiatan = res['kegiatan'];

      setState(() {
        _events.clear();
        for(var i = 0; i < kegiatan.length; i++) {
          if(!_events.containsKey(DateTime.parse(kegiatan[i]['tanggal']))) {
            _events[DateTime.parse(kegiatan[i]['tanggal'])] = [kegiatan[i]];
          } else {
            _events[DateTime.parse(kegiatan[i]['tanggal'])].add(kegiatan[i]);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print("CALLBACK: _onVisibleDaysChanged");
    _fetchData(first);
    _selectedEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(),
              const SizedBox(height: 8.0),
//              _buildButtons(),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
//        selectedColor: Colors.deepOrange[400],
//        todayColor: Colors.deepOrange[200],
//        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      availableCalendarFormats: {
        CalendarFormat.month: 'Month'
      },
//      headerStyle: HeaderStyle(
//        formatButtonTextStyle:
//            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.deepOrange[400],
//          borderRadius: BorderRadius.circular(16.0),
//        ),
//      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length -1 );

    return Column(
      children: <Widget>[
//        Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            RaisedButton(
//              child: Text('Month'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.month);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('2 Weeks'),
//              onPressed: () {
//                setState(() {
//                  _calendarController
//                      .setCalendarFormat(CalendarFormat.twoWeeks);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('Week'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.week);
//                });
//              },
//            ),
//          ],
//        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(DateTime(dateTime.year, dateTime.month, dateTime.day),runCallback: true);
          },
        )
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map((event) => Container(
        decoration: BoxDecoration(border: Border.all(width: 0.8), borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event['nama_kegiatan']),
          subtitle: Text(event['waktu_mulai'] + ' - ' + event['waktu_selesai']),
          onTap: () => print('${event.toString()} tapped!'),
        ),
      )).toList(),
    );
  }
}
