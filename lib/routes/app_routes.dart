import 'package:flutter/material.dart';
import 'package:tailor_app/screens/auth/initial_screen.dart';
import 'package:tailor_app/screens/auth/login_screen.dart';
import 'package:tailor_app/screens/auth/register_screen.dart';
import 'package:tailor_app/screens/main_wrapper.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/initial';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const InitialScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
