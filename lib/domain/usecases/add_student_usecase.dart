import 'package:student_manager/domain/repository/student_repo.dart';
import '../entities/student.dart';

class AddStudent {
  final StudentRepository repository;
  AddStudent(this.repository);
  Future<int> call(Student student) => repository.addStudent(student);
}
