import 'package:flutter/material.dart';
import 'package:hw/artist.dart';
import 'login.dart';
import 'add_songs.dart';
import 'SearchArtist.dart';
import 'purchase.dart';
import 'homepage.dart';
void main() {
  runApp( MaterialApp(
    //home: AddSongs(),
   home: LoginRoute(),
 //  home: ArtistListScreen(),
    //home: PurchasePage()
 //home: homepage()
  ));
}
