import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/config/approutes.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/utils/common_utils.dart';
import 'package:student_manager/widgets/customelevatedbutton_widget.dart';
import 'package:student_manager/widgets/customtextfield_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProv = ref.read(loginProvider);
      loginProv.clearFields();
      loginProv.formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mloginProvider = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Resize(
        builder: () => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
          child: Form(
            key: mloginProvider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120.h,
                  child: Image.asset(
                    'assets/images/student_manager.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  label: 'Email',
                  controller: mloginProvider.emailController,
                  textSize: 12.sp,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatter: [
                    // Deny spaces
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    // Deny emoji/unicode symbols
                    FilteringTextInputFormatter.deny(
                      RegExp(
                        r'[^\w@.\-]', // allows letters, numbers, underscore, @, dot, dash
                      ),
                    ),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.email),
                ),

                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'Password',
                  controller: mloginProvider.passwordController,
                  obscureText: true,
                  textSize: 12.sp,
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  prefixIcon: const Icon(Icons.lock),
                  validator: (pwd) {
                    if (pwd == null || pwd.isEmpty) {
                      return 'Password is required';
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pwd)) {
                      return 'Password must contain a special character';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(pwd)) {
                      return 'Password must contain a number';
                    }
                    if (pwd.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                CustomElevatedButton(
                  text: 'Login',
                  isLoading: mloginProvider.loading,
                  onPressed: mloginProvider.loading
                      ? null
                      : () => mloginProvider.login(context),
                  icon: Icon(Icons.login, color: AppColors.white, size: 20.sp),
                  fontSize: 14.sp,
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    CommonUtils.hideKeyBoard(context);
                    // Clear fields
                    final loginProv = ref.read(loginProvider);
                    final regprov = ref.read(registerProvider);

                    loginProv.clearFields();
                    regprov.clearFields();
                    Navigator.of(context).pushNamed(AppRoutes.register);
                  },
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(color: AppColors.black, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
