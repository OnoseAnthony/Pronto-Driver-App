import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buildTitlenSubtitleText(String text, Color color, double fontSize,
    FontWeight fontWeight, TextAlign textAlign, TextOverflow overflow) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    ),
  );
}
