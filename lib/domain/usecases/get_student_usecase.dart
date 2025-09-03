import 'package:student_manager/domain/repository/student_repo.dart';
import '../entities/student.dart';

class GetStudents {
  final StudentRepository repository;
  GetStudents(this.repository);
  Future<List<Student>> call() => repository.getAllStudents();
}
