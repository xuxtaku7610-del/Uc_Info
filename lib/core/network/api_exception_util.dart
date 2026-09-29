import 'package:dio/dio.dart';

/// DioException에서 백엔드가 보낸 에러 메시지를 추출합니다.
/// 응답 바디가 Map이고 'message' 필드가 있으면 그 값을 반환하고,
/// 그렇지 않으면 [fallback] 메시지를 반환합니다.
String extractErrorMessage(DioException e, String fallback) {
  final data = e.response?.data;
  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return '서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요.';
    case DioExceptionType.connectionError:
      return '인터넷 연결을 확인해주세요.';
    default:
      return fallback;
  }
}
