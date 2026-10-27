import 'dart:convert';

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/chat_models.dart';
import 'chat_repository.dart';

/// 공지 AI 챗봇 API 구현체.
///
/// UC Info nginx의 `/chat-api/*` 경로를 통해 챗봇 서버 `/api/chat/*`를 호출한다.
/// 인증 토큰은 기존 [ApiClient] 인터셉터가 그대로 붙인다.
class ApiChatRepository implements ChatRepository {
  final ApiClient _apiClient;

  ApiChatRepository(this._apiClient);

  @override
  Stream<ChatEvent> sendMessage(String message, {int? sessionId}) async* {
    final Response<ResponseBody> response;
    try {
      response = await _apiClient.dio.post<ResponseBody>(
        '/chat-api/stream',
        // 서버 스키마상 session_id는 필수 키 → 새 대화도 null로 명시
        data: {'session_id': sessionId, 'message': message},
        options: Options(
          responseType: ResponseType.stream,
          // 기본 5초는 RAG 검색 + 첫 토큰 생성보다 짧다
          receiveTimeout: const Duration(seconds: 120),
          headers: {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_messageFor(e, '답변을 받지 못했습니다.'));
    }

    final lines = utf8.decoder
        .bind(response.data!.stream)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;
      final payload = line.substring(6);
      if (payload == '[DONE]') return;

      final json = jsonDecode(payload) as Map<String, dynamic>;
      switch (json['type']) {
        case 'meta':
          final rawSources = json['sources'];
          yield ChatMetaEvent(
            json['session_id'] ?? 0,
            rawSources is List
                ? rawSources.map((s) => ChatSource.fromJson(s)).toList()
                : const [],
          );
        case 'token':
          yield ChatTokenEvent(json['content'] ?? '');
        case 'error':
          throw Exception(json['message'] ?? '응답 생성 중 오류가 발생했습니다.');
      }
    }
  }

  @override
  Future<List<ChatSession>> getSessions() async {
    try {
      final response = await _apiClient.dio.get('/chat-api/sessions');
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      return rawData.map((json) => ChatSession.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_messageFor(e, '대화 목록을 불러오지 못했습니다.'));
    }
  }

  @override
  Future<ChatSession> getSession(int id) async {
    try {
      final response = await _apiClient.dio.get('/chat-api/sessions/$id');
      return ChatSession.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_messageFor(e, '대화를 불러오지 못했습니다.'));
    }
  }

  @override
  Future<void> deleteSession(int id) async {
    try {
      await _apiClient.dio.delete('/chat-api/sessions/$id');
    } on DioException catch (e) {
      throw Exception(_messageFor(e, '대화를 삭제하지 못했습니다.'));
    }
  }

  /// 챗봇 서버는 에러를 {"detail": ...}로 보내고, 스트림 요청은 바디를 읽을 수 없으므로
  /// 상태 코드 기준으로 안내 문구를 정한다.
  String _messageFor(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['detail'] is String) {
      return data['detail'];
    }
    switch (e.response?.statusCode) {
      case 401:
        return '로그인이 만료되었습니다. 다시 로그인해주세요.';
      case 403:
        return '현재 학과는 공지 AI를 지원하지 않습니다.';
      case 429:
        return '요청이 많아요. 잠시 후 다시 시도해주세요.';
      case 502:
      case 503:
      case 504:
        return '공지 AI가 일시적으로 응답하지 않습니다. 잠시 후 다시 시도해주세요.';
    }
    return extractErrorMessage(e, fallback);
  }
}
