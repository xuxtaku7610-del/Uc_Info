// lib/features/settings/providers/settings_provider.dart
// 역할: 알림·다크모드·언어 설정 상태 관리.

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;

  const SettingsState({
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.language = '한국어',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications(bool value) =>
      state = state.copyWith(notificationsEnabled: value);

  void toggleDarkMode(bool value) =>
      state = state.copyWith(darkModeEnabled: value);

  void setLanguage(String? value) {
    if (value != null) state = state.copyWith(language: value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
