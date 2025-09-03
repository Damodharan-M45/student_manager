import 'package:student_manager/utils/helper/db_helper.dart';
import '../models/student_model.dart';

abstract class StudentLocalDataSource {
  Future<List<StudentModel>> getAllStudents();
  Future<int> addStudent(StudentModel s);
  Future<void> deleteStudent(int id);
  Future<void> updateStudent(StudentModel s);
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  @override
  Future<int> addStudent(StudentModel s) async {
    final db = await DBHelper.database;
    return await db.insert('students', s.toMap());
  }

  @override
  Future<void> deleteStudent(int id) async {
    final db = await DBHelper.database;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<StudentModel>> getAllStudents() async {
    final db = await DBHelper.database;
    final maps = await db.query('students', orderBy: 'id DESC');
    return maps.map((m) => StudentModel.fromMap(m)).toList();
  }

  @override
  Future<void> updateStudent(StudentModel s) async {
    final db = await DBHelper.database;
    await db.update('students', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }
}
