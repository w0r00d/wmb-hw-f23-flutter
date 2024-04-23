import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignupRoute extends StatelessWidget {
  SignupRoute({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Create New Account'),
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
              TextField(
                controller: fnameController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
               SizedBox(height: 20),
              TextField(
                controller: lnameController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
               SizedBox(height: 20),
              TextField(
                controller: addressController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform login functionality here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  print('Username: $username\nPassword: $password');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginRoute(),
                      ));
                },
                child: Text('Create Account'),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupRoute(),
                        ));
                  },
                  child: Text('do not have an account'),
                ),
              )
            ],
          ),),
        ),
      ),
    );
  }
}
