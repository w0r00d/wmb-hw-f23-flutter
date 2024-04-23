import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
// Retrieve token
Future<String?> getToken() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'token');
}
/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SongListScreen(),
    );
  }
}*/

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<dynamic> _songs = [];

  @override
  void initState() async{
    final tok = await getToken();
    print('tooooooken');
    print(tok);
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    final response = await http.get(
        Uri.parse('https://woroodmadwar.com/mws_wmb_f23_hw/public/api/songs'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _songs = jsonData['data'];
      });
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song List'),
      ),
      body: _songs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      song['Title'] ?? 'Unknown Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Artist: ${song['artist'] != null ? '${song['artist']['fname']} ${song['artist']['lname']}' : 'Unknown'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                     // final tok = await getToken();
                   //   print(tok);
                     // print('tooooooooooooooooo00000000ken');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongDetailScreen(song: song),
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
class SongDetailScreen extends StatelessWidget {
  final dynamic song;

  SongDetailScreen({required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Detail'),
      ),
      body: song != null
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['Title'] ?? 'Unknown Title',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Type:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song['Type'] ?? 'Unknown Type',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Price:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${song['Price'] ?? 'Unknown Price'}',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Artist:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song['artist'] != null
                        ? '${song['artist']['fname']} ${song['artist']['lname']}'
                        : 'Unknown Artist',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('Song details not available'),
            ),
    );
  }
}
