import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_manager/domain/entities/student.dart';
import 'package:student_manager/domain/repository/student_repo.dart';
import 'package:student_manager/domain/usecases/add_student_usecase.dart';
import 'package:student_manager/domain/usecases/get_student_usecase.dart';

class StudentProvider extends ChangeNotifier {
  final GetStudents _getStudents;
  final AddStudent _addStudent;
  final StudentRepository _repository;

  List<Student> _students = [];
  bool _isLoading = false;
  String? _error;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get error => _error;

  StudentProvider(this._getStudents, this._addStudent, this._repository) {
    fetchStudents();
  }

  Future<List<Student>> fetchStudents() async {
    _isLoading = true;
    _error = null;

    try {
      final firebaseAuth = FirebaseAuth.instance;
      final uid = firebaseAuth.currentUser?.uid ?? '';

      if (uid.isEmpty) {
        debugPrint('No logged-in user. Returning empty list.');
        _students = [];
        _isLoading = false;
        return _students;
      }

      final allStudents = await _getStudents();
      debugPrint('All students from DB:');
      for (var s in allStudents) {
        debugPrint(
          'Name: ${s.name}, Email: ${s.email}, Phone: ${s.phone}, UserId: ${s.userId}',
        );
      }

      _students = allStudents.where((s) => s.userId == uid).toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching students: $_error');
    }

    _isLoading = false;
    return _students;
  }

  Future<void> refresh() async => fetchStudents();

  Future<void> add(Student student) async {
    _isLoading = true;

    try {
      await _addStudent(student);

      for (var s in _students) {
        debugPrint('Student: ${s.name}, Email: ${s.email}, Phone: ${s.phone}');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> delete(int id) async {
    _isLoading = true;

    try {
      await _repository.deleteStudent(id);
      await fetchStudents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}
