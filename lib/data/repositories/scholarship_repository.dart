// lib/data/repositories/scholarship_repository.dart

import '../models/scholarship.dart';
import '../mock/mock_data.dart';

abstract class ScholarshipRepository {
  Future<List<Scholarship>> getScholarships({String? type});
  Future<Scholarship> getScholarshipDetail(int id);
}

class MockScholarshipRepository implements ScholarshipRepository {
  @override
  Future<List<Scholarship>> getScholarships({String? type}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (type == null) return MockData.scholarships;
    return MockData.scholarships.where((s) => s.type == type).toList();
  }

  @override
  Future<Scholarship> getScholarshipDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.scholarships.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('해당 장학금 정보를 찾을 수 없습니다.'),
    );
  }
}
