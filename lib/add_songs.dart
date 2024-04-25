import 'package:flutter/material.dart';
import 'package:hw/songs.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddSongs extends StatefulWidget {
  @override
  _AddSongs_state createState() => _AddSongs_state();
}

class _AddSongs_state extends State<AddSongs> {
   bool is_admin = false;
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController songTypeController = TextEditingController();
  final TextEditingController songPriceController = TextEditingController();
  String errorMessage = '';
  int? _selectedId;
  List<dynamic> _artists = [];

  @override
  void initState() {
    fetching();
        errorMessage = '';
    super.initState();
  }

  Future fetching() async {
    await _fetchArtists();
    
     String? is_admin_st = await getAdminStat();
     if(is_admin_st=='1')
      is_admin =true;
     else 
     is_admin = false;
  }
  Future<String?> getAdminStat() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'is_admin');
}

  Future _AddSong() async {
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/songs';
    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        'title': songNameController.text,
        'type': songTypeController.text,
        'price': songPriceController.text,
        'ArtistId': _selectedId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  Future<void> _fetchArtists() async {
    final response = await http.get(Uri.parse(
        'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/artists'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        print('feeeeeeeeeeeetched');
        _artists = jsonData['data'];
        print(_artists);
        print(_artists.isEmpty);
        print('before building');
      });
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding Songs'),
      ),
      body: is_admin ? Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Create New Song'),
                SizedBox(height: 50),
                TextField(
                  controller: songNameController,
                  decoration: InputDecoration(
                    labelText: 'Song Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: songTypeController,
                  decoration: InputDecoration(
                    labelText: 'Song Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: songPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Song Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('Choose Artist Name'),
                    SizedBox(width: 60),
                    DropdownButton<int>(
                      value: _selectedId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedId = newValue; // Update the selected ID
                        });
                      },
                      items: _artists.map<DropdownMenuItem<int>>((option) {
                        return DropdownMenuItem<int>(
                          value: option['id'], // Assign the ID as value
                          child: Text(option['fname']), // Display the name
                        );
                      }).toList(),
                      hint: Text('Select an option'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var response = await _AddSong();
                 
                    if (response.statusCode == 201) {
                      setState(() {
                        errorMessage = '';
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongListScreen(),
                          ));
                    } else if (response.statusCode == 400) {
                      Map<String, dynamic> responseData =
                          json.decode(response.body);
                      List<dynamic> errors =
                          responseData['errors'].values.toList();

                      setState(() {
                        errorMessage = 'Errors in input\n' +
                            errors.join('\n').replaceAll(RegExp(r'[\[\]]'), '');
                        ;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error Occurred. Please try again.'),
                          duration:
                              Duration(seconds: 2), // Adjust duration as needed
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("Add Song"),
                ),
                Center(
                  child: Text(errorMessage),
                ),
              ],
            ),
          ),
        ),
      ): 
      Text('Not An Admin. You Are not Allowed to add songs'),
    );
  }
}
