import 'package:flutter/material.dart';
import 'songs.dart';
import 'signup.dart';

class LoginRoute extends StatelessWidget {
  LoginRoute({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page', textScaler: TextScaler.linear(2),),
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
                onPressed: () {
                  // Perform login functionality here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  print('Username: $username\nPassword: $password');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongsRoute(),
                      ));
                },
                child: Text('Login'),
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
          ),
        ),
      ),
    );
  }
}
