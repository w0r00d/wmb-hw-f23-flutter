import 'Artist.dart';

class Song{
  final int id;
  final String title;
  final String type;
  final String price;
  final int artist_id; 
  final Artist artist;


Song({required this.id, required this.title, required this.type, required this.price, required this.artist_id,required this.artist});

 factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as int,
      title: json['Title'] as String,
      type: json['Type'] as String,
      price: json['Price'] as String,
      artist_id: json['ArtistId'] as int,
      artist: Artist.fromJson(json['artist']),
    );
  }
}