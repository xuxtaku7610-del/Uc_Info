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
      // 백엔드 명세에 맞춰 복수형(/api/notices)으로 수정
      final response = await _apiClient.dio.get('/api/notices');

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
      // 백엔드 명세에 맞춰 복수형(/api/notices)으로 수정
      final response = await _apiClient.dio.get('/api/notices/$id');

      if (response.statusCode == 200) {
        return NoticeItem.fromJson(response.data);
      }
      throw Exception('데이터 없음');
    } on DioException catch (e) {
      throw Exception('공지사항 상세 불러오기 실패: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(int id, String studentId) async {
    try {
      // 백엔드 NoticeViewRequest 규격에 맞춰 바디에 studentId 포함
      await _apiClient.dio.post(
        '/api/notices/$id/view',
        data: {'studentId': studentId},
      );
    } on DioException catch (e) {
      throw Exception('읽음 처리 실패: ${e.message}');
    }
  }
}
