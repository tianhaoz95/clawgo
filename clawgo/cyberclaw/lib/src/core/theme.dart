import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFffb1c4);
  static const Color primaryContainer = Color(0xFFff4a8d);
  static const Color onPrimary = Color(0xFF65002e);
  static const Color onPrimaryContainer = Color(0xFF590028);

  static const Color secondary = Color(0xFFd3fbff);
  static const Color secondaryContainer = Color(0xFF00eefc);
  static const Color onSecondary = Color(0xFF00363a);
  static const Color onSecondaryContainer = Color(0xFF00686f);

  static const Color background = Color(0xFF131313);
  static const Color onBackground = Color(0xFFe5e2e1);

  static const Color surface = Color(0xFF131313);
  static const Color onSurface = Color(0xFFe5e2e1);
  static const Color surfaceVariant = Color(0xFF353534);
  static const Color onSurfaceVariant = Color(0xFFe5bcc5);

  static const Color outline = Color(0xFFac878f);
  static const Color outlineVariant = Color(0xFF5c3f46);

  static const Color surfaceContainerLowest = Color(0xFF0e0e0e);
  static const Color surfaceContainerLow = Color(0xFF1c1b1b);
  static const Color surfaceContainer = Color(0xFF201f1f);
  static const Color surfaceContainerHigh = Color(0xFF2a2a2a);
  static const Color surfaceContainerHighest = Color(0xFF353534);

  static const Color surfaceBright = Color(0xFF3a3939);
  static const Color surfaceDim = Color(0xFF131313);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondary: onSecondary,
        onSecondaryContainer: onSecondaryContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerLowest: surfaceContainerLowest,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        background: background,
        onBackground: onBackground,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.displayLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.05,
            ),
            displayMedium: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.displayMedium,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.displaySmall,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.headlineLarge,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.headlineSmall,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.manrope(
              textStyle: ThemeData.dark().textTheme.titleLarge,
              fontWeight: FontWeight.w600,
            ),
            labelLarge: GoogleFonts.spaceGrotesk(
              textStyle: ThemeData.dark().textTheme.labelLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
      cardTheme: const CardThemeData(
        color: surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: outline, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: outlineVariant, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
          borderRadius: BorderRadius.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimaryContainer,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: outlineVariant, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}

class BeveledEdgePainter extends CustomPainter {
  final Color color;
  final double cutSize;

  BeveledEdgePainter({required this.color, this.cutSize = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BeveledEdgeClipper extends CustomClipper<Path> {
  final double cutSize;

  BeveledEdgeClipper({this.cutSize = 10.0});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
