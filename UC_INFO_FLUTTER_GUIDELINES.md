# UC Info Flutter App — 개발 지침서 (Development Guidelines)

> **버전**: 1.0.0  
> **최종 수정**: 2026-04-29  
> **대상**: Flutter 프론트엔드 개발자  
> **상태**: UI 전용 구현 단계 (API 연동 추후 진행)

---

## 1. 프로젝트 개요 (Project Overview)

울산과학대학교(Ulsan College) 학생 전용 모바일 정보 앱.  
Flutter(iOS/Android 공통)로 UI를 먼저 완성하고, 이후 웹과 동일한 REST API에 연동한다.

| 항목 | 내용 |
|---|---|
| 플랫폼 | iOS / Android (Flutter) |
| 상태 관리 | Riverpod (권장) |
| 라우팅 | GoRouter |
| API 연동 시점 | Phase 2 (웹과 동시 연동) |
| 디자인 기준 | 첨부 UI 시안 (uc_info_ui.pdf) |

---

## 2. 디자인 토큰 (Design Tokens)

### 색상 팔레트

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Primary — 브랜드 파란색 (헤더, 버튼 배경, 배지)
  static const Color primary       = Color(0xFF2F5BE8);
  static const Color primaryLight  = Color(0xFFEAF0FF);

  // Accent — 강조 노란색 (CTA 버튼, 모바일 학생증 버튼)
  static const Color accent        = Color(0xFFFFC72C);
  static const Color accentDark    = Color(0xFFE6A800); // pressed state

  // Neutral
  static const Color background    = Color(0xFFF4F6FA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color divider       = Color(0xFFEAECF0);
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFFADB5BD);

  // Semantic
  static const Color error         = Color(0xFFE84040);
  static const Color errorLight    = Color(0xFFFFF0F0);
  static const Color success       = Color(0xFF22C55E);
  static const Color warning       = Color(0xFFFB923C);

  // 시간표 블록 색상 (주간 시간표 과목별)
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

### 타이포그래피

```dart
// lib/core/theme/app_text_styles.dart
// 기본 폰트: Pretendard (한국어 최적화)
// pubspec.yaml에 google_fonts 또는 로컬 폰트 추가 필요

class AppTextStyles {
  static const TextStyle heading1  = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const TextStyle heading2  = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle heading3  = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle body1     = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static const TextStyle body2     = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle caption   = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle label     = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
  static const TextStyle buttonText= TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
}
```

### 간격 및 모서리

```dart
// lib/core/theme/app_spacing.dart

class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;

  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 20.0;
  static const double radiusFull = 999.0; // pill shape (CTA 버튼)
}
```

---

## 3. 폴더 구조 (Project Structure)

```
lib/
├── core/
│   ├── theme/              # 색상, 타입, 간격 토큰
│   ├── router/             # GoRouter 라우트 정의
│   ├── constants/          # 앱 상수 (API base URL 등)
│   └── utils/              # 공통 유틸 (날짜 포맷 등)
│
├── data/
│   ├── models/             # 데이터 모델 (User, Schedule, Meal 등)
│   ├── mock/               # ★ UI 단계용 목(Mock) 데이터
│   └── repositories/       # 인터페이스만 정의 (구현은 Phase 2)
│
├── features/
│   ├── auth/               # 학번 인증 화면
│   │   ├── screens/
│   │   └── widgets/
│   ├── home/               # 메인 화면
│   │   ├── screens/
│   │   └── widgets/
│   ├── timetable/          # 주간 시간표
│   ├── meal/               # 식단표
│   ├── notice/             # 공지사항
│   └── settings/           # 설정 (알림, 다크 모드, 언어)
│
└── shared/
    ├── widgets/            # 재사용 위젯 (AppButton, AppTextField 등)
    └── providers/          # Riverpod 공통 provider
```

> **규칙**: feature 폴더는 화면 단위로 분리. 다른 feature의 widget을 직접 import하지 않는다.  
> 공통으로 쓰는 것은 반드시 `shared/widgets/`로 이동시킨다.

---

## 4. 공통 위젯 명세 (Shared Widgets)

### 4-1. AppButton (Primary CTA)

UI 시안의 노란 `학번 인증하기 〉` 버튼과 동일한 스타일.

