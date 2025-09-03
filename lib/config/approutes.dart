import 'package:flutter/material.dart';
import 'package:student_manager/presentation/screens/add_student_screen.dart';
import 'package:student_manager/presentation/screens/home_screen.dart';
import 'package:student_manager/presentation/screens/login_screen.dart';
import 'package:student_manager/presentation/screens/register_screen.dart';
import 'package:student_manager/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String addstudent = '/addstudent';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case addstudent:
        return MaterialPageRoute(builder: (_) => const AddStudentScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
