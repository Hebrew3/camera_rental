import 'package:flutter/material.dart';
import 'package:bookmyshoot/screens/authscreen.dart';
import 'package:bookmyshoot/screens/bookingconfirmationscreen.dart';
import 'package:bookmyshoot/screens/bookingscreen.dart';
import 'package:bookmyshoot/screens/equipmentdetail_screen.dart';
import 'package:bookmyshoot/screens/homescreen.dart';
import 'package:bookmyshoot/screens/splashscreen.dart';

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
        return MaterialPageRoute(builder: (_) => const BookingScreen());
      case bookingConfirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['booking'] == null || args['equipment'] == null) {
          return _errorRoute('Booking confirmation requires booking and equipment data');
        }
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(
            booking: args['booking'] as Booking,
            equipment: args['equipment'] as CameraEquipment,
          ),
        );
      case equipmentDetail:
        final equipment = settings.arguments as CameraEquipment?;
        if (equipment == null) {
          return _errorRoute('Equipment detail requires equipment data');
        }
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
          child: Text(message),
        ),
      ),
    );
  }
}