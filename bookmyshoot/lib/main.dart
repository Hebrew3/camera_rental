import 'package:flutter/material.dart';
import 'package:bookmyshoot/screens/authscreen.dart';
import 'package:bookmyshoot/screens/bookingconfirmationscreen.dart';
import 'package:bookmyshoot/screens/bookingscreen.dart';
import 'package:bookmyshoot/screens/equipmentdetail_screen.dart';
import 'package:bookmyshoot/screens/homescreen.dart';
import 'package:bookmyshoot/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyShoot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String booking = '/booking';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String equipmentDetail = '/equipment-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case booking:
        final equipment = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(equipment: equipment),
        );
      case bookingConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        
        try {
          // Create booking and equipment using their fromMap constructors
          final booking = Booking.fromMap(args['booking'] as Map<String, dynamic>);
          final equipment = CameraEquipment.fromMap(args['equipment'] as Map<String, dynamic>);

          return MaterialPageRoute(
            builder: (_) => BookingConfirmationScreen(
              booking: booking,
              equipment: equipment,
            ),
          );
        } catch (e) {
          return _errorRoute('Failed to create booking confirmation: $e');
        }
      case equipmentDetail:
        final equipment = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EquipmentDetailScreen(equipment: equipment),
        );
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(message, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}