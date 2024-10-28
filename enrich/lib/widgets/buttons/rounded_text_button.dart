import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double fontSize;
  final Function onPressed;
  final Color? buttonColor;
  final Color? borderColor; // Borda opcional
  final double? borderWidth; // Largura opcional

  const RoundedTextButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.onPressed,
    this.buttonColor,
    this.borderColor = Colors.black, // Cor padrão da borda
    this.borderWidth = 1.0, // Largura padrão
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = buttonColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: (borderColor != null && borderWidth != null && borderWidth! > 0)
              ? Border.all(
                  color: borderColor!, 
                  width: borderWidth!, 
                )
              : null, // Se borderColor ou borderWidth for null ou 0, sem borda
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
