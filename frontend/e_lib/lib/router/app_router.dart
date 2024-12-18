import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:e_lib/providers/auth_provider.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/my_book.dart';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/editProfile.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/book_read_screen.dart';
import 'package:e_lib/signup.dart';
import 'package:e_lib/new_password.dart';
import 'package:e_lib/screens/book_list_screen.dart';
import 'package:e_lib/screens/book_upload_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static String? _lastLocation;

  static GoRouter getRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: _lastLocation ?? '/',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = authProvider.isLoggedIn;
        final bool isLoginRoute = state.matchedLocation == '/login';
        final bool isSignupRoute = state.matchedLocation == '/signup';

        if (!isLoggedIn && (isLoginRoute || isSignupRoute)) {
          return null;
        }

        if (!isLoggedIn) {
          _lastLocation = state.matchedLocation;
          return '/login';
        }

        if (isLoggedIn && isLoginRoute) {
          return '/';
        }

        return null;
      },
      routes: [
        // ShellRoute(
          // navigatorKey: _shellNavigatorKey,
          // builder: (context, state, child) {
          //   return ELib(
          //     isLoggedIn: authProvider.isLoggedIn,
          //     logout: authProvider.logout,
          //     child: child,
          //   );
          // },
          // routes: [
            GoRoute(
              path: '/',
              builder: (context, state) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                return ELib(
                  isLoggedIn: authProvider.isLoggedIn,
                  logout: authProvider.logout,
                 
                );
              },
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                return Profile(
                  isLoggedIn: authProvider.isLoggedIn,
                  logout: authProvider.logout,
                );
              },
            ),
            GoRoute(
              path: '/my-books',
              builder: (context, state) => MyBook(),
            ),
            GoRoute(
              path: '/all-books',
              builder: (context, state) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                return Booksall(
                  isLoggedIn: authProvider.isLoggedIn,
                  logout: authProvider.logout,
                );
              },
            ),
            GoRoute(
              path: '/book-list',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: BookListScreen(),
              ),
            ),
            GoRoute(
              path: '/book-upload',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: BookUploadScreen(),
              ),
            ),
            GoRoute(
              path: '/book/:id',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: BookDetailScreen(
                  bookId: state.pathParameters['id']!,
                ),
              ),
            ),
            GoRoute(
              path: '/read-book',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: BookRead(
                  bookUrl: state.uri.queryParameters['url'] ?? '',
                ),
              ),
            ),
          // ],
        // ),
        GoRoute(
          path: '/login',
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => Signup(),
        ),
        GoRoute(
          path: '/edit-profile',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: EditProfile(),
          ),
        ),
        GoRoute(
          path: '/change-password',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: ChangePasswordScreen(),
          ),
        ),
      ],
    );
  }
} 