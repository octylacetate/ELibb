import 'package:provider/provider.dart';
import 'package:e_lib/providers/auth_provider.dart';
import 'package:e_lib/providers/books_provider.dart';
import 'package:e_lib/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_lib/router/app_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Custom Colors
const primaryColor = Color.fromARGB(255, 219, 254, 250);
const secondaryColor = Color.fromARGB(255, 17, 106, 136);
const accentColor = Color.fromARGB(255, 100, 204, 199);
const textDarkColor = Color.fromARGB(255, 0, 21, 44);
const warmAccentColor = Color.fromARGB(255, 255, 183, 77); // Muted gold
const coralAccentColor = Color.fromARGB(255, 255, 127, 80); // Coral
const darkPrimaryColor = Color.fromARGB(255, 176, 223, 219); // Darker variant of primary
const subtleBackgroundColor = Color.fromARGB(20, 17, 106, 136); // Subtle secondary

// Gradient Definitions
const primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryColor, darkPrimaryColor],
);

const accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [warmAccentColor, coralAccentColor],
);

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
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: accentColor,
          surface: Colors.white,
          background: Colors.white,
          error: coralAccentColor,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: textDarkColor),
          headlineMedium: TextStyle(color: textDarkColor),
          bodyLarge: TextStyle(color: textDarkColor),
          bodyMedium: TextStyle(color: textDarkColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: textDarkColor,
            backgroundColor: primaryColor,
            elevation: 2,
          ),
        ),
        cardTheme: CardTheme(
          color: primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
