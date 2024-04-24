class Artist{
  final int id;
  final String fname;
  final String lname;
  final String gender;
  final String country;

Artist({required this.id,required this.fname, required this.lname, required this.gender, required this.country});


factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as int,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      country: json['country'] as String,
      gender: json['gender'] as String,
    );
  }
}