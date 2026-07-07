import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

enum AppLanguage {
  id('Indonesia', 'id'),
  en('English', 'en'),
  ban('Basa Bali', 'ban');

  final String name;
  final String code;
  const AppLanguage(this.name, this.code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.id,
    );
  }
}

class SettingsState {
  final ThemeMode themeMode;
  final AppLanguage language;

  SettingsState({required this.themeMode, required this.language});

  SettingsState copyWith({ThemeMode? themeMode, AppLanguage? language}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  static const _fileName = 'settings_prefs.json';

  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  @override
  FutureOr<SettingsState> build() async {
    ThemeMode themeMode = ThemeMode.system;
    AppLanguage language = AppLanguage.id;

    try {
      final f = await _file;
      if (await f.exists()) {
        final content = await f.readAsString();
        final jsonMap = json.decode(content) as Map<String, dynamic>;

        if (jsonMap.containsKey('themeMode')) {
          themeMode = ThemeMode.values.firstWhere(
            (e) => e.name == jsonMap['themeMode'],
            orElse: () => ThemeMode.system,
          );
        }
        if (jsonMap.containsKey('language')) {
          language = AppLanguage.fromCode(jsonMap['language'] as String);
        }
      }
    } catch (_) {}

    return SettingsState(themeMode: themeMode, language: language);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(themeMode: mode);
    state = AsyncValue.data(newState);
    await _saveLocal(newState);
  }

  Future<void> updateLanguage(AppLanguage lang) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(language: lang);
    state = AsyncValue.data(newState);
    await _saveLocal(newState);
  }

  Future<void> _saveLocal(SettingsState settings) async {
    try {
      final f = await _file;
      final jsonMap = {
        'themeMode': settings.themeMode.name,
        'language': settings.language.code,
      };
      await f.writeAsString(json.encode(jsonMap));
    } catch (_) {}
  }
}
