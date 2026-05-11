# UC Info 프로젝트

## 프로젝트 개요
- 플랫폼: iOS / Android (Flutter)
- 언어: Dart (SDK ^3.11.0)
- 앱 이름: university_portal_flutter
- 상태관리: flutter_riverpod ^2.6.1
- 라우팅: go_router ^14.6.0
- 현재 단계: **Phase 1 — UI + Mock 데이터만 (API 연동 없음)**
- 브랜드 컬러: #2F5BE8 (Primary), #FFC72C (Accent)

> ⚠️ Phase 1 규칙: Dio, http 등 네트워크 패키지 사용 금지.
> 모든 데이터는 lib/data/mock/mock_data.dart의 Mock 데이터 사용.
> Phase 2 전환 시 MockRepository → ApiRepository만 교체하면 되도록
> 인터페이스를 먼저 정의해둔다.

---

## 실제 pubspec.yaml 의존성

```yaml
dependencies:
  flutter_riverpod: ^2.6.1   # 상태관리
  go_router: ^14.6.0         # 라우팅
  qr_flutter: ^4.1.0         # 모바일 학생증 QR코드
  url_launcher: ^6.3.1       # 바로가기 외부 링크
  shared_preferences: ^2.3.0 # 설정값 로컬 저장 (알림, 다크모드, 언어)
```

> ❌ get_it, injectable, dio, riverpod_annotation, riverpod_generator 사용 금지
> pubspec.yaml에 없는 패키지는 추가 전 반드시 확인할 것

---

## 폴더 구조

```
lib/
├── core/
│   ├── theme/              # AppColors, AppTextStyles, AppSpacing
│   ├── router/             # GoRouter 라우트 정의
│   ├── constants/          # 앱 상수
│   └── utils/              # 날짜 포맷 등 공통 유틸
│
├── data/
│   ├── models/             # User, Schedule, Meal 등 데이터 모델
│   ├── mock/               # ★ Phase 1용 Mock 데이터 (mock_data.dart)
│   └── repositories/       # 인터페이스만 정의 (구현은 Phase 2)
│
├── features/
│   ├── auth/               # 학번 인증 화면
│   │   ├── screens/
│   │   └── widgets/
│   ├── home/               # 메인 화면
│   │   ├── screens/
│   │   └── widgets/
│   ├── timetable/          # 주간 시간표 바텀시트
│   ├── meal/               # 식단표 바텀시트
│   ├── notice/             # 공지사항
│   └── settings/           # 설정 바텀시트
│
└── shared/
    ├── widgets/            # AppButton, AppTextField, UCHeader 등
    └── providers/          # Riverpod 공통 provider
```

**규칙**:
- feature 폴더는 화면 단위로 분리
- 다른 feature의 widget 직접 import 금지
- 공통 위젯은 반드시 shared/widgets/로 이동
- 위젯 50줄 초과 또는 재사용 시 별도 파일로 분리

---

## 디자인 시스템

### 색상 (core/theme/app_colors.dart)

```dart
class AppColors {
  static const Color primary       = Color(0xFF2F5BE8); // 헤더, 버튼, 배지
  static const Color primaryLight  = Color(0xFFEAF0FF);
  static const Color accent        = Color(0xFFFFC72C); // CTA, 모바일 학생증 버튼
  static const Color accentDark    = Color(0xFFE6A800); // pressed state

  static const Color background    = Color(0xFFF4F6FA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color divider       = Color(0xFFEAECF0);
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFFADB5BD);

  static const Color error         = Color(0xFFE84040);
  static const Color errorLight    = Color(0xFFFFF0F0);
  static const Color success       = Color(0xFF22C55E);
  static const Color warning       = Color(0xFFFB923C);

  // 시간표 블록 — colorIndex % 6 으로 순환 배정
  static const List<Color> timetableColors = [
    Color(0xFFBBF0D4), // 민트
    Color(0xFFFFE5B4), // 노랑
    Color(0xFFD4BBFF), // 보라
    Color(0xFFB4D4FF), // 파랑
    Color(0xFFFFB4C2), // 핑크
    Color(0xFFC8F5A0), // 연두
  ];
}
```

> ❌ 색상 하드코딩 금지 — 반드시 AppColors 상수 사용

### 타이포그래피 (core/theme/app_text_styles.dart)

```dart
class AppTextStyles {
  static const heading1   = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const heading2   = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static const heading3   = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const body1      = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static const body2      = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const caption    = TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary);
  static const label      = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
  static const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
}
```

> ❌ 폰트 크기 하드코딩 금지 — 반드시 AppTextStyles 사용

