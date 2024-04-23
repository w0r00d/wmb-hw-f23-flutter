import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtistListScreen extends StatefulWidget {
  @override
  _ArtistListScreenState createState() => _ArtistListScreenState();
}

class _ArtistListScreenState extends State<ArtistListScreen> {
  List<dynamic> _artists = [];

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  Future<void> _fetchArtists() async {
    final response = await http.get(
        Uri.parse('https://woroodmadwar.com/mws_wmb_f23_hw/public/api/artists'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _artists = jsonData['data'];
      });
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artist List'),
      ),
      body: _artists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _artists.length,
              itemBuilder: (context, index) {
                final artist = _artists[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      '${artist['fname']} ${artist['lname']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Gender: ${artist['gender'] ?? 'Unknown'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtistDetailScreen(artist: artist),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
class ArtistDetailScreen extends StatelessWidget {
  final dynamic artist;

  ArtistDetailScreen({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artist Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${artist['fname']} ${artist['lname']}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 12.0),
            Text(
              'Gender:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${artist['gender'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 12.0),
            Text(
              'Country:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${artist['country'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