```dart
// lib/shared/widgets/app_button.dart

AppButton(
  label: '학번 인증하기',
  trailingIcon: Icons.chevron_right,
  onPressed: () {},
  // isLoading: false,  // 로딩 상태 스피너 내장
)
```

- 배경색: `AppColors.accent`
- 텍스트: `AppColors.textPrimary`, bold
- 모서리: `radiusFull` (완전 둥근 pill 모양)
- 높이: 54px 고정
- 로딩 시 `CircularProgressIndicator` 중앙 표시 + 버튼 비활성화

### 4-2. AppTextField

```dart
AppTextField(
  label: '학과',
  placeholder: '예: 컴퓨터공학과',
  isRequired: true,    // "(필수)" 표시 + 빨간 테두리 유효성 검사
  errorText: '학과를 입력해주세요.',
  controller: controller,
)
```

- 기본 테두리: `AppColors.divider`
- 포커스 테두리: `AppColors.primary`
- 오류 상태: `AppColors.error` 테두리 + 하단 에러 텍스트 (빨간색)
- 라벨 우측에 `(필수)` 표시는 `AppColors.error`로 렌더링

### 4-3. UCHeader

모든 화면 상단에 공통으로 사용되는 UC 로고 + 학교명 헤더.

```dart
UCHeader(showSettings: true)  // 메인 화면은 true, 인증 화면은 false
```

---

## 5. 화면별 명세 (Screen Specifications)

### 5-1. 인증 기본 화면 (AuthScreen)

**라우트**: `/auth`  
**목적**: 최초 실행 시 학번 인증. 인증 완료 후 `/home`으로 이동.

**입력 필드**:

| 필드 | 유효성 규칙 | 오류 메시지 |
|---|---|---|
| 이름 | 필수, 2자 이상 | 이름을 입력해주세요. |
| 학과 | 필수 | 학과를 입력해주세요. |
| 학번 | 필수, 숫자 7자리 | 학번 7자리를 입력해주세요. |

**유효성 검사 트리거**: `학번 인증하기` 버튼 탭 시.  
비어있는 필드만 에러 표시 (입력된 필드는 에러 제거).

**Phase 1 동작 (Mock)**:
- 학번 `2411206` 입력 시 → 성공으로 처리, `/home`으로 이동
- 나머지 → 실패 메시지 없이 에러 표시 (Phase 2에서 API 연동)

**안내사항 섹션**:
- 🚩 아이콘 + "안내사항" 헤더
- bullet 3개: 학번 안내, 이름 안내, 오류 시 안내
- 배경: 연한 회색 카드

---

### 5-2. 메인 화면 (HomeScreen)

**라우트**: `/home`  
**구성 섹션** (위에서 아래):

```
1. UCHeader (설정 아이콘 포함)
2. 학생 인사 배너 (파란 카드 — 이름, 학과/학년/학번, 모바일 학생증 버튼)
3. 빠른 실행 2열 그리드 (시간표, 식단표)
4. 바로가기 4×2 그리드 (8개 항목)
5. 공지사항 탭 + 리스트
```

**바로가기 아이콘 항목**:
홈페이지, 도서관, 학사 시스템, 온라인 출결,  
통학버스, 학생 생활관, 클로버 시스템, 캠퍼스 맵

**공지사항 탭**: `공지사항 / 학과소식 / 학과공지 / 장학·취업`  
탭 전환 시 해당 목록 표시. Phase 1은 Mock 데이터 사용.

---

### 5-3. 설정 Bottom Sheet (SettingsSheet)

**트리거**: 메인 화면 우상단 ⚙ 아이콘 탭  
**표시 방식**: `showModalBottomSheet` (드래그 핸들 포함)

| 항목 | 위젯 | 기본값 |
|---|---|---|
| 알림 | `Switch` | 활성화 |
| 다크 모드 | `Switch` | 비활성화 |
| 언어 설정 | `DropdownButton` | 한국어 |

---

### 5-4. 주간 시간표 Bottom Sheet (TimetableSheet)

**트리거**: 메인 화면 `시간표` 카드 탭  
**표시 방식**: `showModalBottomSheet`, 드래그로 최대 90% 높이까지 확장

