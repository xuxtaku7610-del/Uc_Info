import 'package:flutter/material.dart';

class AppTheme {
  // [수정 포인트 1: 브랜드 컬러]
  // 팀의 메인 컬러로 이 HEX 코드들을 변경해 보세요.
  static const Color brandBlue = Color(0xFF2C5282);
  static const Color brandYellow = Color(0xFFFFC107);
  static const Color appBackground = Color(0xFFF0F4F8);
 
  // [수정 포인트 2: 텍스트 컬러]
  // 글씨 색상도 여기서 일괄적으로 바꿀 수 있습니다.
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666); 
  
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: appBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: brandBlue),
      appBarTheme: const AppBarTheme(
        backgroundColor: appBackground,
        elevation: 0,
        centerTitle: false,
      ),
      // [도전 과제: 텍스트 테마 추가]
      // 여기에 textTheme: TextTheme(...) 을 추가하여 기본 폰트나 글씨 크기를 세팅해 보세요.
    );
  }
}