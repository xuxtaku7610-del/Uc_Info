# UC Info — Flutter 프로젝트

## 개요
- 플랫폼: iOS / Android (Flutter / Dart SDK ^3.11.0)
- 앱 이름: university_portal_flutter
- 상태관리: flutter_riverpod ^2.6.1 | 라우팅: go_router ^14.6.0
- 현재 단계: **Phase 1 — UI + Mock 데이터 (API 연동 없음)**
- 브랜드 컬러: Primary `#2F5BE8` / Accent `#FFC72C`

---

## 의존성 (pubspec.yaml)
| 패키지 | 버전 | 용도 |
|---|---|---|
| flutter_riverpod | ^2.6.1 | 상태관리 |
| go_router | ^14.6.0 | 라우팅 |
| qr_flutter | ^4.1.0 | 모바일 학생증 QR |
| url_launcher | ^6.3.1 | 외부 링크 |
| shared_preferences | ^2.3.0 | 설정값 로컬 저장 |

> ❌ get_it, injectable, dio, riverpod_annotation, riverpod_generator 사용 금지
> ❌ http, Dio 등 네트워크 패키지 금지 (Phase 2 이전)

---

## 폴더 구조
```
lib/
├── core/
│   ├── theme/        # AppColors, AppTextStyles, AppSpacing
│   ├── router/       # GoRouter 라우트 정의
│   ├── constants/    # 앱 상수
│   └── utils/        # 날짜 포맷 등 공통 유틸
├── data/
│   ├── models/       # User, Schedule, Meal 등 데이터 모델
│   ├── mock/         # ★ Phase 1 Mock 데이터 (mock_data.dart)
│   └── repositories/ # 인터페이스만 정의 (구현은 Phase 2)
├── features/
│   ├── auth/         # 학번 인증 화면
│   ├── home/         # 메인 화면
│   ├── timetable/    # 시간표 바텀시트
│   ├── meal/         # 식단 바텀시트
│   ├── notice/       # 공지사항
│   └── settings/     # 설정 바텀시트
└── shared/
    ├── widgets/      # AppButton, AppTextField, UCHeader
    └── providers/    # Riverpod 공통 provider
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

## 화면 목록
| 라우트 | 화면 | 비고 |
|---|---|---|
| `/auth` | 학번 인증 | Phase 1: 학번 `2411206` 입력 시 성공 → `/home` |
| `/home` | 메인 홈 | UCHeader + 배너 + 빠른실행 + 바로가기 + 공지 |
| — | 시간표 Bottom Sheet | showModalBottomSheet, 최대 90% 높이 |
| — | 식단 Bottom Sheet | 조식/중식/석식, 크림 배경 `#FFF8EE` |
| — | 설정 Bottom Sheet | 알림·다크모드 Switch, 언어 Dropdown |
| — | **마이페이지** | **⚠ 현재 빈 화면 — 반드시 전체 구현** |

---

## 상태관리 규칙 (Riverpod)
- `StateNotifier` / `AsyncNotifier` 방식 (코드 자동생성 없음)
- UI 위젯에서 직접 데이터 처리 금지 → Notifier에 위임
- `StatefulWidget` 최소화 → 상태 필요 시 `ConsumerWidget` 사용

## Phase 2 전환 규칙
- Phase 1에서 Repository는 **인터페이스만** 정의, 구현은 Mock으로
- 교체 대상 코드에 반드시 주석: `// TODO(Phase 2): Mock → Api로 교체`
- Phase 2 전환 시 `MockRepository` → `ApiRepository`만 교체

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
- 함수: 무엇을 하고 왜 이렇게 만들었는지
- 변수명으로 의미가 명확하면 주석 생략

---

## 개발 체크리스트
```
[ ] AppColors / AppTextStyles / AppSpacing 상수만 사용 (하드코딩 없음)
[ ] Phase 1: Mock 데이터만 사용 (네트워크 호출 없음)
[ ] 학번 입력: TextInputType.number 적용
[ ] 모바일 학생증: qr_flutter 사용
[ ] 외부 링크: url_launcher 사용
[ ] 설정값: shared_preferences 저장
[ ] 마이페이지: 빈 화면 아님, 전체 구현
[ ] TODO(Phase 2) 주석 표시
[ ] const 생성자 적용
[ ] async 후 mounted 체크
[ ] 아이콘 버튼: Semantics 또는 Tooltip 적용
```

---

## Claude 사용 시 토큰 절약
**첨부 금지**: pubspec.lock, ios/, android/, .gitignore, .metadata

관련 파일만 선택:
- 식단 → `meal_sheet.dart`만
- 라우터 → `app_router.dart`만
- 인증 → `auth_screen.dart` + `auth_provider.dart`만

새 채팅 시작 템플릿:
```
UC Info Flutter 앱 개발 중이야. (Phase 1 — UI + Mock)
CLAUDE.md 참고해서 도와줘.
지금 [작업 내용] 하려는데 관련 파일은 아래야.
[파일 1~2개만]
```
