class PrayerInfo {
  final String name;
  final String arabicName;
  final String time;
  final int rakaat;
  final String description;
  final List<int> rakaatBreakdown;
  final List<String> rakaatTypes;

  const PrayerInfo({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.rakaat,
    required this.description,
    required this.rakaatBreakdown,
    required this.rakaatTypes,
  });
}

final List<PrayerInfo> prayers = [
  PrayerInfo(
    name: 'Fajr',
    arabicName: 'الفَجْر',
    time: 'Morgengrauen bis Sonnenaufgang',
    rakaat: 2,
    description: 'Das Morgengebet – das erste der fünf täglichen Gebete. Es wird vor Sonnenaufgang verrichtet.',
    rakaatBreakdown: [2],
    rakaatTypes: ['Fard (Pflicht)'],
  ),
  PrayerInfo(
    name: 'Dhuhr',
    arabicName: 'الظُّهْر',
    time: 'Wenn die Sonne ihren Zenit überschritten hat',
    rakaat: 4,
    description: 'Das Mittagsgebet – wird verrichtet, nachdem die Sonne ihren höchsten Punkt überschritten hat.',
    rakaatBreakdown: [4],
    rakaatTypes: ['Fard (Pflicht)'],
  ),
  PrayerInfo(
    name: 'Asr',
    arabicName: 'الْعَصْر',
    time: 'Nachmittag bis kurz vor Sonnenuntergang',
    rakaat: 4,
    description: 'Das Nachmittagsgebet – im Koran besonders hervorgehoben in Sure Al-Asr.',
    rakaatBreakdown: [4],
    rakaatTypes: ['Fard (Pflicht)'],
  ),
  PrayerInfo(
    name: 'Maghrib',
    arabicName: 'الْمَغْرِب',
    time: 'Kurz nach Sonnenuntergang',
    rakaat: 3,
    description: 'Das Abendgebet – wird direkt nach Sonnenuntergang verrichtet.',
    rakaatBreakdown: [3],
    rakaatTypes: ['Fard (Pflicht)'],
  ),
  PrayerInfo(
    name: 'Ischa',
    arabicName: 'الْعِشَاء',
    time: 'Einbruch der Nacht bis Morgengrauen',
    rakaat: 4,
    description: 'Das Nachtgebet – das letzte der fünf täglichen Pflichtgebete.',
    rakaatBreakdown: [4],
    rakaatTypes: ['Fard (Pflicht)'],
  ),
];

class WuduStep {
  final int step;
  final String title;
  final String description;
  final String arabicDua;
  final String germanDua;

  const WuduStep({
    required this.step,
    required this.title,
    required this.description,
    required this.arabicDua,
    required this.germanDua,
  });
}

final List<WuduStep> wuduSteps = [
  WuduStep(
    step: 1,
    title: 'Absicht (Niyya)',
    description: 'Mache die Absicht in deinem Herzen, Wudu für das Gebet zu verrichten.',
    arabicDua: 'نَوَيْتُ الْوُضُوءَ',
    germanDua: 'Ich beabsichtige die rituelle Waschung (Wudu).',
  ),
  WuduStep(
    step: 2,
    title: 'Bismillah sprechen',
    description: 'Beginne mit dem Namen Allahs.',
    arabicDua: 'بِسْمِ اللَّهِ',
    germanDua: 'Im Namen Allahs.',
  ),
  WuduStep(
    step: 3,
    title: 'Hände waschen',
    description: 'Wasche beide Hände bis zu den Handgelenken dreimal.',
    arabicDua: '',
    germanDua: 'Dreimal jede Hand waschen',
  ),
  WuduStep(
    step: 4,
    title: 'Mundspülen',
    description: 'Spüle den Mund dreimal mit Wasser.',
    arabicDua: '',
    germanDua: 'Dreimal den Mund spülen',
  ),
  WuduStep(
    step: 5,
    title: 'Nase reinigen',
    description: 'Ziehe dreimal Wasser in die Nase und blast es wieder heraus.',
    arabicDua: '',
    germanDua: 'Dreimal die Nase reinigen',
  ),
  WuduStep(
    step: 6,
    title: 'Gesicht waschen',
    description: 'Wasche das gesamte Gesicht dreimal von der Stirn bis zum Kinn.',
    arabicDua: '',
    germanDua: 'Dreimal das Gesicht waschen',
  ),
  WuduStep(
    step: 7,
    title: 'Arme waschen',
    description: 'Wasche jeden Arm bis zum Ellbogen dreimal, beginnend mit rechts.',
    arabicDua: '',
    germanDua: 'Rechten dann linken Arm dreimal waschen',
  ),
  WuduStep(
    step: 8,
    title: 'Kopf abwischen',
    description: 'Wische den Kopf einmal mit nassen Händen ab.',
    arabicDua: '',
    germanDua: 'Kopf einmal abwischen',
  ),
  WuduStep(
    step: 9,
    title: 'Ohren abwischen',
    description: 'Wische die Ohren innen und außen mit denselben nassen Händen ab.',
    arabicDua: '',
    germanDua: 'Ohren innen und außen abwischen',
  ),
  WuduStep(
    step: 10,
    title: 'Füße waschen',
    description: 'Wasche jeden Fuß bis zum Knöchel dreimal, beginnend mit rechts.',
    arabicDua: '',
    germanDua: 'Rechten dann linken Fuß dreimal waschen',
  ),
  WuduStep(
    step: 11,
    title: 'Dua nach dem Wudu',
    description: 'Spreche nach dem Wudu das folgende Gebet.',
    arabicDua: 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّداً عَبْدُهُ وَرَسُولُهُ',
    germanDua: 'Ich bezeuge, dass es keinen Gott gibt außer Allah allein, der keinen Partner hat, und ich bezeuge, dass Muhammad Sein Diener und Gesandter ist.',
  ),
];

