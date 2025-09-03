import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/config/approutes.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/features/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final firebaseAuth = ref.read(firebaseAuthProvider);
    final isLoggedIn = firebaseAuth.currentUser != null;

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacementNamed(isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Resize(
        builder: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: 120.h,
                child: Image.asset(
                  'assets/images/student_manager.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 24.h),

              // App Name
              Text(
                'Student Manager',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 16.h),

              // Loading indicator
              const CircularProgressIndicator(color: AppColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
