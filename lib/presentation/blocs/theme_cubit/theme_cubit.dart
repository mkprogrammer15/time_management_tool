import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _prefKey = 'seedColorValue';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs)
    : super(
        ThemeState(
          seedColor: Color(
            _prefs.getInt(_prefKey) ?? Colors.deepPurple.toARGB32(),
          ),
        ),
      );

  void setSeedColor(Color color) {
    _prefs.setInt(_prefKey, color.toARGB32());
    emit(ThemeState(seedColor: color));
  }
}
