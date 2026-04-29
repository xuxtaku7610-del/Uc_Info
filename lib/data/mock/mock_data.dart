// lib/data/mock/mock_data.dart
// 역할: Phase 1 UI 개발용 Mock 데이터. Phase 2에서 API 응답으로 대체된다.

import 'package:university_portal_flutter/data/models/meal_data.dart';
import 'package:university_portal_flutter/data/models/notice_item.dart';
import 'package:university_portal_flutter/data/models/schedule_item.dart';
import 'package:university_portal_flutter/data/models/user.dart';

// 인증된 학생 정보 (테스트용 Mock 유저 3명)
const mockUser = User(
  name: '홍길동',
  department: '컴퓨터공학과',
  year: 3,
  studentId: '2411206',
);

const mockUser2 = User(
  name: 'John',
  department: 'Computer Engineering',
  year: 2,
  studentId: '2411207',
);

const mockUser3 = User(
  name: '박수민',
  department: '전기공학과',
  year: 1,
  studentId: '2411208',
);

// 주간 시간표 (2026학년도 1학기)
final mockSchedule = [
  const ScheduleItem(subject: '데이터베이스', day: '월', startHour: 9,  endHour: 11, room: '공학관 301', color: 0),
  const ScheduleItem(subject: '알고리즘',    day: '화', startHour: 10, endHour: 12, room: '공학관 205', color: 1),
  const ScheduleItem(subject: '모바일프로그래밍', day: '수', startHour: 13, endHour: 15, room: '공학관 402', color: 2),
  const ScheduleItem(subject: '운영체제',    day: '목', startHour: 9,  endHour: 11, room: '공학관 301', color: 3),
  const ScheduleItem(subject: '캡스톤디자인', day: '금', startHour: 14, endHour: 17, room: '공학관 501', color: 4),
];

// 공지사항 (탭별 카테고리: notice / dept_news / dept_notice / scholarship)
const mockNotices = [
  // 공지사항
  NoticeItem(title: '2026학년도 1학기 수강신청 최종 안내', date: '04.28', category: 'notice'),
  NoticeItem(title: '2026-1학기 수강정정기간 안내', date: '04.27', category: 'notice'),
  NoticeItem(title: '교내 체육대회 일정 안내', date: '04.20', category: 'notice'),
  NoticeItem(title: '신입생 학생증(모바일) 발급 안내', date: '04.12', category: 'notice'),
  // 학과소식
  NoticeItem(title: '컴퓨터공학과 졸업작품 전시회 개최', date: '04.26', category: 'dept_news'),
  NoticeItem(title: '2026 ICT 융합 프로젝트 우수상 수상', date: '04.15', category: 'dept_news'),
  NoticeItem(title: '산업체 연계 현장실습 참가자 모집', date: '04.08', category: 'dept_news'),
  // 학과공지
  NoticeItem(title: '캡스톤 디자인 중간 발표 일정 공고', date: '04.25', category: 'dept_notice'),
  NoticeItem(title: '서버 실습실(433호) 유지보수 작업 안내', date: '04.15', category: 'dept_notice'),
  NoticeItem(title: '2학년 전공선택 상담 일정 공고', date: '04.10', category: 'dept_notice'),
  // 장학·취업
  NoticeItem(title: '1학기 국가장학금 2차 신청 기간 안내', date: '04.24', category: 'scholarship'),
  NoticeItem(title: '교내 근로장학생 추가 선발 공고', date: '04.18', category: 'scholarship'),
  NoticeItem(title: '성적 우수 장학금 대상 오리엔테이션', date: '04.10', category: 'scholarship'),
  NoticeItem(title: '하반기 취업 특강 신청 안내', date: '04.05', category: 'scholarship'),
];

// 오늘의 식단
const mockMeal = MealData(
  date: '2026년 4월 29일 화요일',
  breakfast: MealSection(
    time: '08:00-09:30',
    items: ['쌀밥', '김치찌개', '계란후라이', '배추김치', '과일'],
  ),
  lunch: MealSection(
    time: '11:30-13:30',
    items: ['차돌박이덮밥', '된장국', '잡채', '깍두기', '요구르트'],
  ),
  dinner: MealSection(
    time: '17:00-19:00',
    items: ['돈까스', '흰밥', '우동국', '샐러드', '단무지'],
  ),
);
