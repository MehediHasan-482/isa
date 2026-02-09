enum BlogCategory {
  all('All', 'all'),
  nameExplanations('Names of Allah', 'name_explanations'),
  spiritualGuidance('Spiritual Guidance', 'spiritual_guidance'),
  dua('Dua & Azkar', 'dua'),
  stories('Prophets Stories', 'stories'),
  quran('Quranic Verse', 'quran'),
  hadith('Hadith', 'hadith'),
  dailyReminders('Daily Reminders', 'daily_reminders');

  final String displayName;
  final String value;

  const BlogCategory(this.displayName, this.value);
}