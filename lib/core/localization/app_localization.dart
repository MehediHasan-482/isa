import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalization {
  final Locale locale;
  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'dashboard': 'Dashboard',
      'quran': 'Quran',
      'hadith': 'Hadith',
      'islamic_history': 'Islamic History',
      'ai_assistant': 'AI Assistant',
      'prayer_tools': 'Prayer Tools',
      'settings': 'Settings',
      'premium_active': 'Premium User Access Enabled',
      'free_user': 'Free User Mode',
      'go_premium': 'Go Premium',
      'prayer_time': 'Prayer Time',
      'qibla': 'Qibla',
      'tasbeeh': 'Tasbeeh',
    },
    'bn': {
      'dashboard': 'ড্যাশবোর্ড',
      'quran': 'কুরআন',
      'hadith': 'হাদিস',
      'islamic_history': 'ইসলামী ইতিহাস',
      'ai_assistant': 'এআই সহকারী',
      'prayer_tools': 'প্রার্থনা সরঞ্জাম',
      'settings': 'সেটিংস',
      'premium_active': 'প্রিমিয়াম ব্যবহারকারীর অ্যাক্সেস সক্রিয়',
      'free_user': 'ফ্রি ব্যবহারকারীর মোড',
      'go_premium': 'প্রিমিয়াম নিন',
      'prayer_time': 'নামাজের সময়',
      'qibla': 'কিবলা',
      'tasbeeh': 'তাসবীহ',
    },
    'ar': {
      'dashboard': 'لوحة التحكم',
      'quran': 'القرآن',
      'hadith': 'الحديث',
      'islamic_history': 'التاريخ الإسلامي',
      'ai_assistant': 'المساعد الآلي',
      'prayer_tools': 'أدوات الصلاة',
      'settings': 'الإعدادات',
      'premium_active': 'تم تفعيل حساب بريميوم',
      'free_user': 'وضع المستخدم المجاني',
      'go_premium': 'احصل على بريميوم',
      'prayer_time': 'مواقيت الصلاة',
      'qibla': 'القبلة',
      'tasbeeh': 'تسبيح',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'bn', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
