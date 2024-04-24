import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupRoute extends StatefulWidget {
  SignupRoute({Key? key}) : super(key: key);
  @override
  _SignupRoute_state createState() => _SignupRoute_state();
}

class _SignupRoute_state extends State<SignupRoute> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    errorMessage = '';
  }

  Future createCustomer() async {
    String uri = 'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/customers';
    var response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
        'lname': lnameController.text,
        'fname': fnameController.text,
        'address': addressController.text,
        'email': emailController.text
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

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
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Perform signup functionality here

                    var response = await createCustomer();
                    
                    if (response.statusCode == 200) {
                      setState(() {
                        errorMessage = '';
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginRoute(),
                          ));
                    } else if (response.statusCode == 400) {
                     Map<String, dynamic>  responseData = json.decode(response.body);
                     List< dynamic> errors = responseData['errors'].values.toList();
                     
                      setState(() {
                        
                     errorMessage = 'Errors in input\n'+errors.join('\n').replaceAll(RegExp(r'[\[\]]'), '');;
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
                  child: Text('Create Account'),
                ),
                Center(
                  child: Text(errorMessage),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        errorMessage = '';
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginRoute(),
                          ));
                    },
                    child: Text('already have an account'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
