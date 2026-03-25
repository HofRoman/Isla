class SunnahItem {
  final String id;
  final String title;
  final String arabic;
  final String description;
  final String timeOfDay; // 'morning' | 'afternoon' | 'evening' | 'any'
  final String icon;
  final String source;

  const SunnahItem({
    required this.id,
    required this.title,
    required this.arabic,
    required this.description,
    required this.timeOfDay,
    required this.icon,
    required this.source,
  });
}

const List<SunnahItem> sunnahList = [
  // Morning
  SunnahItem(
    id: 'wakeup_dua',
    title: 'Aufwach-Dua sprechen',
    arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا',
    description: 'Den Morgen mit Alhamdulillah beginnen und das Aufwach-Dua sprechen.',
    timeOfDay: 'morning',
    icon: '🌅',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'miswak',
    title: 'Zähne reinigen (Miswak/Bürste)',
    arabic: 'السِّوَاك مَطْهَرَةٌ لِلْفَمِ',
    description: 'Die Zähne bei jedem Gebet und beim Aufwachen reinigen.',
    timeOfDay: 'morning',
    icon: '🦷',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'fajr_sunnah',
    title: '2 Sunnah-Rakaat vor Fajr',
    arabic: 'رَكْعَتَا الْفَجْرِ خَيْرٌ مِنَ الدُّنْيَا وَمَا فِيهَا',
    description: 'Die 2 Sunnah-Rakaat vor dem Fajr-Pflichtgebet sind besser als die Welt und alles darin.',
    timeOfDay: 'morning',
    icon: '🌙',
    source: 'Muslim',
  ),
  SunnahItem(
    id: 'morning_adhkar',
    title: 'Morgen-Adhkar (Dhikr)',
    arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
    description: 'Nach dem Fajr-Gebet die Morgen-Adhkar rezitieren.',
    timeOfDay: 'morning',
    icon: '☀️',
    source: 'Abu Dawud',
  ),
  SunnahItem(
    id: 'breakfast_bismillah',
    title: 'Bismillah vor dem Essen',
    arabic: 'بِسْمِ اللَّهِ',
    description: 'Jede Mahlzeit und jeden Schluck mit Bismillah beginnen.',
    timeOfDay: 'morning',
    icon: '🍽️',
    source: 'Bukhari',
  ),

  // General / Any time
  SunnahItem(
    id: 'right_hand',
    title: 'Rechte Hand bevorzugen',
    arabic: 'كَانَ يُعْجِبُهُ التَّيَمُّنُ',
    description: 'Beim Essen, Trinken, Geben und Empfangen die rechte Hand benutzen.',
    timeOfDay: 'any',
    icon: '🤲',
    source: 'Bukhari & Muslim',
  ),
  SunnahItem(
    id: 'salam',
    title: 'Salam geben',
    arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
    description: 'Jedem Muslim mit Salam grüßen – besonders Bekannten und Fremden.',
    timeOfDay: 'any',
    icon: '🫱',
    source: 'Bukhari & Muslim',
  ),
  SunnahItem(
    id: 'smile',
    title: 'Lächeln',
    arabic: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ',
    description: 'Lächle deinem Bruder ins Gesicht – es ist Sadaqa.',
    timeOfDay: 'any',
    icon: '😊',
    source: 'Tirmidhi',
  ),
  SunnahItem(
    id: 'quran_daily',
    title: 'Täglich Koran lesen',
    arabic: 'اقْرَأُوا الْقُرْآنَ فَإِنَّهُ يَأْتِي شَفِيعًا',
    description: 'Täglich mindestens eine Seite oder eine Sure Koran lesen.',
    timeOfDay: 'any',
    icon: '📖',
    source: 'Muslim',
  ),
  SunnahItem(
    id: 'istighfar',
    title: '100× Istighfar täglich',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    description: 'Der Prophet (ﷺ) bat Allah täglich 100 Mal um Vergebung.',
    timeOfDay: 'any',
    icon: '🙏',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'sadaqa',
    title: 'Sadaqa geben',
    arabic: 'كُلُّ مَعْرُوفٍ صَدَقَةٌ',
    description: 'Täglich eine gute Tat tun – auch ein freundliches Wort ist Sadaqa.',
    timeOfDay: 'any',
    icon: '💝',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'dhuhr_sunnah',
    title: '4 Sunnah-Rakaat vor Dhuhr',
    arabic: 'مَنْ حَافَظَ عَلَيْهِنَّ حُرِّمَ عَلَى النَّارِ',
    description: '4 Rakaat vor und 2 nach Dhuhr beten.',
    timeOfDay: 'afternoon',
    icon: '🕛',
    source: 'Tirmidhi',
  ),

  // Evening
  SunnahItem(
    id: 'evening_adhkar',
    title: 'Abend-Adhkar (Dhikr)',
    arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
    description: 'Nach dem Asr-Gebet die Abend-Adhkar rezitieren.',
    timeOfDay: 'evening',
    icon: '🌆',
    source: 'Abu Dawud',
  ),
  SunnahItem(
    id: 'ayat_kursi_sleep',
    title: 'Ayat al-Kursi vor dem Schlafen',
    arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
    description: 'Ayat al-Kursi vor dem Schlafen schützt bis zum Morgen.',
    timeOfDay: 'evening',
    icon: '🌙',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'sleep_dua',
    title: 'Schlaf-Dua sprechen',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    description: 'Das Schlaf-Dua vor dem Einschlafen sprechen.',
    timeOfDay: 'evening',
    icon: '😴',
    source: 'Bukhari',
  ),
  SunnahItem(
    id: 'witr',
    title: 'Witr-Gebet verrichten',
    arabic: 'الْوِتْرُ حَقٌّ عَلَى كُلِّ مُسْلِمٍ',
    description: 'Mindestens 1 Rakaat Witr vor dem Schlafen beten.',
    timeOfDay: 'evening',
    icon: '🌌',
    source: 'Abu Dawud',
  ),
];
