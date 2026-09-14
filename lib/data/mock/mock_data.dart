import '../models/notice_item.dart';
import '../models/schedule_item.dart';
import '../models/meal_data.dart';
import '../models/banner_item.dart';
import '../models/academic_event.dart';
import '../models/scholarship.dart';
import '../models/course_offering.dart';

class MockData {
  // 1. 공지사항 더미 데이터
  static final List<NoticeItem> notices = [
    NoticeItem(
      id: 1,
      category: 'ACADEMIC',
      date: '09.10',
      title: '2026학년도 2학기 수강신청 안내',
      content: '수강신청 기간은 9월 10일부터 9월 15일까지입니다.',
    ),
    NoticeItem(
      id: 2,
      category: 'DEPARTMENT',
      date: '09.09',
      title: '컴퓨터공학과 학술제 개최 공지',
      content: '이번 학술제는 대강당에서 열립니다.',
    ),
    NoticeItem(
      id: 3,
      category: 'EVENT',
      date: '09.08',
      title: '전공필수 과목 강의실 변경 안내',
      content: '운영체제 과목 강의실이 302호에서 405호로 변경되었습니다.',
    ),
  ];

  // 2. 시간표 더미 데이터
  static final List<ScheduleItem> schedules = [
    const ScheduleItem(
      enrollmentId: 101,
      subject: '운영체제',
      day: '월',
      startHour: 9,
      endHour: 11,
      room: 'IT관 405호',
      professor: '박교수',
      color: 0,
    ),
    const ScheduleItem(
      enrollmentId: 102,
      subject: '알고리즘',
      day: '화',
      startHour: 13,
      endHour: 15,
      room: '제1공학관 201호',
      professor: '이교수',
      color: 1,
    ),
  ];

  // 3. 식단 더미 데이터
  static const MealData todayMeal = MealData(
    date: '2026-09-12',
    lunch: MealSection(time: '12:00-13:30', items: ['기장밥', '돈육김치찌개', '계란말이']),
    dinner: MealSection(time: '17:30-19:00', items: ['카레라이스', '미소된장국', '단무지']),
  );

  // 4. 배너 더미 데이터
  static final List<BannerItem> banners = [
    BannerItem(
      id: 1,
      title: '2026학년도 하계 해외 연수 모집',
      subtitle: '글로벌 역량 강화를 위한 해외 연수 프로그램을 확인하세요.',
      status: 'ACTIVE',
    ),
    BannerItem(
      id: 2,
      title: '취업 성공 패키지 참가자 모집',
      subtitle: '취업 준비생들을 위한 맞춤형 컨설팅 및 교육 지원 안내',
      status: 'ACTIVE',
    ),
  ];

  // 5. 학사일정 더미 데이터
  static final List<AcademicEvent> academicEvents = [
    AcademicEvent(
      id: 1,
      title: '2학기 개강',
      startDate: DateTime(2026, 9, 1),
      category: 'ACADEMIC',
    ),
    AcademicEvent(
      id: 2,
      title: '추석 연휴',
      startDate: DateTime(2026, 9, 21),
      endDate: DateTime(2026, 9, 23),
      category: 'VACATION',
    ),
    AcademicEvent(
      id: 3,
      title: '중간고사 기간',
      startDate: DateTime(2026, 10, 20),
      endDate: DateTime(2026, 10, 26),
      category: 'EXAM',
    ),
  ];

  // 6. 장학금 더미 데이터
  static final List<Scholarship> scholarships = [
    Scholarship(
      id: 1,
      title: '2026학년도 성적 우수 장학금',
      type: 'GRADE',
      deadline: DateTime.now().add(const Duration(days: 5)),
    ),
    Scholarship(
      id: 2,
      title: '울산 지역 인재 육성 장학금',
      type: 'REGIONAL',
      deadline: DateTime.now().add(const Duration(days: 12)),
    ),
  ];

  // 7. 개설과목 더미 데이터
  static final List<CourseOffering> courseOfferings = [
    CourseOffering(id: 201, subject: '모바일 앱 개발', day: '목', startHour: 10, endHour: 12, room: 'IT관 204호', professor: '최교수'),
    CourseOffering(id: 202, subject: '인공지능 개론', day: '금', startHour: 13, endHour: 15, room: '제1공학관 101호', professor: '정교수'),
    CourseOffering(id: 203, subject: '데이터 통신', day: '월', startHour: 15, endHour: 17, room: 'IT관 303호', professor: '강교수'),
  ];
}
