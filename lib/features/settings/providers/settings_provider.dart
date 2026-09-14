// lib/features/settings/providers/settings_provider.dart
// 역할: 알림·다크모드·언어 설정 상태 관리 및 영속화.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  static const _keyDarkMode = 'setting_dark_mode';
  static const _keyNotifications = 'setting_notifications';
  static const _keyLanguage = 'setting_language';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      darkModeEnabled: prefs.getBool(_keyDarkMode) ?? false,
      notificationsEnabled: prefs.getBool(_keyNotifications) ?? true,
      language: prefs.getString(_keyLanguage) ?? '한국어',
    );
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
    state = state.copyWith(darkModeEnabled: value);
  }

  Future<void> setLanguage(String? value) async {
    if (value != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLanguage, value);
      state = state.copyWith(language: value);
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
