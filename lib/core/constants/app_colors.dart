import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF505050);
  static const Color primaryLight = Color(0xFF6A48D7);
  static const Color primaryMediumColor = Color(0xFFE94A8E);
  static const Color primaryLightColor = Color(0xFFF8D7E5);
  static const Color secondary = Color(0xffDACFF9);
  static const Color secondaryColor = Color(0xFF654321);
  static const Color secoundry = Color(0xff737791);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color inputFieldBackground = Color(0xFFF7F7F7);
  static const Color textColor = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xff303030);
  static const Color textBlack = Color(0xFF1D1D1D);
  static const Color textGrey = Color(0xFF7E7E7E);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color success = Color(0xFF4CAF50);
  static const Color successGreen = Color(0xFF28A745);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  static const Color orange = Color(0xffFFB948);
  static const Color darkOrange = Color(0xffE59400);
  static const Color green = Color(0xff2FAE84);
  static const Color red = Color(0xffFF5A5F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xff7C7C7C);
  static const Color lightGrey = Color(0xFFF0F0F0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color gradientOne = Color(0xffD7F0EF);
  static const Color gradientTwo = Color(0xffF2FAFA);
  static const Color gradientThree = Color(0xff029F9A);
  static const Color gradientFour = Color(0xff073433);

  static LinearGradient appGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5C4199),
      Color(0xFF5C4299),
      Color(0xFF5B4399),
      Color(0xFF5B4399),
      Color(0xFF5B4498),
      Color(0xFF30AD84),
    ],
  );

  static LinearGradient appGradientSimplified = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5C4199),
      Color(0xFF4E6392),
      Color(0xFF3F888B),
      Color(0xFF30AD84),
    ],
  );

  static LinearGradient longGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const [
      Color(0xFF5C4199),
      Color(0xFF5C4299),
      Color(0xFF5B4399),
      Color(0xFF5B4498),
      Color(0xFF5A4598),
      Color(0xFF5A4698),
      Color(0xFF594998),
      Color(0xFF584A97),
      Color(0xFF574D97),
      Color(0xFF564E96),
      Color(0xFF555196),
      Color(0xFF545495),
      Color(0xFF535795),
      Color(0xFF525994),
      Color(0xFF515C94),
      Color(0xFF505E93),
      Color(0xFF4F6093),
      Color(0xFF4E6392),
      Color(0xFF4D6592),
      Color(0xFF4C6991),
      Color(0xFF4B6B91),
      Color(0xFF4A6D91),
      Color(0xFF496F90),
      Color(0xFF487290),
      Color(0xFF47748F),
      Color(0xFF46778F),
      Color(0xFF45798E),
      Color(0xFF447B8E),
      Color(0xFF437E8D),
      Color(0xFF42808D),
      Color(0xFF41838C),
      Color(0xFF40858C),
      Color(0xFF3F888B),
      Color(0xFF3E8A8B),
      Color(0xFF3D8D8A),
      Color(0xFF3C8F8A),
      Color(0xFF3B9289),
      Color(0xFF3A9489),
      Color(0xFF399788),
      Color(0xFF389988),
      Color(0xFF379B88),
      Color(0xFF369E87),
      Color(0xFF35A087),
      Color(0xFF34A286),
      Color(0xFF33A486),
      Color(0xFF32A785),
      Color(0xFF31A985),
      Color(0xFF30AC84),
    ],
  );

  static RadialGradient orangeRadialGradient = const RadialGradient(
    center: Alignment.topLeft,
    radius: 1.0,
    colors: [
      Color(0xFFF1A725),
      Color(0xFFFF7800),
    ],
    stops: [0.0, 1.0],
  );
}
