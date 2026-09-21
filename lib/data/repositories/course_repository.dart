import '../models/course_offering.dart';

abstract class CourseRepository {
  Future<List<CourseOffering>> getAvailableCourses();
}
