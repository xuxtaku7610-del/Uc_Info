// lib/data/models/user.dart
// 역할: 인증된 학생 정보 모델.

class User {
  final String studentId;
  final String name;
  final String department;
  final int year;

  User({
    required this.studentId,
    required this.name,
    required this.department,
    required this.year,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      studentId: json['studentId'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      year: json['year'] ?? 1,
    );
  }
}
