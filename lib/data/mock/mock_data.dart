import '../models/notice_item.dart';
import '../models/schedule_item.dart';
import '../models/meal_data.dart';

class MockData {
  // 1. 공지사항 더미 데이터
  static final List<NoticeItem> notices = [
    NoticeItem(
      id: 1,
      category: 'notice',
      date: '09.10',
      title: '2026학년도 2학기 수강신청 안내',
      content: '수강신청 기간은 9월 10일부터 9월 15일까지입니다.',
    ),
    NoticeItem(
      id: 2,
      category: 'dept_news',
      date: '09.09',
      title: '컴퓨터공학과 학술제 개최 공지',
      content: '이번 학술제는 대강당에서 열립니다.',
    ),
    NoticeItem(
      id: 3,
      category: 'dept_notice',
      date: '09.08',
      title: '전공필수 과목 강의실 변경 안내',
      content: '운영체제 과목 강의실이 302호에서 405호로 변경되었습니다.',
    ),
  ];

  // 2. 시간표 더미 데이터 (ScheduleItem 모델 기반)
  static final List<ScheduleItem> schedules = [
    const ScheduleItem(
      subject: '운영체제',
      day: '월',
      startHour: 9,
      endHour: 11,
      room: 'IT관 405호',
      professor: '박교수',
      color: 0,
    ),
    const ScheduleItem(
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
}
