import 'dart:html' as html;
import 'dart:typed_data';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:e_lib/new_password.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final ApiService apiService = ApiService();
  final Logger _logger = Logger();
  Uint8List? _profileImageBytes;
  String? _profileImageName;

  void _register(BuildContext context) async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final phoneNumber = _phoneNumberController.text;
    final bio = _bioController.text;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await apiService.updateAccountDetails(
          username, email, password, fullName, phoneNumber, bio);
      _handleRegistrationResult(navigator, scaffoldMessenger, response);
    } catch (error) {
      _logger.e('An error occurred during registration');
      _showErrorSnackBar(scaffoldMessenger, 'An error occurred: $error');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_profileImageBytes != null && _profileImageName != null) {
      try {
        final response = await apiService.updateUserAvatar(
            _profileImageBytes!, _profileImageName!);
        if (response.statusCode == 200) {
          _logger.i('Profile picture updated successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture updated successfully')),
          );
        } else {
          _logger.e('Failed to update profile picture');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture')),
          );
        }
      } catch (error) {
        _logger.e('Failed to update profile picture: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $error')),
        );
      }
    } else {
      _logger.e('Profile image bytes or name is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No profile image selected')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files!.isEmpty) return;
        final file = files.first;
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            _profileImageBytes = reader.result as Uint8List?;
            _profileImageName = file.name;
          });
        });

        reader.readAsArrayBuffer(file);
      });
    } catch (e) {
      _logger.e('An error occurred while picking the image: $e');
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

  List screens = [
    ELib(isLoggedIn: true, logout: () async {}),
    ELib(isLoggedIn: true, logout: () async {}),
    Booksall(isLoggedIn: true, logout: () async {}),
    Profile(isLoggedIn: true, logout: () async {})
  ];
  int selectedIndex = 3;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

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
                  SizedBox(height: 20),
                  Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Bring life to your account.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 35),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImageBytes != null
                          ? MemoryImage(_profileImageBytes!)
                          : AssetImage('assets/images/default-avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateProfilePicture,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 0, 21, 44),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Update Profile Picture",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_fullNameController, 'Full Name'),
                  SizedBox(height: 20),
                  _buildTextField(_usernameController, 'Username'),
                  SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email'),
                  SizedBox(height: 20),
                  _buildTextField(_passwordController, 'Password',
                      obscureText: true),
                  SizedBox(height: 20),
                  _buildTextField(_phoneNumberController, 'Phone Number'),
                  SizedBox(height: 20),
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
                      "Confirm",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Want to change password? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordScreen()));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Color.fromARGB(255, 0, 21, 44), // Text color
                          ),
                          child: Text("Change Password")),
                      SizedBox(height: 85),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() => selectedIndex = 3);
          },
          child:
              const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          backgroundColor: Color.fromARGB(255, 100, 204, 199),
          //params
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          activeIndex: selectedIndex,
          itemCount: icons.length,
          tabBuilder: (int index, bool isActive) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => screens[selectedIndex]));
                setState(() => selectedIndex = index);
              },
              child: Icon(
                icons[index],
                size: 24,
                color: isActive
                    ? Colors.amberAccent
                    : Color.fromARGB(255, 100, 204, 199),
              ),
            );
          },
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 8,
          rightCornerRadius: 8,
          backgroundColor: Color.fromARGB(255, 17, 106, 136),
          onTap: (index) => setState(() => selectedIndex = index),
          //other params
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
