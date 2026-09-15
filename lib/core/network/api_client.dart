import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_session_provider.dart';
import 'token_storage.dart';

class ApiClient {
  final Ref _ref;
  final Dio dio;

  ApiClient(this._ref)
      : dio = Dio(
          BaseOptions(
            // TODO: 팀장님 실제 서버 IP로 교체 필요. 바꿀 때 network_security_config.xml의 domain도 같이 바꿔야 함.
            baseUrl: 'https://api.uc-info.com',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TokenStorage를 통해 안전하게 토큰 로드
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // /api/auth/verify 요청 자체의 에러는 로그아웃 처리 대상이 아님
          final isAuthVerify = error.requestOptions.path.contains('/api/auth/verify');
          
          if (error.response?.statusCode == 401 && !isAuthVerify) {
            // 토큰 만료/무효 → 세션 종료. authSessionProvider가 false가 되면
            // 라우터 redirect 로직이 자동으로 /auth로 이동시킨다.
            _ref.read(authSessionProvider.notifier).logout();
          }
          return handler.next(error);
        },
      ),
    );
  }
}
