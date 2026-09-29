import '../models/academic_event.dart';

abstract class AcademicCalendarRepository {
  Future<List<AcademicEvent>> getCalendar();
}
