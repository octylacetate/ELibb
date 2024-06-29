import 'package:e_lib/elib_home.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Signup extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final ApiService apiService = ApiService(); // Initialize your apiService here
  final Logger _logger = Logger(); // Initialize the logger

  void _register(BuildContext context) async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Capture NavigatorState and ScaffoldMessengerState before the async call
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await apiService.registerUser(username, email, password);
      _handleRegistrationResult(navigator, scaffoldMessenger, response);
    } catch (error) {
      _logger.e('An error occurred during registration');
      _showErrorSnackBar(scaffoldMessenger, 'An error occurred: $error');
    }
  }

  void _handleRegistrationResult(NavigatorState navigator,
      ScaffoldMessengerState scaffoldMessenger, dynamic response) {
    if (response['statusCode'] == 200) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => ELib(isLoggedIn: true, logout: () async {}),
        ),
      );
    } else {
      _logger.w('Registration failed: ${response['message']}');
      _showErrorSnackBar(
          scaffoldMessenger, 'Registration failed: ${response['message']}');
    }
  }

  void _showErrorSnackBar(
      ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/e.png',
                    height: 70,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Hi!',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Create a new account',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () => _register(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 0, 21, 44),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Color.fromARGB(255, 0, 21, 44), // Text color
                          ),
                          child: Text("Sign In"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
