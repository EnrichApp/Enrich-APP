import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountText extends StatelessWidget {
  final String amount;
  final double fontSize;
  final Color color;
  final bool sublined;
  final TextAlign textAlign;

  const AmountText(
      {super.key,
      required this.amount,
      this.fontSize = 20,
      this.color = const Color.fromARGB(255, 108, 201, 80),
      this.sublined = false,
      this.textAlign = TextAlign.start, 
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      "R\$$amount",
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        decoration: sublined ? TextDecoration.underline : TextDecoration.none,
        decorationColor: color,
      ),
      textAlign: textAlign,
    );
  }
}
