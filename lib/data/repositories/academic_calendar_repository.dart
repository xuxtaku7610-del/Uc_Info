// lib/data/repositories/academic_calendar_repository.dart

import '../models/academic_event.dart';
import '../mock/mock_data.dart';

abstract class AcademicCalendarRepository {
  Future<List<AcademicEvent>> getCalendar();
}

class MockAcademicCalendarRepository implements AcademicCalendarRepository {
  @override
  Future<List<AcademicEvent>> getCalendar() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.academicEvents;
  }
}
