import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:file_picker/file_picker.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final ApiService apiService = ApiService();
  final Logger _logger = Logger();

  Uint8List? _avatar;
  String? _avatarName;

  void _register(BuildContext context) async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final phoneNumber = _phoneNumberController.text;
    final bio = _bioController.text;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_avatar == null) {
      _showErrorSnackBar(scaffoldMessenger, 'Please select an avatar.');
      return;
    }

    try {
      final response = await apiService.registerUser(username, email, password,
          fullName, phoneNumber, bio, _avatar!, _avatarName!);
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

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _avatar = file.bytes;
        _avatarName = file.name;
      });
      _logger.d('Selected avatar file: ${file.name}');
    }
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
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _avatar != null
                          ? MemoryImage(_avatar!)
                          : AssetImage('assets/images/default-avatar.png')
                              as ImageProvider,
                      child: Icon(Icons.camera_alt, size: 30),
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildTextField(_usernameController, 'Username'),
                  SizedBox(height: 25),
                  _buildTextField(_emailController, 'Email'),
                  SizedBox(height: 25),
                  _buildTextField(_passwordController, 'Password',
                      obscureText: true),
                  SizedBox(height: 25),
                  _buildTextField(_fullNameController, 'Full Name'),
                  SizedBox(height: 25),
                  _buildTextField(_phoneNumberController, 'Phone Number'),
                  SizedBox(height: 25),
                  _buildTextField(_bioController, 'Bio', maxLines: 3),
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

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
