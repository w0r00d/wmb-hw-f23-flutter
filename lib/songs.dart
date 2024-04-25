import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hw/artist.dart';
import 'add_songs.dart';
import 'login.dart';
import 'SongDetailsScreen.dart';
import 'SearchSongs.dart';

Future<String?> getToken() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'token');
}

Future<String?> getAdminStat() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'is_admin');
}

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<dynamic> _songs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetchSongs();
  }

  Future<void> _checkTokenAndFetchSongs() async {
    setState(() {
      _isLoading = true;
    });

    final token = await getToken();
    final is_admin = await getAdminStat();
    if (token != null) {
      await _fetchSongs();
    }

    setState(() {
      _isLoading = false;
    });
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _songs.isEmpty
              ? _buildTokenNotFoundMessage(context)
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongSearchPage(),
                              ),
                            );
                          },
                          child: Text('Search for song'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtistListScreen(),
                                  ),
                                );
                              },
                              child: Text('Go to Artists'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSongs(),
                                  ),
                                );
                              },
                              child: Text('Add Song'),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            itemCount: _songs.length,
                            itemBuilder: (context, index) {
                              final song = _songs[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                elevation: 4.0,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  title: Text(
                                    song['Title'] ?? 'Unknown Title',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Artist: ${song['artist'] != null ? '${song['artist']['fname']} ${song['artist']['lname']}' : 'Unknown'}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SongDetailScreen(song: song),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTokenNotFoundMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are not authenticated.',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginRoute(),
                  ));
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
