import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubtitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const SubtitleText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: fontSize, fontWeight: FontWeight.normal, color: color),
    );
  }
}
