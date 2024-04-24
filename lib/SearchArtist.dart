import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Artist.dart';
import 'models/Song.dart';
class SearchArtist extends StatefulWidget {
  @override
  _SearchArtistState createState() => _SearchArtistState();
}

class _SearchArtistState extends State<SearchArtist> {
  List<dynamic> _artists = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  Future<void> _fetchArtists() async {
    final response = await http.get(Uri.parse(
        'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/artists'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _artists = jsonData['data'];
      });
      print('=================================');
      print(_artists);
    } else {
      throw Exception('Failed to load artists');
    }
  }

  List<dynamic> _searchArtists() {
    print(_artists.length);
    print('=========================');
    List res = _artists.where((artist) {
      final artistFName = artist['fname'].toString().toLowerCase();
      final artistLName = artist['lname'].toString().toLowerCase();
      return artistLName.contains( _searchController.text.toLowerCase())||artistFName.contains( _searchController.text.toLowerCase()) ;
    }).toList();
setState(() {
  _artists = res;
});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Artist'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Artist',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchArtists();
            },
            child: Text('search'),
          ),
          Expanded(
            child: _artists.isNotEmpty
                ? ListView.builder(
                    itemCount: _artists.length,
                    itemBuilder: (context, index) {
                      Artist artist = _artists[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text('_',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Artist: ${'${artist.fname} ${artist.lname}'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      
                        ),
                      );
                    })
                : Text('no results'),
          ),
        ],
      ),
    );
  }
}
