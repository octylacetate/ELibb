import 'package:provider/provider.dart';
import 'package:e_lib/providers/auth_provider.dart';
import 'package:e_lib/providers/books_provider.dart';
import 'package:e_lib/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_lib/router/app_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check initial auth state
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');
  final authProvider = AuthProvider();
  if (token != null) {
    await authProvider.setLoggedIn();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.getRouter(context),
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 219, 254, 250),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
