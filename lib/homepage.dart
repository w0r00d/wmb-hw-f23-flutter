import 'package:flutter/material.dart';
import 'package:hw/songs.dart';
import 'SongScreen.dart';
import 'artist.dart';
import 'SearchArtist.dart';
import 'SearchSongs.dart';

class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongListScreen(),
                      ));
                },
                child: Text('View Songs'),
              ),
              SizedBox(height:20),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistListScreen(),
                      ));
                },
                child: Text('View Artists'),
              ),
              SizedBox(height:20),  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchArtist(),
                      ));
                },
                child: Text('View Songs'),
              ),
              SizedBox(height:20),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongSearchPage(),
                      ));
                },
                child: Text('View Songs'),
              ),
              SizedBox(height:20),

            ],
          ),
        ),
      ),
    );
  }
}
