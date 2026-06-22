import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeService {
  static const String boxName = 'settingsBox';
  static const String keyThemeMode = 'themeMode';

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  ThemeService() {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(boxName);
    final isDark = box.get(keyThemeMode, defaultValue: false);
    mode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() async {
    final box = await Hive.openBox(boxName);
    final newMode = mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    mode.value = newMode;
    await box.put(keyThemeMode, newMode == ThemeMode.dark);
  }
}
