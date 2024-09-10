// lib/main.dart
import 'package:e_lib/profile.dart';
import 'package:e_lib/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'elib_home.dart';
import 'login.dart';
import 'route_persistence.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final RoutePersistence routePersistence = RoutePersistence();
  bool isLoggedIn = false;
  String initialRoute = '/';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      setState(() {
        isLoggedIn = true;
        // Retrieve the last route
        routePersistence.getLastRoute().then((route) {
          setState(() {
            initialRoute = route ?? '/home';
          });
        });
      });
    } else {
      setState(() {
        initialRoute = '/login';
      });
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    setState(() {
      isLoggedIn = false;
      initialRoute = '/login';
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => Login(),
        ),

        GoRoute(
          path: '/home',
          builder: (context, state) =>
              ELib(isLoggedIn: isLoggedIn, logout: logout),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              Profile(isLoggedIn: isLoggedIn, logout: logout),
        ),
        // Add other routes here
        GoRoute(path: '/signup', builder: (context, state) => Signup()),
      ],
      redirect: (context, state) {
        final isLoggingIn = state.location == '/login';
        if (!isLoggedIn && !isLoggingIn) return '/login';
        if (isLoggedIn && isLoggingIn) return '/home';
        return null;
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