class DhikrItem {
  final String arabic;
  final String transliteration;
  final String german;
  final int recommendedCount;
  final String fadl;

  const DhikrItem({
    required this.arabic,
    required this.transliteration,
    required this.german,
    required this.recommendedCount,
    required this.fadl,
  });
}

final List<DhikrItem> dhikrList = [
  DhikrItem(
    arabic: 'سُبْحَانَ اللَّه',
    transliteration: 'Subhanallah',
    german: 'Gelobt sei Allah',
    recommendedCount: 33,
    fadl: 'Der Prophet (ﷺ) sagte: Zwei Worte, die dem Allerbarmer lieb sind: Subhanallah wa bihamdihi, Subhanallahil-Azim.',
  ),
  DhikrItem(
    arabic: 'الْحَمْدُ لِلَّه',
    transliteration: 'Alhamdulillah',
    german: 'Alles Lob gebührt Allah',
    recommendedCount: 33,
    fadl: 'Das Alhamdulillah füllt die Waage (des guten Tuns am Jüngsten Tag).',
  ),
  DhikrItem(
    arabic: 'اللَّهُ أَكْبَر',
    transliteration: 'Allahu Akbar',
    german: 'Allah ist am Größten',
    recommendedCount: 34,
    fadl: 'Die Worte Subhanallah, Alhamdulillah und Allahu Akbar sind mir lieber als alles, worüber die Sonne aufgeht.',
  ),
  DhikrItem(
    arabic: 'لَا إِلَهَ إِلَّا اللَّه',
    transliteration: 'La ilaha illallah',
    german: 'Es gibt keinen Gott außer Allah',
    recommendedCount: 100,
    fadl: 'Das Beste, was ich und die Propheten vor mir gesagt haben, ist: La ilaha illallah, allein, ohne Partner.',
  ),
  DhikrItem(
    arabic: 'أَسْتَغْفِرُ اللَّه',
    transliteration: 'Astaghfirullah',
    german: 'Ich bitte Allah um Vergebung',
    recommendedCount: 100,
    fadl: 'Bei Allah, ich bitte Allah um Vergebung und wende mich täglich mehr als siebzig Mal zu Ihm. (Prophet Muhammad ﷺ)',
  ),
  DhikrItem(
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'Subhanallahi wa bihamdihi',
    german: 'Gepriesen sei Allah und gelobt',
    recommendedCount: 100,
    fadl: 'Wer sagt: Subhanallahi wa bihamdihi, hundert Mal am Tag, dem werden seine Sünden vergeben, auch wenn sie so zahlreich wie der Meeresschaum wären.',
  ),
  DhikrItem(
    arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيل',
    transliteration: 'Hasbunallahu wa nimul wakil',
    german: 'Allah genügt uns und Er ist der beste Sachwalter',
    recommendedCount: 7,
    fadl: 'Dies sprach Ibrahim (ﷺ), als er ins Feuer geworfen wurde, und Muhammad (ﷺ), als man ihm sagte, die Menschen hätten sich gegen ihn versammelt.',
  ),
];
