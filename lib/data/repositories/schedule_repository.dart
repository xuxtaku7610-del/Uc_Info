import '../models/schedule_item.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleItem>> getWeeklySchedule();
}
