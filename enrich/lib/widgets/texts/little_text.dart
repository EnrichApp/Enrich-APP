import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LittleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;
  final bool underlined;

  const LittleText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    this.underlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: color,
        decoration: underlined ? TextDecoration.underline : TextDecoration.none,
        decorationThickness: underlined ? 1 : 0,
        decorationColor: color,
      ),
      textAlign: textAlign,
    );
  }
}
