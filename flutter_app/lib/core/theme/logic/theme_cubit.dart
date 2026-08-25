import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial(ThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeChanged(newMode));
  }

  //Helper for the extension to determine if we are in Dark Mode or not
  bool get isDarkMode => state.themeMode == ThemeMode.dark;
  // 0 = Light, 1 = Dark
  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final index = json['themeMode'] as int;
    return ThemeChanged(ThemeMode.values[index]);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'themeMode': state.themeMode.index};
  }
}
