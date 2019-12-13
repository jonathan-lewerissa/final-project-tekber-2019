import 'package:intl/intl.dart';

class Reservation {
  String nama = '';
  String telepon = '';
  String email = '';
  String nama_kegiatan = '';
  DateTime tanggal_kegiatan;
  DateTime waktu_mulai;
  DateTime waktu_selesai;
  String badan_pelaksana_kegiatan;
  int kali_peminjaman;
  int rutinitas = 1;
  String ruangan = 'LP2';

  @override
  String toString() {
    return 'Reservation{nama: $nama, telepon: $telepon, email: $email, nama_kegiatan: $nama_kegiatan, tanggal_kegiatan: $tanggal_kegiatan, waktu_mulai: $waktu_mulai, waktu_selesai: $waktu_selesai, badan_pelaksana_kegiatan: $badan_pelaksana_kegiatan, kali_peminjaman: $kali_peminjaman}';
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'telp': telepon,
    'email': email,
    'keg': nama_kegiatan,
    'tglmulai': DateFormat('yyyy-MM-dd').format(tanggal_kegiatan),
    'wktmulai': DateFormat('HH:mm:ss').format(waktu_mulai),
    'wktselesai': DateFormat('HH:mm:ss').format(waktu_selesai),
    'badan': badan_pelaksana_kegiatan,
    'ruang': ruangan,
    'rutin': rutinitas.toString(),
    'kali': kali_peminjaman.toString(),
  };
}