import 'Song.dart';
class Artist{
  final int id;
  final String fname;
  final String lname;
  final String gender;
  final String country;
  final   List<dynamic>? songs;

Artist({required this.id,required this.fname, required this.lname, required this.gender, required this.country, this.songs});


factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as int,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      country: json['country'] as String,
      gender: json['gender'] as String,
      songs: json['songs'] as List<dynamic>
    );
  }
}