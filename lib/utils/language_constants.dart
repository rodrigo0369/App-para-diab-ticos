import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageConstants {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static Locale? getLocaleFromCode(String code) {
    switch (code) {
      case 'es':
        return const Locale('es');
      case 'en':
        return const Locale('en');
      default:
        return null;
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return '';
    }
  }
}
