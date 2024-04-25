import 'package:flutter/material.dart';
import 'package:hw/homepage.dart';
import 'songs.dart';
import 'signup.dart';
import 'Customers.dart';
import 'dart:convert';
import 'artist.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginRoute extends StatelessWidget {
  LoginRoute({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// Save token
  Future<void> saveToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    
  }
  //save is_admin
    Future<void> saveAdminStat( int is_admin) async {
    final storage = FlutterSecureStorage();
    
    await storage.write(key: 'is_admin', value: is_admin.toString());
  }

  login() async {
    print('loggin in................');
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/login';

    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('--------------------------------------------');
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return {'token': jsonData['token'],
       'is_admin': jsonData['is_admin']};
    } else {
      var jsonData = jsonDecode(response.body);
      return {'error': jsonData['message']};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          textScaler: TextScaler.linear(2),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Sign in to your account'),
              SizedBox(height: 50),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Perform login functionality here
                  String username = usernameController.text;
                  String password = passwordController.text;

                  var result = await login();
                  if (result['error'] != null) {
                    print('wrong creds');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wrong Credentials. Please try again.'),
                        duration:
                            Duration(seconds: 2), // Adjust duration as needed
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    print('Token: ${result['token']}');
                    saveToken(result['token']);
                    saveAdminStat(result['is_admin']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //    builder: (context) => SongsRoute(),
                        builder: (context) => homepage(),
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupRoute(),
                          //   builder: (context) => ArtistListScreen(),
                        ));
                  },
                  child: Text('do not have an account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
