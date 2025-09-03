import 'package:student_manager/data/datasource/student_datasource_impl.dart';
import 'package:student_manager/data/models/student_model.dart';
import 'package:student_manager/domain/repository/student_repo.dart';
import '../../domain/entities/student.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;

  StudentRepositoryImpl({required this.localDataSource});

  @override
  Future<int> addStudent(Student student) {
    final model = StudentModel(
      id: student.id,
      userId: student.userId,
      name: student.name,
      email: student.email,
      phone: student.phone,
    );
    return localDataSource.addStudent(model);
  }

  @override
  Future<void> deleteStudent(int id) => localDataSource.deleteStudent(id);

  @override
  Future<List<Student>> getAllStudents() async {
    final models = await localDataSource.getAllStudents();
    return models;
  }

  @override
  Future<void> updateStudent(Student student) {
    final model = StudentModel(
      id: student.id,
      userId: student.userId,
      name: student.name,
      email: student.email,
      phone: student.phone,
    );
    return localDataSource.updateStudent(model);
  }
}
