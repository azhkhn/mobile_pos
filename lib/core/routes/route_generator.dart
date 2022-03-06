import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/screens/auth/page/login_screen.dart';
import 'package:shop_ez/screens/auth/page/signup_screen.dart';
import 'package:shop_ez/screens/home/home_screen.dart';
import 'package:shop_ez/screens/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case routeRoot:
        return MaterialPageRoute(builder: (_) => const ScreenSplash());
      case routeHome:
        return MaterialPageRoute(builder: (_) => const ScreenHome());
      case routeLogin:
        return MaterialPageRoute(builder: (_) => ScreenLogin());
      case routeSignUp:
        return MaterialPageRoute(builder: (_) => ScreenSignUp());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
