import '../../domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    super.id,
    required super.userId,
    required super.name,
    required super.email,
    required super.phone,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int?,
      userId: map['userId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
