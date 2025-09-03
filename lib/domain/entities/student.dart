class Student {
  final int? id;
  final String userId;
  final String name;
  final String email;
  final String phone;

  Student({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  });

  Student copyWith({
    int? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
  }) {
    return Student(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
