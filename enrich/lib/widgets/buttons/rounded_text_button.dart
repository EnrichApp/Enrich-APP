import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double fontSize;
  final Function onPressed;

  const RoundedTextButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
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
