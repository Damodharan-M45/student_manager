import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/domain/entities/student.dart';
import 'package:student_manager/features/auth/auth_provider.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/utils/common_utils.dart';

class AddStudentProvider extends ChangeNotifier {
  final Ref ref;

  AddStudentProvider(this.ref);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    formKey.currentState?.reset();
    notifyListeners();
  }

  Future<void> saveStudent(BuildContext context) async {
    CommonUtils.hideKeyBoard(context);

    if (!formKey.currentState!.validate()) return;

    final firebaseAuth = ref.read(firebaseAuthProvider);
    final uid = firebaseAuth.currentUser?.uid;

    if (uid == null) {
      CommonUtils.showToast('UserId not found!', AppColors.red);
      return;
    }

    setLoading(true);

    try {
      final student = Student(
        userId: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await ref.read(studentProvider).add(student);

      await ref.read(homeProvider).refresh();

      // Print updated student list
      final students = ref.read(homeProvider).students;
      for (var s in students) {
        log(
          'Student: ${s.name}, Email: ${s.email}, Phone: ${s.phone}, userId: ${s.userId}',
        );
      }

      CommonUtils.showToast('Student added successfully!', AppColors.green);

      Navigator.of(context).pop();
    } catch (e) {
      CommonUtils.showToast('Error saving: $e', AppColors.red);
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
