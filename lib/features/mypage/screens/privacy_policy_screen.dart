// lib/features/mypage/screens/privacy_policy_screen.dart
// 역할: 개인정보처리방침 화면. 수집 항목, 목적, 보유 기간, 삭제 요청 방법 등을 명시한다.
//       Play 스토어에 등록한 웹 방침(Notion)과 같은 내용을 유지해야 한다.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

/// 개인정보처리방침 전문을 보여주는 화면.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('개인정보처리방침', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '시행일: 2026년 10월 8일',
              style: AppTextStyles.caption.copyWith(color: context.textHint),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'UC Info 개발팀(이하 "개발팀")은 울산과학대학교 재학생을 위한 정보 앱 "UC Info"를 운영하며, 이용자의 개인정보를 소중히 다루고 관련 법령을 준수합니다.',
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: '1. 수집하는 개인정보 항목',
              content: '• 학생 인증 시 수집·확인: 이름, 학번, 소속 학과, 학년 (필수)\n'
                  '• 서비스 이용 중 서버에 저장: 수강신청(개설과목 담기) 내역, 공지사항 열람 기록\n'
                  '• 이용자의 기기에만 저장(서버로 전송되지 않음): 로그인 인증 토큰(보안 저장소), 알림함 내역, 화면 설정\n'
                  '• 자동 생성: 서비스 운영 과정에서 접속 일시 등 서버 접속 기록이 기록될 수 있음\n'
                  '• 위치, 연락처, 사진, 마이크, 카메라 등 기기 권한이 필요한 정보는 수집하지 않음',
            ),
            _buildSection(
              title: '2. 수집 및 이용 목적',
              content: '• 학생 본인 확인(인증) 및 로그인 상태 유지\n'
                  '• 학과·학년에 맞는 공지사항, 학사일정, 장학금, 시간표, 식단 등 맞춤 정보 제공\n'
                  '• 수강신청(개설과목 선택) 처리 및 시간표 제공\n'
                  '• 공지사항 열람 여부 확인 및 미확인 공지 안내\n'
                  '• 서비스 운영, 장애 대응 및 부정 이용 방지',
            ),
            _buildSection(
              title: '3. 보유 및 이용 기간',
              content: '• 서비스를 이용하는 기간 동안 보유합니다.\n'
                  '• 이용자가 삭제를 요청하거나 서비스가 종료되면 지체 없이 파기합니다.\n'
                  '• 관련 법령에 따라 보존해야 하는 정보는 해당 기간 동안만 별도 보관 후 파기합니다.',
            ),
            _buildSection(
              title: '4. 제3자 제공 및 처리 위탁',
              content: '• 개인정보를 제3자에게 제공하지 않습니다. (법령에 따른 적법한 요청이 있는 경우 제외)\n'
                  '• 개인정보 처리 업무를 외부에 위탁하지 않습니다.',
            ),
            _buildSection(
              title: '5. 파기 절차 및 방법',
              content: '• 서버에 저장된 개인정보는 삭제 요청이 확인되면 데이터베이스에서 삭제합니다.\n'
                  '• 기기에 저장된 정보는 로그아웃하면 인증 토큰이 삭제되고, 앱을 삭제하면 나머지 정보도 함께 삭제됩니다.',
            ),
            _buildSection(
              title: '6. 이용자의 권리와 삭제 요청 방법',
              content: '• 이용자는 언제든지 개인정보의 열람, 정정, 삭제, 처리 정지를 요청할 수 있습니다.\n'
                  '• chr010206@naver.com 으로 "UC Info 계정 삭제 요청"이라는 제목의 이메일을 보내고, 본문에 이름·학과·학번을 적어 주세요.\n'
                  '• 본인 확인 후 10일 이내에 처리하고 결과를 이메일로 알려드립니다.\n'
                  '• 삭제 대상: 이름, 학번, 학과, 학년, 수강신청 내역, 공지 열람 기록 (추가로 보관하는 데이터 없음)',
            ),
            _buildSection(
              title: '7. 안전성 확보 조치',
              content: '• 앱과 서버 간 통신은 HTTPS로 암호화됩니다.\n'
                  '• 로그인 인증 토큰은 기기의 보안 저장소에 저장됩니다.\n'
                  '• 개인정보 접근은 서비스 운영에 필요한 최소한의 인원으로 제한합니다.',
            ),
            _buildSection(
              title: '8. 아동의 개인정보',
              content: '• 서비스는 대학 재학생을 대상으로 하며, 만 14세 미만 아동의 개인정보를 의도적으로 수집하지 않습니다.',
            ),
            _buildSection(
              title: '9. 문의처',
              content: '• 운영: UC Info 개발팀\n'
                  '• 이메일: chr010206@naver.com',
            ),
            _buildSection(
              title: '10. 방침의 변경',
              content: '• 방침이 변경되면 시행일과 변경 내용을 앱과 웹 페이지에 게시합니다.',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// 제목과 본문으로 이루어진 방침 항목 하나를 만든다.
  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.xs),
          Text(content, style: AppTextStyles.body1),
        ],
      ),
    );
  }
}
