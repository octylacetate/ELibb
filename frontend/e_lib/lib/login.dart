import 'package:e_lib/elib_home.dart';
import 'package:e_lib/route_persistence.dart';
import 'package:e_lib/signup.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RoutePersistence routePersistence = RoutePersistence();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService apiService = ApiService();

  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await apiService.loginUser(email, password);
      if (response['statusCode'] == 200) {
        // Login successful
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ELib(isLoggedIn: true, logout: () async {}),
          ),
        );
      } else {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response['message']}')),
        );
      }
    } catch (error) {
      // Handle exceptions here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {});
    _passwordController.addListener(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    routePersistence.saveLastRoute('/login');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
                alignment: Alignment(
                    1.0, -1.2), // Adjust alignment to position vertically
                child: Container(
                  width: 300,
                  height: 300,
                  child: Lottie.asset(
                    "assets/images/lotie7.json",
                    // reverse: true,
                  ),
                )),
            Align(
                alignment: Alignment(
                    -1.0, 3.8), // Adjust alignment to position vertically
                child: Container(
                  width: 600,
                  height: 600,
                  child: Lottie.asset(
                    "assets/images/lotie6.json",
                    reverse: true,
                  ),
                )),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 200.0),
                      child: Image.asset(
                        'assets/images/elib.png',
                        height: 200,
                      ),
                    ),
                    Text(
                      'Welcome!',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text('Sign in to continue'),
                    SizedBox(height: 20),
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
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        obscureText: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Signup()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 108, 182, 243),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => {_login(context), context.go('/home')},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 0, 21, 44),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('or '),
                    SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          )
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 0, 21, 44),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/file.png', // Path to your image asset
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            Text('Continue with google'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Signup()),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Color.fromARGB(255, 0, 21, 44), // Text color
                            ),
                            child: Text("Sign Up"))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
