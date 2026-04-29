import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_theme.dart';
import 'widgets/notice_item.dart';
import 'widgets/quick_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String studentQrData = 'student:20240001:honggildong';

  String activeNoticeType = 'all';

  int currentBottomIndex = 0;

  final quickMenus = const <QuickMenuItem>[
    QuickMenuItem(title: 'UC 포털', icon: Icons.school_outlined),
    QuickMenuItem(title: 'x-Class', icon: Icons.menu_book_outlined),
    QuickMenuItem(title: '온라인출결', icon: Icons.how_to_reg_outlined),
    QuickMenuItem(title: '도서관', icon: Icons.local_library_outlined),
    QuickMenuItem(title: '통학버스', icon: Icons.directions_bus_outlined),
    QuickMenuItem(title: '식단안내', icon: Icons.restaurant_outlined),
    QuickMenuItem(title: '취업지원', icon: Icons.work_outline),
    QuickMenuItem(title: '캠퍼스맵', icon: Icons.map_outlined),
  ];

  final notices = const <NoticeItem>[
    NoticeItem(day: '28', title: '2026학년도 1학기 수강신청 최종 안내', type: 'notice'),
    NoticeItem(day: '27', title: '2026-1학기 수강정정기간 안내', type:'notice'),
    NoticeItem(day: '25', title: '컴퓨터공학과 캡스톤 디자인 프로젝트 공지', type: 'dept'),
    NoticeItem(day: '24', title: '1학기 국가장학금 2차 신청 기간 안내', type: 'scholarship'),
    NoticeItem(day: '20', title: '교내 체육대회 일정', type: 'notice'),
    NoticeItem(day: '18', title: '교내 근로장학생 추가 선발 공고', type: 'scholarship'),
    NoticeItem(day: '15', title: '서버 실습실(433호) 유지보수 작업 안내', type: 'dept'),
    NoticeItem(day: '12', title: '신입생 학생증(모바일) 발급 안내', type: 'notice'),
    NoticeItem(day: '10', title: '성적 우수 장학금 대상 오리엔테이션', type: 'scholarship'),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleNotices = notices
        .where((e) => activeNoticeType == 'all' ? true : e.type == activeNoticeType)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildStudentCard(),
              const SizedBox(height: 16),
              _buildFeatureCards(),
              const SizedBox(height: 16),
              _buildQuickMenus(),
              const SizedBox(height: 16),
              _buildNoticeBoard(visibleNotices),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.brandBlue,
        unselectedItemColor: const Color(0xFF9CA3AF),
        onTap: (index) {
          setState(() => currentBottomIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: '알림'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이'),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.brandBlue,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: const Text(
            'UC',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ULSAN COLLEGE', style: TextStyle(fontSize: 13, color: Color(0xFF777772))),
              Text('울산과학대학교', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
            ],
          ),
        ),

        IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
      ],
    );
  }

  Widget _buildStudentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C5282), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('학생증', style: TextStyle(color: Color(0x99FFFFFF))),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('홍길동', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('컴퓨터공학부 · 2024학번', style: TextStyle(color: Color(0xCCFFFFFF))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 78,
                height: 78,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImageView(
                  data: studentQrData,
                  version: QrVersions.auto,
                  gapless: false,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1E3A5F),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '상태: 재학 (모바일 학생증 활성화됨)',
            style: TextStyle(color: Color(0xAAFFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(
          child: _featureCard(
            title: '시간표',
            subtitle: '이번 주 수업 확인',
            icon: Icons.schedule,
            onTap: () => _openTodoSheet('시간표 상세'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _featureCard(
            title: '식단표',
            subtitle: '오늘 메뉴 확인',
            icon: Icons.restaurant_menu,
            onTap: () => _openTodoSheet('식단표 상세'),
          ),
        ),
      ],
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 156,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.brandBlue, size: 30),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.brandBlue, fontSize: 18)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF8B95A5))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenus() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quickMenus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = quickMenus[index];
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openTodoSheet('${item.title} 기능 준비중'),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Icon(item.icon, color: AppTheme.brandBlue),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoticeBoard(List<NoticeItem> visibleNotices) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _tabButton(id: 'all', label: '전체'),
              _tabButton(id: 'dept', label: '학과'),
              _tabButton(id: 'scholarship', label: '장학'),
            ],
          ),
          const Divider(height: 1),

          ...visibleNotices.map(
                (item) => ListTile(
              dense: true, 
              title: Text(item.title, style: const TextStyle(fontSize: 13)),
              leading: Text(item.day, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.brandBlue)),
              trailing: const Icon(Icons.chevron_right_rounded), 
              onTap: () => _openTodoSheet('${item.title} 상세 정보'),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Text(
              '더 많은 공지사항 보기',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({required String id, required String label}) {
    final selected = activeNoticeType == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => activeNoticeType = id),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppTheme.brandYellow : const Color(0xFFE5E7EB),
                width: selected ? 3 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? AppTheme.brandBlue : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }

  void _openTodoSheet(String title) {
    String contentText = '해당 항목의 상세 데이터를 API에서 불러오는 중입니다.';

    if (title.contains('시간표')) {
      contentText = '화요일: 안드로이드 앱-402 (09:00 - 13:00)\n화요일: c# -412 (14:00 - 17:00)\n화요일: 클라우드-433 (18:00 - 21:00)';
    } else if (title.contains('식단표')) {
      contentText = '[오늘의 학식]\n데일리: 쌀밥, 김치어묵국, 고추잡채, 맛살마카로니샐러드 (5,000원)\n푸드코트: 파채숯불제육덮밥 (8,000원), 나가사끼 짬뽕(7,000),등심돈까스(7,000)';
    } else if (title.contains('상세 정보')) {
      contentText = '게시일: 2026.03.29\n\n공지사항 본문 내용이 여기에 표시됩니다. 첨부파일 다운로드 기능을 추가할 수 있습니다.';
    }

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.brandBlue)),
              const SizedBox(height: 16),
              Text(
                contentText,
                style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}