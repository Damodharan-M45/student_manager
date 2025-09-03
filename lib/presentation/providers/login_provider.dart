import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/features/auth/auth_provider.dart';
import 'package:student_manager/utils/common_utils.dart';

class LoginProvider extends ChangeNotifier {
  final Ref ref;

  LoginProvider(this.ref) {
    clearFields();
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    formKey.currentState?.reset();
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    CommonUtils.hideKeyBoard(context);
    if (!formKey.currentState!.validate()) return;

    setLoading(true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authRepositoryProvider).signIn(email, password);
      CommonUtils.showToast('Logged in successfully!', AppColors.green);
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your connection.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Try later.';
          break;
        default:
          message = e.message ?? 'Login failed. Please try again.';
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
    super.dispose();
  }
}
