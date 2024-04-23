import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class customers extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<customers> {
  List Custs = [];

  Future getCustomers() async {
    // String uri = "http://127.0.0.1:8000/api/customers";
    //String uri = "https://jsonplaceholder.typicode.com/posts";
    String uri = "https://vertexoffice.net/public/api/customers";
    var response = await http.get(Uri.parse(uri));
    var rjson = jsonDecode(response.body);
    // print(rjson);
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    // setState(() {
    //   Custs.addAll(rjson['data']);
    // });

    return rjson['data'];
  }
Future<void> addCustomer() async {
  String uri = "https://vertexoffice.net/public/api/customers";
  print('adding customer!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  var res = await http.post(
    Uri.parse(uri),
    body: {
      'username': 'woroodsm3399999',
      'fname': 'worood',
      'lname': 'mad',
      'address': 'homs',
      'email': 'worood50999@email.com',
      'password': '123',
    },
    // headers: {
    //   'content-type': 'application/json; charset=UTF-8',
    // },
  );
print('Response status: ${res.statusCode}');
print('--------------------------');
  print('Response body: ${res.body}');
  
  if (res.statusCode == 200) {
    // If the server returns a 200 OK response, update the UI to reflect the addition
    // For example, you could call setState to rebuild the UI with the new data
    setState(() {
      // Add the new customer to the list
       Custs.add(jsonDecode(res.body)['data']);
      // Assuming you want to refresh the list of customers after adding a new one
      getCustomers();
    });
  } else {
    // If the server returns an error response, print the error
    print('Failed to add customer: ${res.statusCode}');
  }
}

  // @override
  // void initState() {
  //    getCustomers();
  //    super.initState();
  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              addCustomer();
            },
            child: Text('add customer'),
          ),
         FutureBuilder(
  future: getCustomers(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      print('Data found');
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, i) {
          return Text("${snapshot.data[i]}");
        },
      );
    }
  },
),

        ],
      ),
    );
  }
}
