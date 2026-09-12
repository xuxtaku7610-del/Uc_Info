import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.uc-info.com', // 추후 실제 백엔드 서버 주소로 변경
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5), // 응답 무한 대기 방지
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 기기에 저장된 토큰이 있다면 모든 요청 헤더에 자동으로 장착
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
