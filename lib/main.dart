import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('ko_KR', null);

    // Flutter 프레임워크 내부에서 발생하는 에러(위젯 빌드 중 예외 등)를 잡아서 로그로 남긴다.
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('❌ FlutterError: ${details.exceptionAsString()}');
    };

    // 순수 Dart 비동기 코드(Future, Stream 등)에서 발생하는 미처리 예외를 잡는다.
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('❌ Uncaught error: $error\n$stack');
      return true;
    };

    runApp(
      const ProviderScope(
        child: UniversityPortalApp(),
      ),
    );
  }, (error, stack) {
    // runZonedGuarded 바깥(가장 바깥 zone)에서 잡히는 에러의 최종 안전망
    debugPrint('❌ Zone error: $error\n$stack');
  });
}
