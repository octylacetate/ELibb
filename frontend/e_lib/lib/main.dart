// lib/main.dart
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'elib_home.dart';
import 'login.dart';
import 'route_persistence.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/book_read_screen.dart';

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
          path: '/',
          redirect: (_, __) => '/home',
        ),
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
        GoRoute(
          path: '/signup',
          builder: (context, state) => Signup(),
        ),
        GoRoute(
          path: '/books_all',
          builder: (context, state) =>
              Booksall(isLoggedIn: isLoggedIn, logout: logout),
        ),
        GoRoute(
          path: '/book_details/:id',
          builder: (context, state) => BookDetailScreen(
            bookId: state.params['id']!,
            isLoggedIn: isLoggedIn,
            logout: logout,
          ),
        ),
        GoRoute(
          path: '/book_read/:id',
          builder: (context, state) => BookRead(
            bookUrl:
                'https://your-api-url.com/books/${state.params['id']}/content',
            isLoggedIn: isLoggedIn,
            logout: logout,
          ),
        ),
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
