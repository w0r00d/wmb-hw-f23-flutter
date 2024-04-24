import 'package:flutter/material.dart';
import 'models/Song.dart';



class SongScreen extends StatelessWidget {
  Song song;

  SongScreen({required this.song});

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
                    song.title ?? 'Unknown Title',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Type:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song.type?? 'Unknown Type',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Price:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${song.price?? 'Unknown Price'}',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Artist:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song.artist != null
                        ? '${song.artist.fname} ${song.artist.lname}'
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
