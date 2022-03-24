import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/screens/auth/pages/login_screen.dart';
import 'package:shop_ez/screens/auth/pages/signup_screen.dart';
import 'package:shop_ez/screens/brand/screen_brand.dart';
import 'package:shop_ez/screens/category/screen_category.dart';
import 'package:shop_ez/screens/customer/screen_customer.dart';
import 'package:shop_ez/screens/expense/screen_expense.dart';
import 'package:shop_ez/screens/home/home_screen.dart';
import 'package:shop_ez/screens/item_master/screen_item_master.dart';
import 'package:shop_ez/screens/splash/splash_screen.dart';
import 'package:shop_ez/screens/sub-category/screen_sub_category.dart';
import 'package:shop_ez/screens/supplier/manage_supplier_screen.dart';
import 'package:shop_ez/screens/unit/screen_unit.dart';

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
        return MaterialPageRoute(builder: (_) => const ScreenSignUp());
      case routeItemMaster:
        return MaterialPageRoute(builder: (_) => const ScreenItemMaster());
      case routeManageSupplier:
        return MaterialPageRoute(builder: (_) => ScreenManageSupplier());
      case routeCategory:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case routeSubCategory:
        return MaterialPageRoute(builder: (_) => const SubCategoryScreen());
      case routeBrand:
        return MaterialPageRoute(builder: (_) => const BrandScreen());
      case routeCustomer:
        return MaterialPageRoute(builder: (_) => const CustomerScreen());
      case routeUnit:
        return MaterialPageRoute(builder: (_) => const UnitScreen());
      case routeExpense:
        return MaterialPageRoute(builder: (_) => const ManageExpenseScreen());
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