**시간표 그리드 규칙**:
- 열: 월~금 (5열)
- 행: 09:00 ~ 17:00 (1시간 단위)
- 수업 블록 높이 = (수업 시간(분) / 60) × 행 높이
- 수업 블록 색상: `AppColors.timetableColors`에서 순환 배정
- 블록 탭 시 상세 정보 툴팁 또는 SnackBar 표시

**텍스트 표시 우선순위** (블록이 좁을 경우):
1. 과목명 (bold)
2. 강의실 (caption)
3. 교수명 (숨김 가능)

---

### 5-5. 식단표 Bottom Sheet (MealSheet)

**트리거**: 메인 화면 `식단표` 카드 탭  
**표시 방식**: `showModalBottomSheet`

**섹션**: 조식 / 중식 / 석식 (각 운영 시간 우측 정렬)  
**배경**: 식사 카드 `Color(0xFFFFF8EE)` (크림색)  
**알레르기 안내**: 하단 고정 노란 박스  
**과목 bullet**: `AppColors.accent` 작은 원형 dot

---

## 6. 상태 관리 (State Management)

### 사용 패키지: Riverpod

```dart
// Phase 1: Mock Provider 예시
// lib/features/auth/providers/auth_provider.dart

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(repository: MockAuthRepository()); // Phase 2에서 실제 Repository로 교체
});
```

**규칙**:
- 모든 비즈니스 로직은 `StateNotifier` 또는 `AsyncNotifier`에.
- UI 위젯에서 직접 `http.get()` 호출 금지.
- Phase 2 전환 시 `MockRepository` → `ApiRepository`만 교체하면 되도록 인터페이스 먼저 정의.

---

## 7. Mock 데이터 명세 (Phase 1)

```dart
// lib/data/mock/mock_data.dart

// 인증된 학생 정보
const mockUser = User(
  name: '홍길동',
  department: '컴퓨터공학과',
  year: 3,
  studentId: '2412000',
);

// 주간 시간표 (2026학년도 1학기)
final mockSchedule = [
  ScheduleItem(subject: '데이터베이스', day: '월', startHour: 9, endHour: 11, room: '공학관 301', color: 0),
  ScheduleItem(subject: '알고리즘',    day: '화', startHour: 10, endHour: 12, room: '공학관 205', color: 1),
  // ... 나머지 항목
];

// 오늘의 식단
final mockMeal = MealData(
  date: '2026년 3월 30일 월요일',
  breakfast: MealSection(time: '08:00-09:30', items: ['쌀밥', '김치찌개', '계란후라이', '배추김치', '과일']),
  lunch:     MealSection(time: '11:30-13:30', items: ['차돌박이덮밥', '된장국', '잡채', '깍두기', '요구르트']),
  dinner:    MealSection(time: '17:00-19:00', items: ['돈까스', '흰밥', '우동국', '샐러드', '단무지']),
);
```

---

## 8. 라우팅 (GoRouter)

```dart
// lib/core/router/app_router.dart

final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    // Bottom Sheet는 라우트 아닌 showModalBottomSheet로 처리
  ],
  redirect: (context, state) {
    // Phase 2: 로그인 여부에 따라 /auth 리다이렉트
    // Phase 1: 항상 통과
    return null;
  },
);
```

---

## 9. API 연동 준비 (Phase 2 대비)

> Phase 1에서는 구현 없이 **인터페이스만** 정의한다.  
> 실제 구현은 웹과 동시에 진행하는 Phase 2에서 작성한다.

```dart
// lib/data/repositories/auth_repository.dart

abstract class AuthRepository {
  Future<User> verifyStudent({
    required String name,
    required String department,
    required String studentId,
  });
}

// Phase 1 구현체 (목 데이터 반환)
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> verifyStudent({...}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 시뮬레이션
    if (studentId == '2411206') return mockUser;
    throw Exception('학번을 확인해주세요.'); // Phase 2에서 API 에러 처리
  }
}
```

**Phase 2 전환 체크리스트**:
- [ ] `MockRepository` → `ApiRepository` 교체 (Riverpod Provider 주입 변경)
- [ ] `lib/core/constants/api_constants.dart`에 base URL 설정
- [ ] HTTP 클라이언트: `dio` 패키지 사용, 인터셉터로 토큰 처리
- [ ] 에러 핸들링: `AppException` 공통 모델 정의

---

## 10. 코딩 컨벤션 (Coding Conventions)

