
// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const LocalizationsDelegate<AppLocalization> delegate = _AppLocalizationDelegate();

  // Add your localized strings here
  Map<String, String> _localizedStrings = {
    'en_title': 'ISA – Islamic Assistant',
    'bn_title': 'আইএসএ – ইসলামিক অ্যাসিস্ট্যান্ট',
    'ar_title': 'إيسا – المساعد الإسلامي',
  };

  String translate(String key) {
    return _localizedStrings['${locale.languageCode}_$key'] ?? key;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'bn', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