### 간격 및 모서리 (core/theme/app_spacing.dart)

```dart
class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;

  static const double radiusSm   = 8.0;
  static const double radiusMd   = 12.0;
  static const double radiusLg   = 20.0;
  static const double radiusFull = 999.0; // pill shape
}
```

> ❌ 간격 하드코딩 금지 — 반드시 AppSpacing 사용 (8 배수 원칙)

---

## 공통 위젯 (shared/widgets/)

### AppButton — 노란 CTA 버튼

```dart
AppButton(
  label: '학번 인증하기',
  trailingIcon: Icons.chevron_right,
  onPressed: () {},
  isLoading: false,
)
```
- 배경: AppColors.accent / 텍스트: AppColors.textPrimary bold
- 모서리: radiusFull (완전 pill) / 높이: 54px 고정
- 로딩 시: CircularProgressIndicator(16px) + 버튼 비활성화

### AppTextField — 입력 필드

```dart
AppTextField(
  label: '학과',
  placeholder: '예: 컴퓨터공학과',
  isRequired: true,
  errorText: '학과를 입력해주세요.',
  controller: controller,
)
```
- 기본 테두리: AppColors.divider
- 포커스: AppColors.primary
- 에러: AppColors.error 테두리 + 하단 빨간 텍스트
- 필수 표시: 라벨 우측 "(필수)" — AppColors.error 색상

### UCHeader — 상단 공통 헤더

```dart
UCHeader(showSettings: true)  // 메인: true / 인증 화면: false
```

---

## 상태관리 (Riverpod) 규칙

```dart
// StateNotifier 방식 사용 (코드 자동생성 없음)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(repository: MockAuthRepository());
  // TODO(Phase 2): MockAuthRepository → ApiAuthRepository로 교체
});
```

- 모든 비즈니스 로직은 StateNotifier 또는 AsyncNotifier에 작성
- UI 위젯에서 직접 데이터 처리 금지
- StatefulWidget 최소화 — 상태 필요 시 ConsumerWidget 사용

---

## Mock 데이터 (data/mock/mock_data.dart)

```dart
// Phase 1: 학번 2411206 입력 시 성공 처리
const mockUser = User(
  name: '홍길동',
  department: '컴퓨터공학과',
  year: 3,
  studentId: '2412000',
);

final mockSchedule = [
  ScheduleItem(subject: '데이터베이스', day: '월',
    startHour: 9, endHour: 11, room: '공학관 301', colorIndex: 0),
  ScheduleItem(subject: '알고리즘', day: '화',
    startHour: 10, endHour: 12, room: '공학관 205', colorIndex: 1),
  // 추가 항목...
];

final mockMeal = MealData(
  date: '2026년 3월 30일 월요일',
  breakfast: MealSection(time: '08:00-09:30',
    items: ['쌀밥','김치찌개','계란후라이','배추김치','과일']),
  lunch: MealSection(time: '11:30-13:30',
    items: ['차돌박이덮밥','된장국','잡채','깍두기','요구르트']),
  dinner: MealSection(time: '17:00-19:00',
    items: ['돈까스','흰밥','우동국','샐러드','단무지']),
);
```

---

## 라우팅 (GoRouter)

```dart
final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    // 바텀시트는 라우트 아닌 showModalBottomSheet로 처리
  ],
  // TODO(Phase 2): 인증 여부 체크 redirect 추가
);
```

---

## 화면별 스펙

### 1. 학번 인증 화면 (auth/screens/auth_screen.dart)

라우트: `/auth` → 인증 완료 시 `/home`

유효성 검사 (버튼 탭 시 트리거):
- 이름: 필수, 2자 이상
- 학과: 필수
- 학번: 필수, 숫자 7자리 (keyboardType: TextInputType.number)

Phase 1 동작:
- 학번 `2411206` → 성공, /home 이동
- 나머지 → 필드 에러 표시 (실패 메시지 없이)

UI:
- 상단: 파란 그라디언트 배너 (UC 로고 + 학번 인증 카드)
- 폼 카드: 배너와 -24px overlap
- 제출: AppButton (노란 accent)
- 안내사항: 🚩 헤더 + bullet 3개, 연회색 배경
- 하단: "인증에 문제가 있나요?" 링크

### 2. 메인 홈 화면 (home/screens/home_screen.dart)

라우트: `/home`

구성 (위 → 아래):
1. UCHeader (설정 아이콘 탭 → 설정 바텀시트)
2. 학생 인사 배너 (파란 카드)
    - "모바일 학생증" 탭 → qr_flutter로 QR 표시
3. 빠른 실행 2열 그리드
    - 시간표 / 식단표 → showModalBottomSheet
