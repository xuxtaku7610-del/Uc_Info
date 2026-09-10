import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import 'notice_repository.dart';
import '../models/notice_item.dart';

class ApiNoticeRepository implements NoticeRepository {
  final Dio _dio = ApiClient.dio;

  @override
  Future<List<NoticeItem>> getNotices() async {
    // GET: api/notice - 학과 공지사항 목록
    final response = await _dio.get('/api/notice');
    final List<dynamic> data = response.data;
    return data.map((json) => NoticeItem.fromJson(json)).toList();
  }

  @override
  Future<NoticeItem> getNoticeDetail(int id) async {
    // GET: api/notice/{id} - 공지사항 단건 조회
    final response = await _dio.get('/api/notice/$id');
    return NoticeItem.fromJson(response.data);
  }

  @override
  Future<void> markAsRead(int id) async {
    // POST: api/notice/{id}/view - 읽음 처리 재전송
    await _dio.post('/api/notice/$id/view');
  }
}