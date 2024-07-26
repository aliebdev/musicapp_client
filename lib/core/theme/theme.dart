import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = Pallete.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );

  static get dark => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: _border(),
          border: _border(),
          focusedBorder: _border(Pallete.gradient2),
          errorBorder: _border(Pallete.errorColor),
        ),
      );
}
