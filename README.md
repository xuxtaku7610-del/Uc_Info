# UC Info — 울산과학대학교 학생 포털 앱

울산과학대학교(Ulsan College) 재학생을 위한 모바일 정보 앱입니다.
학번 인증, 시간표, 식단표, 공지사항 등 학교생활에 필요한 정보를 한 곳에서 제공합니다.

---

## 주요 기능

- **학번 인증** — 이름·학과·학번으로 학생 신원 확인 및 서비스 접근
- **메인 대시보드** — 개인화된 인사말, 모바일 학생증, 바로가기 메뉴
- **주간 시간표** — 2026학년도 1학기 수강 과목을 색상 블록으로 시각화
- **오늘의 식단** — 조식·중식·석식 메뉴 및 운영 시간 확인
- **공지사항** — 학교·학과·장학/취업 공지 탭별 조회
- **학점 시뮬레이터** — 기말고사 목표 점수 역산 계산기
- **졸업 요건 체크리스트** — 카테고리별 이수 학점 및 필수 과목 진행 현황
- **공지 번역** — 한국어 공지를 영어로 번역 (외국인 유학생 지원)
- **설정** — 알림, 다크 모드, 언어 설정

---

## 기술 스택

| 항목 | 내용 |
|---|---|
| 프레임워크 | Flutter (Dart) |
| 상태 관리 | flutter_riverpod ^2.6.1 |
| 라우팅 | go_router ^14.6.0 |
| QR 코드 | qr_flutter ^4.1.0 |
| 로컬 저장소 | shared_preferences ^2.3.0 |
| 외부 링크 | url_launcher ^6.3.1 |
| 번역 API | DeepL API (http 패키지) |
| 최소 Dart SDK | ^3.11.0 |

---

## 시작하기

### 사전 요구사항

- Flutter SDK 설치 ([공식 가이드](https://docs.flutter.dev/get-started/install))
- Dart SDK ^3.11.0 이상

### 설치 및 실행

```bash
# 1. 레포지토리 클론
git clone https://github.com/xuxtaku7610-del/Uc_Info.git
cd Uc_Info

# 2. 패키지 설치
flutter pub get

# 3. 앱 실행
flutter run
```

### 빌드

```bash
# Android APK
flutter build apk --release

# iOS (macOS 필요)
flutter build ios --release
```

---

## 프로젝트 구조

```
lib/
├── core/
│   └── theme/          # 색상, 텍스트 스타일 등 디자인 토큰
├── models/             # 데이터 모델 클래스
├── screens/            # 각 화면 위젯
│   ├── auth_screen.dart
│   ├── main_screen.dart
│   ├── grade_simulator_screen.dart
│   ├── graduation_checklist_screen.dart
│   └── notice_translation_screen.dart
├── services/           # API 통신 클래스
│   └── translation_service.dart
└── main.dart
```

---

## 디자인 토큰

| 용도 | 색상 | 코드 |
|---|---|---|
| Primary (브랜드) | 파란색 | `#2563EB` |
| Accent (강조) | 노란색 | `#F59E0B` |
| Background | 연회색 | `#F4F6FA` |
| Error | 빨간색 | `#EF4444` |

---

## 개발 현황

- [x] 학번 인증 화면 (유효성 검사 포함)
- [x] 메인 대시보드
- [x] 주간 시간표
- [x] 오늘의 식단
- [x] 공지사항
- [x] 설정 패널
- [x] 학점 시뮬레이터
- [x] 졸업 요건 체크리스트
- [x] 공지사항 한→영 번역
- [ ] 실제 학교 API 연동 (Phase 2)
- [ ] 챗봇 기능
- [ ] 캠퍼스 맵 고도화

---

## 기여자

| 이름 | 역할 |
|---|---|
| YoungSooPark | 기획 및 개발 |

---

## 라이선스

본 프로젝트는 울산과학대학교 내부 프로젝트로, 외부 배포를 제한합니다.
