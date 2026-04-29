// lib/data/models/user.dart
// 역할: 인증된 학생 정보 모델.

class User {
  final String name;
  final String department;
  final int year;
  final String studentId;

  const User({
    required this.name,
    required this.department,
    required this.year,
    required this.studentId,
  });
}
