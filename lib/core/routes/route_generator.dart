import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/screens/auth/pages/login_screen.dart';
import 'package:shop_ez/screens/auth/pages/signup_screen.dart';
import 'package:shop_ez/screens/home/home_screen.dart';
import 'package:shop_ez/screens/home_items/manage_users.dart';
import 'package:shop_ez/screens/item_master/item_master_screen.dart';
import 'package:shop_ez/screens/splash/splash_screen.dart';
import 'package:shop_ez/screens/supplier/manage_supplier_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case routeRoot:
        return MaterialPageRoute(builder: (_) => const ScreenSplash());
      case routeHome:
        return MaterialPageRoute(builder: (_) => ScreenHome());
      case routeLogin:
        return MaterialPageRoute(builder: (_) => ScreenLogin());
      case routeSignUp:
        return MaterialPageRoute(builder: (_) => ScreenSignUp());
      case routeManageUsers:
        return MaterialPageRoute(builder: (_) => ManageUsers());
      case routeItemMaster:
        return MaterialPageRoute(builder: (_) => ScreenItemMaster());
      case routeManageSupplier:
        return MaterialPageRoute(builder: (_) => ScreenManageSupplier());
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
