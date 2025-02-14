import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:e_lib/providers/auth_provider.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/signup.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/my_book.dart';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/book_read_screen.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/screens/book_upload_screen.dart';
import 'package:e_lib/screens/favorite_books_screen.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login';
        final isSignupRoute = state.matchedLocation == '/signup';

        // If not logged in and not on login/signup page, go to login
        if (!isLoggedIn && !isLoginRoute && !isSignupRoute) {
          return '/login';
        }

        // If logged in and on login/signup page, go to home
        if (isLoggedIn && (isLoginRoute || isSignupRoute)) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ELib(
            isLoggedIn: authProvider.isLoggedIn,
            logout: () async {
              await authProvider.logout();
            },
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => Signup(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => Profile(
            isLoggedIn: authProvider.isLoggedIn,
            logout: () async {
              await authProvider.logout();
            },
          ),
        ),
        GoRoute(
          path: '/my-books',
          builder: (context, state) => const MyBook(),
        ),
        GoRoute(
          path: '/all-books',
          builder: (context, state) => Booksall(
            isLoggedIn: authProvider.isLoggedIn,
            logout: () async {
              await authProvider.logout();
            },
          ),
        ),
        GoRoute(
          path: '/book/:id',
          builder: (context, state) => BookDetailScreen(
            bookId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/read-book',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: BookRead(
              bookUrl: state.uri.queryParameters['url'] ?? '',
              bookId: state.uri.queryParameters['bookId'] ?? '',
            ),
          ),
        ),
        GoRoute(
          path: '/upload-book',
          builder: (context, state) => const BookUploadScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoriteBooksScreen(),
        ),
      ],
      errorBuilder: (context, state) => const Center(
        child: Text('Page not found'),
      ),
    );
  }
}

