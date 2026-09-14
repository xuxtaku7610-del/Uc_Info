// lib/data/repositories/enrollment_repository.dart

abstract class EnrollmentRepository {
  Future<void> enroll(int courseOfferingId);
  Future<void> unenroll(int enrollmentId);
}

class MockEnrollmentRepository implements EnrollmentRepository {
  @override
  Future<void> enroll(int courseOfferingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> unenroll(int enrollmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
