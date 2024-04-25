import 'package:flutter/material.dart';
import 'package:hw/songs.dart';
import 'SongScreen.dart';
import 'artist.dart';
import 'SearchArtist.dart';
import 'SearchSongs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'InvoicePage.dart';
class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  TextEditingController creditNumber = TextEditingController();
  List<dynamic> songs = [];
  List<bool> _selectedSongs = [];
  double totals = 0;
  @override
  void initState() {
    super.initState();
    fetching();
  }

  fetching() async {
    await _fetchSongs();
  }

  Future<void> _createOrder() async {
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/order';

    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }


  Future<void> _createInvoice() async {
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/invoice';

    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(
          {'customer_id': 3, 'total': totals, 'credit_card': creditNumber.text}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201)
      print('successssssssssssssssss');
    else{
       Map<String, dynamic>  responseData = json.decode(response.body);
                     List< dynamic> errors = responseData['errors'].values.toList();
      print(errors);
      print('errorrrrrrrrrrrrrrrrrrrrrrr');
      }
  }

  Future<void> _fetchSongs() async {
    final response = await http.get(
        Uri.parse('https://woroodmadwar.com/mws_wmb_f23_hw/public/api/songs'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      songs = jsonData['data'];
      setState(() {
        songs = jsonData['data'];
        _selectedSongs = List<bool>.filled(songs.length, false);
        print(songs);
        print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
      });
    } else {
      throw Exception('Failed to load songs');
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (int i = 0; i < songs.length; i++) {
      if (_selectedSongs[i]) {
        // Assuming each song has a 'price' field
        total += double.parse(songs[i]['Price']) ?? 0.0;
      }
    }
    setState(() {
      totals = total;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Songs'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: creditNumber,
                decoration: InputDecoration(
                  labelText: 'Credit Card Number',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return CheckboxListTile(
                      title: Text(song['Title'] ?? ' '),
                      value: _selectedSongs[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedSongs[index] = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              Text(
                'Total Price: \$${getTotalPrice().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async{
                  // Implement payment logic here
                await  _createInvoice();
                },
                child: Text('Pay with card'),
              ),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoicePage(),
                      ));
                },
                child: Text('My Invoices'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
