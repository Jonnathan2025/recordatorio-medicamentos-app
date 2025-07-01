import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityHelpers {
  // Colores con alto contraste para mejor visibilidad
  static const Color highContrastBackground = Color(0xFFFFFFFF);
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastPrimary = Color(0xFF1565C0);
  static const Color highContrastSecondary = Color(0xFF2E7D32);

  // Tamaños de fuente recomendados para adultos mayores
  static const double smallTextSize = 16.0;
  static const double mediumTextSize = 18.0;
  static const double largeTextSize = 20.0;
  static const double extraLargeTextSize = 24.0;

  // Espaciado mínimo recomendado para botones
  static const double minTouchTargetSize = 48.0;
  static const double recommendedTouchTargetSize = 56.0;

  // Función para proporcionar feedback háptico
  static void provideFeedback(FeedbackType type) {
    switch (type) {
      case FeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case FeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case FeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case FeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  // Widget para texto accesible
  static Widget accessibleText(
      String text, {
        double? fontSize,
        FontWeight? fontWeight,
        Color? color,
        TextAlign? textAlign,
        String? semanticsLabel,
      }) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? mediumTextSize,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? highContrastText,
          height: 1.4, // Espaciado entre líneas para mejor legibilidad
        ),
        textAlign: textAlign,
      ),
    );
  }

  // Widget para botones accesibles
  static Widget accessibleButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    String? semanticsLabel,
    String? semanticsHint,
  }) {
    return Semantics(
      label: semanticsLabel ?? text,
      hint: semanticsHint,
      button: true,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: recommendedTouchTargetSize,
          minWidth: recommendedTouchTargetSize,
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            provideFeedback(FeedbackType.light);
            onPressed();
          },
          icon: icon != null
              ? Icon(icon, size: 24)
              : const SizedBox.shrink(),
          label: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? mediumTextSize,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? highContrastPrimary,
            foregroundColor: textColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }

  // Widget para campos de entrada accesibles
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? semanticsLabel,
    String? semanticsHint,
    Function(String)? onChanged,
  }) {
    return Semantics(
      label: semanticsLabel ?? labelText,
      hint: semanticsHint ?? hintText,
      textField: true,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: recommendedTouchTargetSize,
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: mediumTextSize,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 24)
                : null,
            labelStyle: const TextStyle(
              fontSize: mediumTextSize,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              fontSize: mediumTextSize,
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: highContrastPrimary,
                width: 3,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Widget para cards accesibles
  static Widget accessibleCard({
    required Widget child,
    VoidCallback? onTap,
    String? semanticsLabel,
    String? semanticsHint,
    Color? backgroundColor,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: onTap != null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: backgroundColor ?? highContrastBackground,
        child: InkWell(
          onTap: onTap != null
              ? () {
            provideFeedback(FeedbackType.light);
            onTap();
          }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: recommendedTouchTargetSize,
            ),
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  // Widget para switches accesibles
  static Widget accessibleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String title,
    String? subtitle,
    String? semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel ?? title,
      hint: value ? 'Activado' : 'Desactivado',
      toggled: value,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: recommendedTouchTargetSize,
        ),
        child: SwitchListTile(
          title: accessibleText(
            title,
            fontSize: mediumTextSize,
            fontWeight: FontWeight.w600,
          ),
          subtitle: subtitle != null
              ? accessibleText(
            subtitle,
            fontSize: smallTextSize,
            color: Colors.grey[600],
          )
              : null,
          value: value,
          onChanged: (newValue) {
            provideFeedback(FeedbackType.selection);
            onChanged(newValue);
          },
          activeColor: highContrastSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  // Función para anunciar mensajes importantes
  static void announceMessage(String message) {
    // En un contexto real, esto podría usar text-to-speech
    debugPrint('Accessibility Announcement: $message');
  }

  // Validar si el contraste de colores es suficiente
  static bool hasGoodContrast(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    final contrastRatio = (lighter + 0.05) / (darker + 0.05);

    // WCAG AA estándar requiere al menos 4.5:1 para texto normal
    return contrastRatio >= 4.5;
  }

  // Configuración de tema para alta accesibilidad
  static ThemeData getAccessibleTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: highContrastPrimary,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: extraLargeTextSize, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: largeTextSize, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: largeTextSize, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: smallTextSize, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: mediumTextSize, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: smallTextSize, fontWeight: FontWeight.w400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(recommendedTouchTargetSize, recommendedTouchTargetSize),
          textStyle: const TextStyle(
            fontSize: mediumTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(fontSize: mediumTextSize),
        hintStyle: TextStyle(fontSize: mediumTextSize),
      ),
    );
  }
}

enum FeedbackType {
  light,
  medium,
  heavy,
  selection,
}