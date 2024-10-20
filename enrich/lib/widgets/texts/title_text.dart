import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool sublined;

  const TitleText(
      {super.key,
      required this.text,
      this.fontSize = 23,
      this.color = Colors.black,
      this.sublined = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        decoration: sublined ? TextDecoration.underline : TextDecoration.none,
        decorationColor: color,
      ),
    );
  }
}
