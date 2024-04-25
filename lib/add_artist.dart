import 'package:flutter/material.dart';
import 'package:hw/artist.dart';
import 'package:hw/songs.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> getAdminStat() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'is_admin');
}

class AddArtist extends StatefulWidget {
  _AddArtistState createState() => _AddArtistState();
}

class _AddArtistState extends State<AddArtist> {
  bool is_admin = true;

  final TextEditingController artistFirstNameController =
      TextEditingController();
  final TextEditingController artistLastNameController =
      TextEditingController();
  String errorMessage = '';
  String? _selectedGender = '';

  final TextEditingController artistCountryController = TextEditingController();

  void initState() {
    _checkTokenAndAdmin();
    super.initState();
  }

  Future _AddArtist() async {
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/artists';
    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        'fname': artistFirstNameController.text,
        'lname': artistLastNameController.text,
        'gender': _selectedGender,
        'country': artistCountryController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('reeeeeeeeeeeeeeeeeeee');
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future _checkTokenAndAdmin() async {
    String? is_admin_st = await getAdminStat();
    if (is_admin_st == '1')
      is_admin = true;
    else
      is_admin = true;

    print(is_admin.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adding Artist')),
      body: is_admin
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Add Artist'),
                      SizedBox(height: 20),
                      TextField(
                        controller: artistFirstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: artistLastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      RadioListTile<String>(
                        title: Text('Male'),
                        value: 'male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Female'),
                        value: 'female',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: artistCountryController,
                        decoration: InputDecoration(
                          labelText: 'Counter',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          var response = await _AddArtist();

                          if (response.statusCode == 201) {
                            setState(() {
                              errorMessage = '';
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtistListScreen(),
                                ));
                          } else if (response.statusCode == 400) {
                            Map<String, dynamic> responseData =
                                json.decode(response.body);
                            List<dynamic> errors =
                                responseData['errors'].values.toList();

                            setState(() {
                              errorMessage = 'Errors in input\n' +
                                  errors
                                      .join('\n')
                                      .replaceAll(RegExp(r'[\[\]]'), '');
                              ;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error Occurred. Please try again.'),
                                duration: Duration(
                                    seconds: 2), // Adjust duration as needed
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text('Add Artist'),
                      ),
                      Text(errorMessage)
                    ],
                  ),
                ),
              ),
            )
          : Text('Not An Admin. You Are not Allowed to add artists'),
    );
  }
}