4. 바로가기 4열 그리드 (8개 항목)
    - 외부 링크 → url_launcher
    - 항목: 홈페이지 / 도서관 / 학사시스템 / 온라인출결 /
      통학버스 / 학생생활관 / 클로버시스템 / 캠퍼스맵
5. 공지사항 탭 4개 + 리스트 (Phase 1: Mock)
    - 탭: 공지사항 / 학과소식 / 학과공지 / 장학·취업

### 3. 마이페이지 ← 현재 완전 빈 화면, 반드시 구현

구성:
- 학생증 카드: 아바타 + 이름/학과/학년/학번 + "모바일 학생증 보기"
- 학사 정보: 학적 정보 조회 / 수강 신청 현황 / 성적 확인
- 앱 설정: 알림(Switch) / 언어(DropdownButton) / 다크모드(Switch)
  → 설정값 shared_preferences 저장
- 기타: 공지사항 / 이용약관 / 개인정보처리방침 / 버전 정보 / 로그아웃
  → 로그아웃: AppColors.error 텍스트, 탭 시 확인 다이얼로그 필수

메뉴 아이템: height 52px, 좌(아이콘+라벨) / 우(chevron 또는 값)

### 4. 시간표 바텀시트 (timetable/timetable_sheet.dart)

showModalBottomSheet, 드래그 최대 90% 높이

그리드:
- 열: 월~금 / 행: 09:00~17:00 (1시간 단위)
- 블록 높이 = (수업분 / 60) × 행 높이
- 색상: AppColors.timetableColors[colorIndex % 6]
- 블록 탭 → SnackBar 또는 다이얼로그로 상세 정보

텍스트 우선순위 (좁을 때): 과목명 → 강의실 → 교수명(숨김)

### 5. 식단표 바텀시트 (meal/meal_sheet.dart)

조식 / 중식 / 석식 섹션 (운영 시간 우측 정렬)
카드 배경: Color(0xFFFFF8EE) (크림색)
메뉴 bullet: AppColors.accent 작은 원형 dot
하단: 알레르기 안내 노란 박스 고정

### 6. 설정 바텀시트 (settings/settings_sheet.dart)

showModalBottomSheet (드래그 핸들 포함)
항목: 알림(Switch, 기본 on) / 다크모드(Switch, 기본 off) / 언어(DropdownButton, 기본 한국어)
설정값 shared_preferences 저장

---

## 코딩 컨벤션

- 파일명: snake_case.dart
- 클래스명: PascalCase / 변수·함수: camelCase
- const 생성자: 가능한 모든 위젯에 적용
- async 후 context 사용 시 mounted 체크 필수
- Phase 2 전환 코드: `// TODO(Phase 2): Mock → Api로 교체` 주석 필수

주석 규칙:
- 파일 상단: 역할을 한 줄로 (예: `// 역할: 학번 인증 화면. 이름·학과·학번 입력 후 홈으로 이동.`)
- 함수: 무엇을 하고 왜 이렇게 만들었는지
- 변수명으로 의미가 명확하면 주석 생략

---

## 개발자 체크리스트

```
화면 완성 전 반드시 확인:

[ ] AppColors 상수만 사용 (색상 하드코딩 없음)
[ ] AppTextStyles 상수만 사용 (크기 하드코딩 없음)
[ ] AppSpacing 상수만 사용 (간격 하드코딩 없음)
[ ] Phase 1: Mock 데이터만 사용 (http/dio 호출 없음)
[ ] 학번 입력: TextInputType.number 적용
[ ] 모바일 학생증: qr_flutter 사용
[ ] 외부 링크: url_launcher 사용
[ ] 설정값: shared_preferences 저장
[ ] 마이페이지: 빈 화면 아님, 전체 구현
[ ] TODO(Phase 2) 주석 표시
[ ] const 생성자 적용 여부 확인
[ ] async 후 mounted 체크
```

---

## Claude 질문 시 토큰 절약 규칙

첨부하면 안 되는 파일:
pubspec.lock, ios/ 폴더, android/ 폴더,
.gitignore, .metadata, analysis_options.yaml

관련 파일만 골라서 첨부:
- 식단 관련 → meal_sheet.dart 만
- 라우터 관련 → app_router.dart 만
- 인증 관련 → auth_screen.dart + auth_provider.dart 만

새 채팅 시작 템플릿:
```
UC Info Flutter 앱 개발 중이야. (Phase 1 — UI + Mock)
CLAUDE.md 참고해서 도와줘.
지금 [작업 내용] 하려는데 관련 파일은 아래야.
[파일 1~2개만]
```

