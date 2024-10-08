import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF16804C), //verde escuro
    secondary: const Color(0xFF5FAF46), //verde claro
    tertiary: const Color(0xFF2D8BBA), //azul
    surface: const Color(0xFFEB3034), //vermelho
    onPrimary: Colors.white, //branco
    background: const Color(0xFFF4F4F4), //cinza
  ),
  //fontFamily: 
  useMaterial3: true,
);