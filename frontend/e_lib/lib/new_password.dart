import 'package:e_lib/service/apiclassusers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// Adjust the import to your project structure

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final ApiService apiService = ApiService();
  final Logger _logger = Logger();

  Future<void> _changePassword(BuildContext context) async {
    final oldPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await apiService.changeCurrentPassword(oldPassword, newPassword);
      _showSuccessSnackBar(scaffoldMessenger, 'Password changed successfully');
      navigator.pop();
    } catch (error) {
      _logger.e('An error occurred during password change');
      _showErrorSnackBar(
          scaffoldMessenger, 'Failed to change password: $error');
    }
  }

  void _showSuccessSnackBar(
      ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                  SizedBox(height: 20),
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Update your password securely.',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 35),
                  _buildTextField(
                      _currentPasswordController, 'Current Password',
                      obscureText: true),
                  SizedBox(height: 20),
                  _buildTextField(_newPasswordController, 'New Password',
                      obscureText: true),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () => _changePassword(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 0, 21, 44),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 20),
                    ),
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
