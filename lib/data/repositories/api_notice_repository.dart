import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/notice_item.dart';
import 'notice_repository.dart';

class ApiNoticeRepository implements NoticeRepository {
  final ApiClient _apiClient;

  ApiNoticeRepository(this._apiClient);

  @override
  Future<List<NoticeItem>> getNotices() async {
    try {
      final response = await _apiClient.dio.get('/api/notices');

      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      final List<dynamic> data = rawData;

      try {
        return data.map((json) => NoticeItem.fromJson(json)).toList();
      } catch (e) {
        throw Exception('데이터 형식이 올바르지 않습니다.');
      }
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '공지사항 목록을 불러오지 못했습니다.'));
    }
  }

  @override
  Future<NoticeItem> getNoticeDetail(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/notices/$id');

      return NoticeItem.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '공지사항 상세 정보를 불러오지 못했습니다.'));
    }
  }

  @override
  Future<void> markAsRead(int id, String studentId) async {
    try {
      await _apiClient.dio.post(
        '/api/notices/$id/view',
        data: {'studentId': studentId},
      );
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '읽음 처리에 실패했습니다.'));
    }
  }
}
