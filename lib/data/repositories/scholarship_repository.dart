import '../models/scholarship.dart';

abstract class ScholarshipRepository {
  Future<List<Scholarship>> getScholarships({String? type});
  Future<Scholarship> getScholarshipDetail(int id);
}
