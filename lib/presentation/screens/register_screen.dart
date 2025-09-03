import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/utils/common_utils.dart';
import 'package:student_manager/widgets/customelevatedbutton_widget.dart';
import 'package:student_manager/widgets/customtextfield_widget.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regProvider = ref.watch(registerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Resize(
        builder: () => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
          child: Form(
            key: regProvider.formKey,
            child: Column(
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
                  controller: regProvider.emailController,
                  textSize: 12.sp,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.deny(RegExp(r'[^\w@.\-]')),
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
                  controller: regProvider.passwordController,
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
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'Confirm Password',
                  controller: regProvider.confirmPasswordController,
                  obscureText: true,
                  textSize: 12.sp,
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (pwd) {
                    if (pwd == null || pwd.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (pwd != regProvider.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                CustomElevatedButton(
                  text: 'Register',
                  onPressed: regProvider.loading
                      ? null
                      : () => regProvider.register(context),
                  isLoading: regProvider.loading,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    CommonUtils.hideKeyBoard(context);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Already have an account? Login',
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