| 항목 | 규칙 |
|---|---|
| 파일명 | `snake_case.dart` |
| 클래스명 | `PascalCase` |
| 변수·함수명 | `camelCase` |
| 상수 | `kConstantName` 또는 `UPPER_SNAKE_CASE` |
| 위젯 분리 기준 | 50줄 초과 또는 재사용 시 별도 파일로 분리 |
| 주석 | 아래 주석 작성 규칙 참고 |
| `const` 사용 | 가능한 모든 위젯에 `const` 생성자 사용 |
| `BuildContext` | `async` 함수에서 `await` 후 context 사용 시 `mounted` 체크 필수 |

---

## 10-1. 코드 주석 작성 규칙

> 이 앱은 학부생 팀이 함께 개발한다. 6개월 후 코드를 다시 봤을 때 본인도, 팀원도 바로 이해할 수 있도록 주석을 작성한다.

### 파일 상단 — 역할 설명

모든 파일 맨 위에 이 파일이 무엇을 하는 파일인지 한 줄로 적는다.

```dart
// lib/features/auth/screens/auth_screen.dart
// 역할: 학번 인증 화면. 이름·학과·학번을 입력받아 유효성 검사 후 홈으로 이동한다.
```

### 클래스 — 무엇을 담당하는지

```dart
// 학번 인증 상태를 관리하는 StateNotifier.
// 인증 성공 시 AuthState.success, 실패 시 AuthState.error로 상태를 바꾼다.
class AuthNotifier extends StateNotifier<AuthState> { ... }
```

### 함수 — 무엇을 하고, 왜 이렇게 만들었는지

```dart
// 학번 인증을 시도한다.
// Why: UI 위젯에서 직접 API를 호출하면 테스트가 어렵기 때문에 Notifier로 분리했다.
Future<void> verifyStudent(String name, String dept, String id) async { ... }
```

### 변수 — 이름만으로 의미가 불분명할 때

```dart
// 6으로 나눈 나머지로 timetableColors 리스트를 순환 배정한다.
// 과목이 7개 이상이어도 색상이 반복될 뿐 오류가 나지 않는다.
final colorIndex = subjectIndex % 6;
```

### Phase 구분 주석 — 나중에 바꿔야 할 코드에 표시

API 연동 시점에 찾기 쉽도록 반드시 아래 형식으로 표시한다.

```dart
// TODO(Phase 2): MockAuthRepository → ApiAuthRepository로 교체
return AuthNotifier(repository: MockAuthRepository());
```

### 주석을 쓰지 않아도 되는 경우

변수명·함수명만으로 의미가 명확한 코드에는 주석을 달지 않는다. 주석이 오히려 노이즈가 된다.

```dart
// ❌ 불필요한 주석
final userName = '홍길동'; // 사용자 이름

// ✅ 이름 자체로 충분
final userName = '홍길동';
```

---

## 11. 접근성 (Accessibility)

- 모든 아이콘 버튼에 `Semantics(label: '...')` 또는 `Tooltip` 적용
- 텍스트 최소 크기 12px (시스템 폰트 스케일 고려)
- 색상만으로 상태를 구분하지 않음 (에러: 빨간 테두리 + 텍스트 동시 표시)
- 한국어가 기본, 향후 영어 지원 대비 `l10n` 패키지 초기 설정 권장

---

## 12. 테스트 전략 (Testing)

| 테스트 유형 | 도구 | 대상 |
|---|---|---|
| Unit Test | `flutter_test` | Repository, Notifier 로직 |
| Widget Test | `flutter_test` | 개별 공통 위젯 (AppButton, AppTextField) |
| Integration | `integration_test` | 인증 → 홈 이동 플로우 |

Phase 1에서는 Widget Test만 필수. Unit/Integration은 Phase 2 진행 전 작성.

---

## 13. 참고 자료

- UI 시안: `uc_info_ui.pdf` (학번 인증 화면, 유효성 검사 화면, 메인 화면, 설정, 시간표, 식단표)
- [Flutter 공식 문서](https://docs.flutter.dev)
- [Riverpod 공식 문서](https://riverpod.dev)
- [GoRouter 공식 문서](https://pub.dev/packages/go_router)
- [Pretendard 폰트](https://github.com/orioncactus/pretendard)
