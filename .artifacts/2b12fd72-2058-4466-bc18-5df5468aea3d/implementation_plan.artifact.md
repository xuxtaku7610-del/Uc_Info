# 더미데이터 완전 삭제 및 API 연동 전환 계획

앱 내의 모든 더미데이터(`mock_data.dart`)를 삭제하고, 실제 백엔드 API를 호출하여 데이터를 보여주는 방식으로 완전히 전환합니다.

## 제안된 변경 사항

### 1. 데이터 레이어 (Repositories)

기존의 Mock 구현체를 제거하고, 모든 데이터를 API로부터 가져오도록 새로운 Repository들을 구현합니다.

*   [NEW] `MealRepository` & `ApiMealRepository`: 식단표 정보 조회
*   [NEW] `ScheduleRepository` & `ApiScheduleRepository`: 시간표 정보 조회
*   [MODIFY] `TranslationRepository`: `MockTranslationRepository`를 제거하고 API 기반으로 변경 준비 (우선 인터페이스만 남기고 Mock 제거)

### 2. 상태 관리 (Providers)

각 피처별로 데이터를 관리하고 API 요청을 처리할 Provider들을 생성합니다.

*   [NEW] `user_provider.dart`: 현재 로그인한 사용자 정보 관리
*   [NEW] `meal_provider.dart`: 식단 데이터 관리
*   [NEW] `schedule_provider.dart`: 시간표 데이터 관리

### 3. UI 레이어 (Screens & Widgets)

더미데이터를 직접 참조하던 위젯들을 수정하여 Provider로부터 데이터를 받도록 변경합니다.

*   [MODIFY] `NoticeDetailScreen`: API를 통해 상세 내용을 가져오거나 리스트 상태에서 캐시된 데이터를 사용
*   [MODIFY] `MealSheet`: `mealProvider` 사용
*   [MODIFY] `TimetableSheet`: `scheduleProvider` 사용
*   [MODIFY] `MypageScreen` & `StudentBanner`: `userProvider` 사용
*   [MODIFY] `NoticeTranslationScreen`: Mock Repository 의존성 제거

### 4. 정리 (Clean up)

*   [DELETE] `lib/data/mock/mock_data.dart`
*   [MODIFY] `TranslationRepository`: Mock 클래스 삭제

## 검증 계획

### 자동화 테스트
- 각 API Repository의 응답 파싱 및 에러 처리 유닛 테스트

### 수동 검증
- 각 화면(홈, 마이페이지, 공지상세, 식단, 시간표)에서 실제 데이터가 올바르게 로드되는지 확인
- 데이터 로딩 중 스켈레톤 또는 인디케이터 표시 확인
- API 호출 실패 시 에러 메시지 노출 확인
