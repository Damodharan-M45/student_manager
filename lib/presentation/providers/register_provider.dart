import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/features/auth/auth_provider.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/utils/common_utils.dart';

class RegisterProvider extends ChangeNotifier {
  final Ref ref;

  RegisterProvider(this.ref);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    formKey.currentState?.reset();
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    print("ENTER");
    CommonUtils.hideKeyBoard(context);

    if (!formKey.currentState!.validate()) return;

    setLoading(true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authRepositoryProvider).register(email, password);
      ref.read(loginProvider).clearFields();

      CommonUtils.showToast('Registration successful!', AppColors.green);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'weak-password':
          message =
              'Password is too weak. Use at least 8 characters with a number and a special character.';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your internet connection.';
          break;
        default:
          message = e.message ?? 'Registration failed. Please try again.';
      }
      CommonUtils.showToast(message, AppColors.red);
    } catch (e) {
      CommonUtils.showToast(e.toString(), AppColors.red);
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
