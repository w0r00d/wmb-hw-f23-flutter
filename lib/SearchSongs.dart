import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Song.dart';
import 'SongDetailsScreen.dart';
import 'SongScreen.dart';
class SongSearchPage extends StatefulWidget {
  @override
  _SongSearchPageState createState() => _SongSearchPageState();
}

class _SongSearchPageState extends State<SongSearchPage> {
  String? _searchQuery;
  List<dynamic> _songs = [];
  TextEditingController SearchTermController = TextEditingController();
  List<Song> songs = [];
  List<Song> resSongs = [];


  @override
  void initState() {
    getSongs();
    super.initState();
  }

  getSongs() async {
    await _fetchSongs();
  }
  Future<void> _fetchSongs() async {
   
    final response = await http.get(
        Uri.parse('https://woroodmadwar.com/mws_wmb_f23_hw/public/api/songs'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _songs = jsonData['data'];
      });
      _songs = jsonData['data'];
 

      songs = _songs.map((json) => Song.fromJson(json)).toList();
  //print(' songs');
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Search() {
     var res = songs
        .where((song) => song.title
            .toLowerCase()
            .contains(SearchTermController.text.toLowerCase()))
        .toList();

    setState(() {
      if(res.length >0)
      resSongs = res;
      else
    {  resSongs = [];}
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              controller: SearchTermController,
              decoration: InputDecoration(
                labelText: 'Search by Title',
                hintText: 'Enter part of the song title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Search();
            },
            child: Text('Search'),
          ),
          Expanded(
            child: resSongs.isNotEmpty
                ? ListView.builder(
                    itemCount: resSongs.length,
                    itemBuilder: (context, index) {
                      Song song = resSongs[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            song.title ?? 'Unknown Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: song.artist != null ? Text(
                            'Artist: ${ '${song.artist?.fname} ${song.artist?.lname}'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ) : 
                          Text(''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SongScreen(song: song),
                              ),
                            );
                          },
                        ),
                      );
                    })
                : Text('no results'),
          )
        ],
      ),
    );
  }
}

class SongDetailPage extends StatelessWidget {
   Song song;

  SongDetailPage({required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Detail'),
      ),
      body: Center(
        child: Text(
          song.title,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
