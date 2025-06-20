import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF0C5A38), //verde escuro Enrich
    secondary: const Color(0xFF5FAF46), //verde claro
    tertiary: const Color(0xFF2D8BBA), //azul
    surface: const Color(0xFFEB3034), //vermelho
    onPrimary: Colors.white, //branco
    onSurface: const Color(0xFFF4F4F4),  //cinza
  ),
  //fontFamily: 
  useMaterial3: true,
);