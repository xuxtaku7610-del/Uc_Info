// lib/features/grade_simulator/screens/grade_simulator_screen.dart
// 역할: 학점 시뮬레이터(기말고사 목표 점수 역산기) 화면.
// 목표 학점과 현재까지 확보한 점수를 입력하면, 기말고사에서 필요한 최소 점수를 계산해 보여준다.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class GradeSimulatorScreen extends StatefulWidget {
  const GradeSimulatorScreen({super.key});

  @override
  State<GradeSimulatorScreen> createState() => _GradeSimulatorScreenState();
}

class _GradeSimulatorScreenState extends State<GradeSimulatorScreen> {
  // why: 목표 학점(라벨)과 실제 목표 점수를 함께 보여줘야 하므로 Map으로 매핑해 둔다.
  // how: DropdownButton의 value는 이 Map의 key(라벨 문자열)를 그대로 사용한다.
  static const Map<String, double> _gradeOptions = {
    'A+ (95점)': 95,
    'A (90점)': 90,
    'B+ (85점)': 85,
    'B (80점)': 80,
    'C+ (75점)': 75,
    'C (70점)': 70,
    'D+ (65점)': 65,
    'D (60점)': 60,
  };

  // 현재 선택된 목표 학점 라벨. 기본값은 'B+ (85점)'으로 시작한다.
  String _selectedGrade = 'B+ (85점)';

  // why: TextField 입력값을 읽고 초기화하기 위해 항목별 컨트롤러를 별도로 관리한다.
  // 중간고사 점수/비율
  final TextEditingController _midtermScoreController = TextEditingController();
  final TextEditingController _midtermRatioController = TextEditingController();
  // 과제 점수/비율
  final TextEditingController _assignmentScoreController = TextEditingController();
  final TextEditingController _assignmentRatioController = TextEditingController();
  // 출석 점수/비율
  final TextEditingController _attendanceScoreController = TextEditingController();
  final TextEditingController _attendanceRatioController = TextEditingController();
  // 기말고사 비율 (점수 입력란은 없음 — 계산으로 구해야 할 값이기 때문)
  final TextEditingController _finalRatioController = TextEditingController();

  // 계산 결과를 화면에 표시할지 여부 (how: 버튼을 누르기 전에는 결과 카드를 숨긴다)
  bool _hasResult = false;
  // 계산된 '기말고사에 필요한 점수'. 100 초과/0 미만일 수도 있으므로 그대로 저장한다.
  double _requiredFinalScore = 0.0;

  @override
  void dispose() {
    // why: TextEditingController는 해제하지 않으면 메모리 누수가 발생하므로
    // 위젯이 사라질 때 반드시 dispose 해준다.
    _midtermScoreController.dispose();
    _midtermRatioController.dispose();
    _assignmentScoreController.dispose();
    _assignmentRatioController.dispose();
    _attendanceScoreController.dispose();
    _attendanceRatioController.dispose();
    _finalRatioController.dispose();
    super.dispose();
  }

