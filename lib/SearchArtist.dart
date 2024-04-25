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
    List<Artist> artists = [];
  List<dynamic> _resArtists = [];
  List<Artist> fetchedArtists = [];
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
    
  
    artists = _artists.map((json)=>Artist.fromJson(json)).toList() ;
          print(artists);
          for(var a in artists){
            print(a.songs);
          }
    } else {
      throw Exception('Failed to load artists');
    }
  }

  List<dynamic> _searchArtists() {
   
    print('=========================');

  


    List<dynamic> res = artists.where((artist){
      final artistFName = artist.lname.toString().toLowerCase();
      final artistLName = artist.fname.toString().toLowerCase();
      return artistLName.contains( _searchController.text.toLowerCase())||artistFName.contains( _searchController.text.toLowerCase()) ;
    }).toList();

    setState(() {
      _resArtists = res;
      
    });

print(_resArtists);
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
           
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchArtists();
            },
            child: Text('search'),
          ),
          Expanded(
            child: _resArtists.isNotEmpty
                ? ListView.builder(
                    itemCount: _resArtists.length,
                    itemBuilder: (context, index) {
                      Artist artist = _resArtists[index];
                      return ListTile(
                        title: Text('Artist Name: '+artist.fname+' '+artist.lname)
                        ,subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[ 
                            Text(artist.songs!.join(('\n')))
                          ],),
                      );
                    })
                : Text('no results'),
          ),
        ],
      ),
    );
  }
}
