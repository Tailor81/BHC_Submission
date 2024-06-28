import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/maintenance_dashboard_screen.dart';
import 'screens/application_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/information_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/property_list_screen.dart';
import 'screens/property_detail_screen.dart';
import 'screens/search_page.dart';
import 'screens/application_form.dart';
import 'screens/statement_screen.dart';
import 'screens/payment_gateway_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _requestPermissions();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await Permission.photos.request();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.storage.request();
  await Permission.phone.request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botswana Housing Corporation',
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.orange,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orange,
          secondary: Colors.orange,
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/maintenance': (context) => const MaintenanceDashboardScreen(),
        '/application': (context) => const ApplicationScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/information': (context) => const InformationScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) =>
            ProfileScreen(user: FirebaseAuth.instance.currentUser!),
        '/property/sale': (context) => PropertyListScreen(type: 'sale'),
        '/property/rent': (context) => PropertyListScreen(type: 'rent'),
        '/property/details': (context) => PropertyDetailScreen(
          property: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
        '/search': (context) => SearchPage(),
        '/statements': (context) => const StatementScreen(),
        '/payment_gateway': (context) => const PaymentGatewayScreen(),
      },
    );
  }
}