  // 화면 하단에 경고 메시지를 SnackBar로 띄우는 헬퍼 함수.
  // why: 유효성 검사 실패 메시지를 한 곳에서 일관되게 보여주기 위함.
  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // [계산하기] 버튼을 눌렀을 때 실행되는 핵심 로직.
  // how: 1) 입력값 공백 체크 → 2) 숫자 변환 체크 → 3) 점수 범위 체크
  //      → 4) 비율 합계 100% 체크 → 5) 역산 공식으로 필요 점수 계산 → setState로 결과 반영
  void _onCalculatePressed() {
    // 1) 모든 입력란의 텍스트를 가져와 앞뒤 공백을 제거한다.
    final String midtermScoreText = _midtermScoreController.text.trim();
    final String midtermRatioText = _midtermRatioController.text.trim();
    final String assignmentScoreText = _assignmentScoreController.text.trim();
    final String assignmentRatioText = _assignmentRatioController.text.trim();
    final String attendanceScoreText = _attendanceScoreController.text.trim();
    final String attendanceRatioText = _attendanceRatioController.text.trim();
    final String finalRatioText = _finalRatioController.text.trim();

    // why: 빈 값이 하나라도 있으면 계산 자체가 의미가 없으므로 가장 먼저 막는다.
    final bool hasEmptyField = midtermScoreText.isEmpty ||
        midtermRatioText.isEmpty ||
        assignmentScoreText.isEmpty ||
        assignmentRatioText.isEmpty ||
        attendanceScoreText.isEmpty ||
        attendanceRatioText.isEmpty ||
        finalRatioText.isEmpty;

    if (hasEmptyField) {
      _showWarning('모든 항목을 빠짐없이 입력해주세요.');
      return;
    }

    // 2) 문자열을 숫자로 변환한다. 숫자가 아니면 null이 반환된다.
    final double? midtermScore = double.tryParse(midtermScoreText);
    final double? midtermRatio = double.tryParse(midtermRatioText);
    final double? assignmentScore = double.tryParse(assignmentScoreText);
    final double? assignmentRatio = double.tryParse(assignmentRatioText);
    final double? attendanceScore = double.tryParse(attendanceScoreText);
    final double? attendanceRatio = double.tryParse(attendanceRatioText);
    final double? finalRatio = double.tryParse(finalRatioText);

    final bool hasInvalidNumber = midtermScore == null ||
        midtermRatio == null ||
        assignmentScore == null ||
        assignmentRatio == null ||
        attendanceScore == null ||
        attendanceRatio == null ||
        finalRatio == null;

    if (hasInvalidNumber) {
      _showWarning('숫자만 입력해주세요.');
      return;
    }

    // 3) 점수(중간/과제/출석)는 0~100점 범위여야 한다.
    // why: 100점 만점 기준 점수이므로 범위를 벗어난 값은 계산 의미가 없다.
    final bool hasOutOfRangeScore = midtermScore < 0 ||
        midtermScore > 100 ||
        assignmentScore < 0 ||
        assignmentScore > 100 ||
        attendanceScore < 0 ||
        attendanceScore > 100;

    if (hasOutOfRangeScore) {
      _showWarning('점수는 0~100 사이의 값으로 입력해주세요.');
      return;
    }

    // 4) 반영 비율의 합은 정확히 100%여야 한다.
    // how: 부동소수점 오차를 고려해 0.01 이하 차이는 100%로 간주한다.
    final double ratioSum =
        midtermRatio + assignmentRatio + attendanceRatio + finalRatio;

    if ((ratioSum - 100).abs() > 0.01) {
      _showWarning('반영 비율의 합이 100%가 되어야 합니다. (현재 ${ratioSum.toStringAsFixed(1)}%)');
      return;
    }

    // why: 기말고사 비율이 0%면 역산 공식에서 0으로 나누는 상황이 발생하므로 미리 막는다.
    if (finalRatio <= 0) {
      _showWarning('기말고사 반영 비율은 0보다 커야 합니다.');
      return;
    }

    // 5) 핵심 계산 로직 — 역산 공식
    // secured: 중간고사/과제/출석에서 이미 확보한 가중 점수의 합
    final double secured = (midtermScore * (midtermRatio / 100)) +
        (assignmentScore * (assignmentRatio / 100)) +
        (attendanceScore * (attendanceRatio / 100));

    // 목표 학점에 해당하는 목표 점수 (예: B+ → 85점)
    final double targetScore = _gradeOptions[_selectedGrade]!;

    // required: 목표 점수에서 확보 점수를 뺀 뒤, 기말고사 비율로 나누어
    //           '기말고사 100점 만점 기준으로 몇 점이 필요한지'를 역산한다.
    final double required = (targetScore - secured) / (finalRatio / 100);

    // how: 계산이 끝났음을 화면에 알리기 위해 setState로 상태를 갱신한다.
    setState(() {
      _hasResult = true;
      _requiredFinalScore = required;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('학점 시뮬레이터', style: AppTextStyles.heading2),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 목표 학점 선택 영역
              _buildTargetGradeCard(),
              const SizedBox(height: AppSpacing.md),

              // 2. 성적 입력 영역
              _buildScoreInputCard(),
              const SizedBox(height: AppSpacing.md),

              // 3. 계산하기 버튼
              _buildCalculateButton(),
              const SizedBox(height: AppSpacing.md),

              // 4. 결과 표시 영역 (계산 후에만 표시)
              if (_hasResult) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. 목표 학점 선택 카드 ──────────────────────────────────────
  Widget _buildTargetGradeCard() {
    // 현재 선택된 학점에 해당하는 목표 점수를 미리 구해서 함께 보여준다.
    final double targetScore = _gradeOptions[_selectedGrade]!;

    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('목표 학점', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                // why: DropdownButton은 가로 공간을 모두 차지하지 않으므로
                // Expanded로 감싸 레이아웃이 일정하게 보이도록 한다.
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedGrade,
                    isExpanded: true,
                    items: _gradeOptions.keys.map((String label) {
                      return DropdownMenuItem<String>(
                        value: label,
                        child: Text(label, style: AppTextStyles.body1),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue == null) return;
                      // how: 학점을 바꾸면 목표 점수도 함께 바뀌므로 다시 그려준다.
                      setState(() {
                        _selectedGrade = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // 선택된 학점의 목표 점수를 강조해서 보여준다.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '${targetScore.toStringAsFixed(0)}점',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── 2. 성적 입력 카드 ──────────────────────────────────────────
  Widget _buildScoreInputCard() {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('성적 입력', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),

            // 중간고사: 점수 + 비율
            _buildScoreRatioRow(
              icon: Icons.edit_note,
              label: '중간고사',
              scoreController: _midtermScoreController,
              ratioController: _midtermRatioController,
              showScoreField: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // 과제: 점수 + 비율
            _buildScoreRatioRow(
              icon: Icons.task_alt,
              label: '과제',
              scoreController: _assignmentScoreController,
              ratioController: _assignmentRatioController,
              showScoreField: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // 출석: 점수 + 비율
            _buildScoreRatioRow(
              icon: Icons.event_available,
              label: '출석',
              scoreController: _attendanceScoreController,
              ratioController: _attendanceRatioController,
              showScoreField: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // 기말고사: 비율만 입력 (점수는 계산으로 구할 값이라 입력란 없음)
            _buildScoreRatioRow(
              icon: Icons.school,
              label: '기말고사',
              scoreController: null,
              ratioController: _finalRatioController,
              showScoreField: false,
            ),
          ],
        ),
      ),
    );
  }

  // 항목 한 줄(아이콘 + 라벨 + 점수 입력란 + 비율 입력란)을 만드는 공통 위젯.
  // why: 중간고사/과제/출석/기말고사 4개 항목이 구조가 같아 중복을 줄이기 위해 함수로 분리했다.
  // how: showScoreField가 false면 점수 입력란 대신 빈 공간만 차지한다 (기말고사 전용).
  Widget _buildScoreRatioRow({
    required IconData icon,
    required String label,
    required TextEditingController? scoreController,
    required TextEditingController ratioController,
    required bool showScoreField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 아이콘 + 항목 라벨
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTextStyles.label),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            // 점수 입력란 (기말고사는 입력란이 없으므로 빈 칸으로 대체)
            if (showScoreField) ...[
              Expanded(
                child: TextField(
                  controller: scoreController,
                  // how: 숫자 키보드만 표시되도록 keyboardType을 지정한다.
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '점수',
                    suffixText: '점',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ] else
              const Expanded(
                child: SizedBox(),
              ),

            // 비율 입력란 (4개 항목 모두 공통으로 존재)
            Expanded(
              child: TextField(
                controller: ratioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '반영 비율',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 3. 계산하기 버튼 ──────────────────────────────────────────
  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _onCalculatePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: const Text('계산하기', style: AppTextStyles.buttonText),
      ),
    );
  }

  // ── 4. 결과 표시 카드 ──────────────────────────────────────────
  // how: required 값의 범위에 따라 3가지 케이스(정상/불가능/이미 달성)로 분기한다.
  Widget _buildResultCard() {
    // 분기 처리에 사용할 값과 메시지를 미리 계산해 둔다.
    final double required = _requiredFinalScore;

    String message;
    Color messageColor;

    if (required > 100) {
      // 케이스 1: 100점을 넘게 받아야 한다면 현실적으로 불가능 → 유머러스한 메시지
      message = '이번 학기는 글렀습니다. 다음 학기를 기약하세요! 🙏';
      messageColor = AppColors.error;
    } else if (required < 0) {
      // 케이스 2: 필요 점수가 0점 미만이면 이미 목표를 달성한 상태
      message = '이미 목표 달성! 기말고사는 여유롭게 보세요. 🎉';
      messageColor = AppColors.success;
    } else {
      // 케이스 3: 0~100점 사이의 정상적인 목표 점수
      message = '기말고사에서 최소 ${required.toStringAsFixed(1)}점이 필요합니다.';
      messageColor = AppColors.primary;
    }

    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('계산 결과', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),

            // 필요 기말 점수를 크고 굵게 표시 (실제 계산값을 그대로 노출)
            Text(
              '${required.toStringAsFixed(1)}점',
              style: AppTextStyles.heading1.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: messageColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // 케이스별 안내 메시지
            Text(
              message,
              style: AppTextStyles.body1.copyWith(color: messageColor),
            ),
          ],
        ),
      ),
    );
  }
}
