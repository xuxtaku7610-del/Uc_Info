import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/notice_item.dart';
import 'notice_repository.dart';

class ApiNoticeRepository implements NoticeRepository {
  final ApiClient _apiClient;

  ApiNoticeRepository(this._apiClient);

  @override
  Future<List<NoticeItem>> getNotices() async {
    try {
      final response = await _apiClient.dio.get('/api/notice');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NoticeItem.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('공지사항 목록 불러오기 실패: ${e.message}');
    }
  }

  @override
  Future<NoticeItem> getNoticeDetail(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/notice/$id');

      if (response.statusCode == 200) {
        return NoticeItem.fromJson(response.data);
      }
      throw Exception('데이터 없음');
    } on DioException catch (e) {
      throw Exception('공지사항 상세 불러오기 실패: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await _apiClient.dio.post('/api/notice/$id/view');
    } on DioException catch (e) {
      throw Exception('읽음 처리 실패: ${e.message}');
    }
  }
}
