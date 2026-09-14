// lib/data/repositories/course_repository.dart

import '../models/course_offering.dart';
import '../mock/mock_data.dart';

abstract class CourseRepository {
  Future<List<CourseOffering>> getAvailableCourses();
}

class MockCourseRepository implements CourseRepository {
  @override
  Future<List<CourseOffering>> getAvailableCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.courseOfferings;
  }
}
