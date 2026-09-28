# UC Info — Flutter 프로젝트

## 개요
- 플랫폼: iOS / Android (Flutter / Dart SDK ^3.11.0)
- 앱 이름: university_portal_flutter
- 상태관리: flutter_riverpod ^2.6.1 | 라우팅: go_router ^14.6.0
- 현재 단계: **Phase 2 — REST API 연동 완료 (베타 출시 준비)**
- 브랜드 컬러: Primary `#2F5BE8` / Accent `#FFC72C`

---

## 의존성 (pubspec.yaml)
| 패키지 | 버전 | 용도 |
|---|---|---|
| flutter_riverpod | ^2.6.1 | 상태관리 |
| go_router | ^14.6.0 | 라우팅 |
| dio | ^5.4.0 | REST API 통신 |
| flutter_secure_storage | ^11.1.1 | 인증 토큰 안전 저장 |
| intl | ^0.19.0 | 날짜 및 포맷팅 |
| qr_flutter | ^4.1.0 | 모바일 학생증 QR |
| url_launcher | ^6.3.1 | 외부 링크 |
| shared_preferences | ^2.3.0 | 설정값 로컬 저장 |

> ❌ get_it, injectable, riverpod_annotation, riverpod_generator 사용 금지

---

## 폴더 구조
```
lib/
├── core/
│   ├── constants/    # 앱 상수 (AppConstants)
│   ├── network/      # ApiClient, TokenStorage, ApiExceptionUtil
│   ├── router/       # GoRouter 라우트 정의
│   ├── theme/        # AppColors, AppTextStyles, AppSpacing, AppTheme
│   └── utils/        # 공통 유틸 (DebouncedNavigation 등)
├── data/
│   ├── models/       # User, NoticeItem, ScheduleItem, MealData 등 데이터 모델
│   └── repositories/ # Repository 인터페이스 및 Api 구현체 (ApiAuthRepository 등)
├── features/
│   ├── academic_calendar/ # 학사 일정
│   ├── auth/         # 학번 인증
│   ├── enrollment/   # 수강신청/과목 선택
│   ├── grade_simulator/ # 학점 시뮬레이터
│   ├── home/         # 메인 홈 화면 및 위젯
│   ├── meal/         # 식단표 바텀시트
│   ├── mypage/       # 마이페이지
│   ├── notice/       # 공지사항 상세 및 번역
│   ├── notification/ # 알림함 인박스
│   ├── scholarship/  # 장학금 목록/상세
│   ├── settings/     # 설정 바텀시트
│   └── timetable/    # 주간 시간표 바텀시트
└── shared/
    ├── providers/    # 공통 provider
    └── widgets/      # AppButton, AppTextField, UCHeader, AppCard 등
```

**규칙**: 다른 feature의 widget 직접 import 금지. 공통 위젯은 `shared/widgets/`로 이동.

---

## 디자인 시스템 (core/theme/)
색상·타입·간격 모두 상수만 사용 — 하드코딩 금지.

| 토큰 | 파일 | 핵심 값 |
|---|---|---|
| 색상 | app_colors.dart | Primary `#2F5BE8`, Accent `#FFC72C`, Error `#E84040` |
| 타이포 | app_text_styles.dart | heading1 22/700, body1 15/400, caption 12/400 |
| 간격 | app_spacing.dart | xs 4, sm 8, md 16, lg 24, xl 32 (8 배수) |
| 모서리 | app_spacing.dart | radiusSm 8, radiusMd 12, radiusLg 20, radiusFull 999 |
| 시간표 색상 | app_colors.dart | timetableColors[colorIndex % 6] 순환 배정 |

---

## 주요 특징 및 주의사항
- **식단 날짜 임시 대응**: 백엔드 `/api/meal/today`가 아직 `date` 파라미터를 지원하지 않아, 오늘이 아닌 날짜 선택 시 프레임워크에서 `AppConstants.mealDateApiSupported` 플래그(`false`)를 기준으로 안내 화면을 제공함. (추후 백엔드가 날짜별 조회를 지원하면 상수를 `true`로 변경하면 즉시 연동됨)

---

## 상태관리 규칙 (Riverpod)
- `StateNotifier` / `AsyncNotifier` 방식 (코드 자동생성 없음)
- UI 위젯에서 직접 데이터 처리 금지 → Notifier에 위임
- `StatefulWidget` 최소화 → 상태 필요 시 `ConsumerWidget` 사용

---

## Repository 패턴
- `data/repositories/`에 추상 인터페이스(예: `AuthRepository`)와 Dio 기반 구현체(`ApiAuthRepository`) 분리
- `shared/providers/app_providers.dart`를 통해 의존성 주입

---

## 코딩 컨벤션
| 항목 | 규칙 |
|---|---|
| 파일명 | snake_case.dart |
| 클래스 | PascalCase |
| 변수·함수 | camelCase |
| 위젯 분리 | 50줄 초과 또는 재사용 시 별도 파일 |
| const | 가능한 모든 위젯에 const 생성자 |
| async | await 후 context 사용 시 mounted 체크 필수 |

**주석 규칙**:
- 파일 상단: `// 역할: 이 파일이 하는 일 한 줄`
- 클래스/메서드: 한글 Javadoc 및 Dartdoc (`///`) 작성
