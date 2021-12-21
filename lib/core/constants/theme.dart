import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color purpleClr = Color(0xFFA0338A);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFF54B80);
const Color lightblue = Color(0xFF03A9F4);
const Color lightred = Color(0xFFE57373);
const Color lightorange = Color(0xFFFFB74D);
const Color whiteClr = Color(0xFFFFFFFF);
const addTaskButtonClr = purpleClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkBottomClr = Color(0xFFBDBDBD);
Color kAppPrimaryColor = Colors.grey.shade200;
Color kWhite = Colors.white;
Color kLightBlack = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

IconData twitter = IconData(0xe900, fontFamily: "CustomIcons");
IconData facebook = IconData(0xe901, fontFamily: "CustomIcons");
IconData googlePlus = IconData(0xe902, fontFamily: "CustomIcons");
IconData linkedin = IconData(0xe903, fontFamily: "CustomIcons");

const kSpacingUnit = 10;

final kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

BoxDecoration avatarDecoration =
    BoxDecoration(shape: BoxShape.circle, color: kAppPrimaryColor, boxShadow: [
  BoxShadow(
    color: kWhite,
    offset: Offset(10, 10),
    blurRadius: 10,
  ),
  BoxShadow(
    color: kWhite,
    offset: Offset(-10, -10),
    blurRadius: 10,
  ),
]);
TextStyle get headingTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
  );
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
  );
}

TextStyle get titleTextStle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
  );
}

TextStyle get subTitleTextStle {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
  );
}

TextStyle get bodyTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
  );
}

TextStyle get body2TextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
  );
}

TextStyle get cardTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(fontSize: 13, color: Colors.black87),
  );
}

TextStyle get card2TextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
  );
}

TextStyle get card3TextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
  );
}
