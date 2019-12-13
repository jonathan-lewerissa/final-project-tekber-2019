import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  static const String routeName = "/reservations";

  @override
  State<StatefulWidget> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<dynamic> _events;
  bool checkAdmin = false;

  @override
  Widget build(BuildContext context) {
    if (_events == null) {
      return Scaffold(
        body: Center(
          child: Text('Loading...'),
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          children: _events
              .map((item) => new Card(
                    child: ListTile(
                      title: Text(item['nama_kegiatan']),
                      subtitle: Text(item['tanggal_masuk_permohonan'] +
                          ' ' +
                          item['waktu_mulai_permohonan_peminjaman'] +
                          ' - ' +
                          item['waktu_selesai_permohonan_peminjaman']),
                      leading: item['status_permohonan'] == 'Disetujui'
                          ? Icon(Icons.check_circle)
                          : Icon(Icons.blur_circular),
                      onLongPress: () async {
                        if (checkAdmin) {
                          var response = await http.post(
                              'http://10.151.253.50/api/accPinjam',
                              body: {
                                'kode_permohonan': item['kode_permohonan']
                              });
                          if(response.statusCode != 200) {
                            print('ERROR!!');
                          }
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();

    Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        checkAdmin = ds.data['admin'] ?? false;
        print(ds.data['admin']);
      });
    });

    final response =
        await http.get('http://10.151.253.50/reservasi-pengguna/' + user.email);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);
      setState(() {
        _events = res['permohonan'];
      });
    }
  }
}
