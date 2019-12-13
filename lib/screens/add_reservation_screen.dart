import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:reservasi_app/models/reservation.dart';
import 'package:http/http.dart' as http;
import 'package:reservasi_app/screens/home_screen.dart';

class AddReservationScreen extends StatefulWidget {
  static const String routeName = "/add-reservation";

  @override
  State<StatefulWidget> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  int currentStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static Reservation reservation = new Reservation();

  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    setUser();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  void setUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setInitialForm(user);
  }

  void setInitialForm(FirebaseUser user) {
    reservation.email = user.email;
    reservation.nama = user.displayName;
  }

  List<Step> mySteps = [
    Step(
      title: Text("Contact info"),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextField(
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            autocorrect: false,
            onChanged: (String value) {
              reservation.telepon = value;
              print(reservation.toString());
            },
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: 'Enter your phone number',
              hintText: 'Phone number',
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onChanged: (String value) {
              reservation.badan_pelaksana_kegiatan = value;
              print(reservation.toString());
            },
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: 'Enter your delegation',
              hintText: 'Delegation',
            ),
          )
        ],
      ),
    ),
    Step(
      title: Text("What's the event?"),
      isActive: true,
      content: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onChanged: (String value) {
              reservation.nama_kegiatan = value;
              print(reservation.toString());
            },
            decoration: InputDecoration(
              labelText: 'Enter event name',
              hintText: 'Event name',
            ),
          ),
          DateTimeField(
            format: DateFormat('yyyy-MM-dd'),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
            },
            onChanged: (date) {
              reservation.tanggal_kegiatan = date;
              print(reservation.toString());
            },
            decoration: InputDecoration(labelText: 'Event date'),
          ),
          DateTimeField(
            format: DateFormat('HH:mm'),
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
              return DateTimeField.convert(time);
            },
            onChanged: (date) {
              reservation.waktu_mulai = date;
              print(reservation.toString());
            },
            decoration: InputDecoration(
              labelText: 'Event Start',
            ),
          ),
          DateTimeField(
            format: DateFormat('HH:mm'),
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                      currentValue ?? DateTime.now().add(Duration(hours: 2))));
              return DateTimeField.convert(time);
            },
            onChanged: (date) {
              reservation.waktu_selesai = date;
              print(reservation.toString());
            },
            decoration: InputDecoration(
              labelText: 'Event end',
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            autocorrect: false,
            onChanged: (String value) {
              reservation.kali_peminjaman = int.parse(value);
              print(reservation.toString());
            },
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: 'How many times?',
              hintText: 'How many times?',
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Reservation"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
                child: Column(
                  children: <Widget>[
                    Stepper(
                      currentStep: this.currentStep,
                      steps: mySteps,
                      type: StepperType.vertical,
                      onStepTapped: (step) {
                        setState(() {
                          currentStep = step;
                        });
                        print("onStepTapped : " + step.toString());
                      },
                      onStepCancel: () {
                        setState(() {
                          if (currentStep > 0) {
                            currentStep = currentStep - 1;
                          } else {
                            currentStep = 0;
                          }
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (currentStep < mySteps.length - 1) {
                            currentStep = currentStep + 1;
                          } else {
                            currentStep = 0;
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            print(reservation.toJson().toString());
                            var response = await http.post('http://10.151.253.50/api/isiPinjam', body: reservation.toJson());
                            print(response.statusCode);
                            Map<String, dynamic> res = jsonDecode(response.body);
                            if(res['status'] == 'acknowledged') {
                              Navigator.of(context).pushNamed(HomeScreen.routeName);
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(res['status']),
                              ));
                            }
                          }
                        },
                        child: Text('Submit'),
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      )
    );
  }
}
