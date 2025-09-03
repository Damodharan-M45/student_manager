import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_manager/domain/entities/student.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/features/auth/auth_provider.dart';
import 'package:student_manager/config/approutes.dart';

class HomeProvider extends ChangeNotifier {
  final Ref ref;

  HomeProvider(this.ref);

  List<Student> _students = [];
  List<Student> get students => _students;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void setError(String? val) {
    _error = val;
    notifyListeners();
  }

  Future<void> loadStudents() async {
    setLoading(true);
    setError(null);
    try {
      _students = await ref.read(studentProvider).fetchStudents();

      debugPrint('Filtered students for UID');
      for (var s in _students) {
        debugPrint(
          'Name: ${s.name}, Email: ${s.email}, Phone: ${s.phone}, UserId: ${s.userId}',
        );
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() async {
    await loadStudents();
  }

  Future<void> logout(BuildContext context) async {
    ref.read(loginProvider).clearFields();

    await ref.read(authRepositoryProvider).signOut();

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }
}
