import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/route_generator.dart';
import 'package:shop_ez/core/routes/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: routeRoot,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
