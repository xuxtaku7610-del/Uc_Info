abstract class EnrollmentRepository {
  Future<void> enroll(int courseOfferingId);
  Future<void> unenroll(int enrollmentId);
}
