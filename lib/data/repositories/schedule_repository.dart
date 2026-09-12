import '../models/schedule_item.dart';
import '../mock/mock_data.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleItem>> getWeeklySchedule();
}

class MockScheduleRepository implements ScheduleRepository {
  @override
  Future<List<ScheduleItem>> getWeeklySchedule() async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.schedules;
  }
}
