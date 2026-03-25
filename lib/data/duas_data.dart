class DuaCategory {
  final String name;
  final String icon;
  final List<Dua> duas;

  const DuaCategory({
    required this.name,
    required this.icon,
    required this.duas,
  });
}

class Dua {
  final String title;
  final String arabic;
  final String transliteration;
  final String german;
  final String english;
  final String source;

  const Dua({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.german,
    required this.english,
    required this.source,
  });
}

final List<DuaCategory> duaCategories = [
  DuaCategory(
    name: 'Tägliche Duas',
    icon: '🌅',
    duas: [
      Dua(
        title: 'Dua beim Aufwachen',
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration: 'Alhamdulillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur',
        german: 'Alles Lob gebührt Allah, Der uns zum Leben erweckt hat, nachdem Er uns sterben ließ, und zu Ihm ist die Auferstehung.',
        english: 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
        source: 'Sahih al-Bukhari',
      ),
      Dua(
        title: 'Dua beim Einschlafen',
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya',
        german: 'In Deinem Namen, o Allah, sterbe ich und lebe ich.',
        english: 'In Your name, O Allah, I live and die.',
        source: 'Sahih al-Bukhari',
      ),
      Dua(
        title: 'Morgen-Dhikr',
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        transliteration: 'Asbahna wa asbahal mulku lillahi walhamdu lillahi la ilaha illallahu wahdahu la sharika lah',
        german: 'Wir haben den Morgen erreicht und mit uns die Herrschaft Allahs. Alles Lob gebührt Allah. Es gibt keinen Gott außer Allah allein, ohne Partner.',
        english: 'We have reached the morning and with it all dominion belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.',
        source: 'Abu Dawud',
      ),
      Dua(
        title: 'Abend-Dhikr',
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ للهِ، وَالْحَمْدُ للهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration: 'Amsayna wa amsal mulku lillahi walhamdu lillahi la ilaha illallahu wahdahu la sharika lah',
        german: 'Wir haben den Abend erreicht und mit uns die Herrschaft Allahs. Alles Lob gebührt Allah. Es gibt keinen Gott außer Allah allein, ohne Partner.',
        english: 'We have reached the evening and with it all dominion belongs to Allah. All praise is for Allah.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Sayyid al-Istighfar',
        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        transliteration: 'Allahumma anta rabbi la ilaha illa anta khalaqtani wa ana abduka...',
        german: 'O Allah, Du bist mein Herr, niemand hat das Recht angebetet zu werden außer Dir. Du hast mich erschaffen und ich bin Dein Diener...',
        english: 'O Allah, You are my Lord, none has the right to be worshipped except You, You created me and I am Your servant...',
        source: 'Sahih al-Bukhari',
      ),
    ],
  ),
  DuaCategory(
    name: 'Essen & Trinken',
    icon: '🍽️',
    duas: [
      Dua(
        title: 'Vor dem Essen',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        german: 'Im Namen Allahs.',
        english: 'In the name of Allah.',
        source: 'Sahih al-Bukhari',
      ),
      Dua(
        title: 'Nach dem Essen',
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
        transliteration: 'Alhamdulillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin',
        german: 'Alles Lob gebührt Allah, Der uns gespeist und getränkt und uns zu Muslimen gemacht hat.',
        english: 'All praise is for Allah who fed us and gave us drink and made us Muslims.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'Dua des Gastes für den Gastgeber',
        arabic: 'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ',
        transliteration: 'Allahumma barik lahum fima razaqtahum waghfir lahum warhamhum',
        german: 'O Allah, segne sie in dem, womit Du sie versorgt hast, vergib ihnen und erbarme Dich ihrer.',
        english: 'O Allah, bless them in what You have provided for them, forgive them and have mercy on them.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'Reise & Verkehr',
    icon: '🚗',
    duas: [
      Dua(
        title: 'Beim Betreten des Fahrzeugs',
        arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ',
        transliteration: 'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin wa inna ila rabbina lamunqalibun',
        german: 'Gepriesen sei Der, Der uns dies dienstbar gemacht hat, wir hätten es nicht beherrscht, und zu unserem Herrn kehren wir zurück.',
        english: 'Glory is to Him Who has provided this for us though we could never have had it by our own efforts, and to our Lord we shall certainly return.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'Dua für eine Reise',
        arabic: 'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا',
        transliteration: 'Allahu Akbar, Allahu Akbar, Allahu Akbar...',
        german: 'Allah ist am Größten (3x), Gepriesen sei Der, Der uns dies dienstbar gemacht hat...',
        english: 'Allah is the Greatest (3x), Glory is to Him Who has subjected this to us...',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'Haus & Familie',
    icon: '🏠',
    duas: [
      Dua(
        title: 'Beim Betreten des Hauses',
        arabic: 'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
        transliteration: 'Bismillahi walajna wa bismillahi kharajna wa \'ala Allahi rabbina tawakkalna',
        german: 'Im Namen Allahs treten wir ein, im Namen Allahs gehen wir hinaus, und auf Allah, unseren Herrn, vertrauen wir.',
        english: 'In the name of Allah we enter and in the name of Allah we leave, and upon our Lord we place our trust.',
        source: 'Abu Dawud',
      ),
      Dua(
        title: 'Für die Eltern',
        arabic: 'رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
        transliteration: 'Rabbi irhamhuma kama rabbayani saghira',
        german: 'Mein Herr, erbarme Dich ihrer, wie sie mich als Kind aufgezogen haben.',
        english: 'My Lord, have mercy upon them as they brought me up when I was young.',
        source: 'Surah Al-Isra 17:24',
      ),
      Dua(
        title: 'Für ein gesegnetes Heim',
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا',
        transliteration: 'Allahumma inni as\'aluka khayral mawlaji wa khayral makhraj...',
        german: 'O Allah, ich bitte Dich um den besten Eingang und den besten Ausgang...',
        english: 'O Allah, I ask You for the best of the entrance and the best of the exit...',
        source: 'Abu Dawud',
      ),
    ],
  ),
  DuaCategory(
    name: 'Schutz & Heilung',
    icon: '🛡️',
    duas: [
      Dua(
        title: 'Dua für Schutz (Ayat al-Kursi)',
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        transliteration: 'Allahu la ilaha illa huwal hayyul qayyum...',
        german: 'Allah – es gibt keinen Gott außer Ihm, dem Lebendigen, dem Beständigen...',
        english: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence...',
        source: 'Surah Al-Baqara 2:255',
      ),
      Dua(
        title: 'Dua bei Schmerz',
        arabic: 'بِسْمِ اللَّهِ (ثَلَاثًا) أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ',
        transliteration: 'Bismillah (3x) A\'udhu billahi wa qudratihi min sharri ma ajidu wa uhadhir',
        german: 'Im Namen Allahs (3x). Ich suche Zuflucht bei Allah und Seiner Macht vor dem Übel dessen, was ich empfinde und befürchte.',
        english: 'In the name of Allah (3x). I seek refuge with Allah and His power from the evil of what I feel and what I am wary of.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Dua für Kranke',
        arabic: 'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ',
        transliteration: 'Allahumma Rabban-nas, adhhib il-ba\'s, ishfi wa anta sh-Shafi, la shifa\'a illa shifa\'uk',
        german: 'O Allah, Herr der Menschen, nimm den Schmerz fort. Heile ihn/sie, Du bist der Heilende. Es gibt keine Heilung außer Deiner Heilung.',
        english: 'O Allah, Lord of mankind, remove the affliction and heal, for You are the Healer. There is no healing except Your healing.',
        source: 'Sahih al-Bukhari',
      ),
      Dua(
        title: 'Morgenschutz',
        arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        transliteration: 'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-\'alim',
        german: 'Im Namen Allahs, bei Dessen Namen nichts auf der Erde und im Himmel schaden kann, Er ist der Allhörende, der Allwissende.',
        english: 'In the name of Allah with Whose name nothing can cause harm on earth or in heaven, and He is the All-Hearing, All-Knowing.',
        source: 'Abu Dawud, Tirmidhi',
      ),
    ],
  ),
  DuaCategory(
    name: 'Moschee & Gebet',
    icon: '🕌',
    duas: [
      Dua(
        title: 'Beim Betreten der Moschee',
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: 'Allahumma iftah li abwaba rahmatik',
        german: 'O Allah, öffne mir die Tore Deiner Barmherzigkeit.',
        english: 'O Allah, open for me the gates of Your mercy.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Beim Verlassen der Moschee',
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        transliteration: 'Allahumma inni as\'aluka min fadlik',
        german: 'O Allah, ich bitte Dich um Deine Gnade.',
        english: 'O Allah, I ask You from Your bounty.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Nach dem Gebet (Tashahhud)',
        arabic: 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
        transliteration: 'At-tahiyyatu lillahi was-salawatu wat-tayyibat...',
        german: 'Alle Ehrerbietungen gehören Allah und die Gebete und das Gute. Friede sei mit dir, o Prophet, und die Barmherzigkeit Allahs und Seine Segnungen.',
        english: 'All greetings of humility are for Allah, and all prayers and goodness. Peace be upon you, O Prophet, and the mercy of Allah and His blessings.',
        source: 'Sahih al-Bukhari',
      ),
    ],
  ),
];
