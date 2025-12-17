import 'package:flutter/material.dart';
import 'package:tailor_app/screens/main_wrapper.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = home;
  static const String home = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainWrapper());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
