import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<int> addStudent(Student student);
  Future<void> deleteStudent(int id);
  Future<void> updateStudent(Student student);
}
