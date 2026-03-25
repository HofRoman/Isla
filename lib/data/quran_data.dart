class QuranVerse {
  final int surahNumber;
  final int verseNumber;
  final String arabic;
  final String germanBubenheim;
  final String english;

  const QuranVerse({
    required this.surahNumber,
    required this.verseNumber,
    required this.arabic,
    required this.germanBubenheim,
    required this.english,
  });
}

class QuranSurah {
  final int number;
  final String nameArabic;
  final String nameGerman;
  final String nameTransliteration;
  final String nameEnglish;
  final int versesCount;
  final String revelationType;
  final List<QuranVerse> verses;

  const QuranSurah({
    required this.number,
    required this.nameArabic,
    required this.nameGerman,
    required this.nameTransliteration,
    required this.nameEnglish,
    required this.versesCount,
    required this.revelationType,
    required this.verses,
  });
}

final List<QuranSurah> quranSurahs = [
  QuranSurah(
    number: 1,
    nameArabic: 'الْفَاتِحَة',
    nameGerman: 'Die Eröffnende',
    nameTransliteration: 'Al-Fatiha',
    nameEnglish: 'The Opening',
    versesCount: 7,
    revelationType: 'Mekkanisch',
    verses: [
      QuranVerse(
        surahNumber: 1,
        verseNumber: 1,
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        germanBubenheim: 'Im Namen Allahs, des Allerbarmers, des Barmherzigen.',
        english: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 2,
        arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        germanBubenheim: 'Alles Lob gebührt Allah, dem Herrn der Welten,',
        english: 'All praise is due to Allah, Lord of the worlds -',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 3,
        arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
        germanBubenheim: 'dem Allerbarmer, dem Barmherzigen,',
        english: 'The Entirely Merciful, the Especially Merciful,',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 4,
        arabic: 'مَالِكِ يَوْمِ الدِّينِ',
        germanBubenheim: 'dem Herrscher am Tag des Gerichts.',
        english: 'Sovereign of the Day of Recompense.',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 5,
        arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        germanBubenheim: 'Dir allein dienen wir, und Dich allein bitten wir um Hilfe.',
        english: 'It is You we worship and You we ask for help.',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 6,
        arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        germanBubenheim: 'Leite uns den geraden Weg,',
        english: 'Guide us to the straight path -',
      ),
      QuranVerse(
        surahNumber: 1,
        verseNumber: 7,
        arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        germanBubenheim: 'den Weg derer, denen Du Gunst erwiesen hast, nicht derjenigen, die (Deinen) Zorn erregt haben, und nicht der Irregehenden.',
        english: 'The path of those upon whom You have bestowed favor, not of those who have evoked (Your) anger or of those who are astray.',
      ),
    ],
  ),
  QuranSurah(
    number: 2,
    nameArabic: 'الْبَقَرَة',
    nameGerman: 'Die Kuh',
    nameTransliteration: 'Al-Baqara',
    nameEnglish: 'The Cow',
    versesCount: 286,
    revelationType: 'Medinensisch',
    verses: [
      QuranVerse(
        surahNumber: 2,
        verseNumber: 1,
        arabic: 'الم',
        germanBubenheim: 'Alif. Lam. Mim.',
        english: 'Alif, Lam, Meem.',
      ),
      QuranVerse(
        surahNumber: 2,
        verseNumber: 2,
        arabic: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ',
        germanBubenheim: 'Das ist das Buch, an dem kein Zweifel ist, eine Rechtleitung für die Gottesfürchtigen,',
        english: 'This is the Book about which there is no doubt, a guidance for those conscious of Allah -',
      ),
      QuranVerse(
        surahNumber: 2,
        verseNumber: 3,
        arabic: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
        germanBubenheim: 'die an das Verborgene glauben und das Gebet verrichten und von dem, womit Wir sie versorgt haben, ausgeben,',
        english: 'Who believe in the unseen, establish prayer, and spend out of what We have provided for them,',
      ),
      QuranVerse(
        surahNumber: 2,
        verseNumber: 255,
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
        germanBubenheim: 'Allah - es gibt keinen Gott außer Ihm, dem Lebendigen, dem Beständigen. Weder Schlummer noch Schlaf überkommen Ihn. Ihm gehört, was in den Himmeln und was auf der Erde ist. Wer ist es, der bei Ihm Fürsprache einlegen kann außer mit Seiner Erlaubnis? Er weiß, was vor ihnen und was hinter ihnen liegt. Und sie umfassen nichts von Seinem Wissen, außer was Er will. Sein Thronsessel umfasst die Himmel und die Erde, und ihre Bewahrung bereitet Ihm keine Last. Und Er ist der Erhabene, der Mächtige.',
        english: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      ),
      QuranVerse(
        surahNumber: 2,
        verseNumber: 256,
        arabic: 'لَا إِكْرَاهَ فِي الدِّينِ ۖ قَد تَّبَيَّنَ الرُّشْدُ مِنَ الْغَيِّ',
        germanBubenheim: 'Es gibt keinen Zwang in der Religion. Der rechte Weg hat sich vom Irrweg klar unterschieden.',
        english: 'There shall be no compulsion in (acceptance of) the religion. The right course has become clear from the wrong.',
      ),
    ],
  ),
  QuranSurah(
    number: 112,
    nameArabic: 'الْإِخْلَاص',
    nameGerman: 'Die Aufrichtigkeit',
    nameTransliteration: 'Al-Ikhlas',
    nameEnglish: 'The Sincerity',
    versesCount: 4,
    revelationType: 'Mekkanisch',
    verses: [
      QuranVerse(
        surahNumber: 112,
        verseNumber: 1,
        arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        germanBubenheim: 'Sag: Er ist Allah, ein Einziger,',
        english: 'Say, "He is Allah, (who is) One,',
      ),
      QuranVerse(
        surahNumber: 112,
        verseNumber: 2,
        arabic: 'اللَّهُ الصَّمَدُ',
        germanBubenheim: 'Allah, der Beständige.',
        english: 'Allah, the Eternal Refuge.',
      ),
      QuranVerse(
        surahNumber: 112,
        verseNumber: 3,
        arabic: 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        germanBubenheim: 'Er hat nicht gezeugt und ist nicht gezeugt worden,',
        english: 'He neither begets nor is born,',
      ),
      QuranVerse(
        surahNumber: 112,
        verseNumber: 4,
        arabic: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        germanBubenheim: 'und niemand ist Ihm ebenbürtig.',
        english: 'Nor is there to Him any equivalent."',
      ),
    ],
  ),
  QuranSurah(
    number: 113,
    nameArabic: 'الْفَلَق',
    nameGerman: 'Das Morgengrauen',
    nameTransliteration: 'Al-Falaq',
    nameEnglish: 'The Daybreak',
    versesCount: 5,
    revelationType: 'Mekkanisch',
    verses: [
      QuranVerse(
        surahNumber: 113,
        verseNumber: 1,
        arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        germanBubenheim: 'Sag: Ich suche Zuflucht beim Herrn des Morgengrauens',
        english: 'Say, "I seek refuge in the Lord of daybreak',
      ),
      QuranVerse(
        surahNumber: 113,
        verseNumber: 2,
        arabic: 'مِن شَرِّ مَا خَلَقَ',
        germanBubenheim: 'vor dem Übel dessen, was Er erschaffen hat,',
        english: 'From the evil of that which He created',
      ),
      QuranVerse(
        surahNumber: 113,
        verseNumber: 3,
        arabic: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        germanBubenheim: 'und vor dem Übel der Finsternis, wenn sie sich ausbreitet,',
        english: 'And from the evil of darkness when it settles',
      ),
      QuranVerse(
        surahNumber: 113,
        verseNumber: 4,
        arabic: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
        germanBubenheim: 'und vor dem Übel derer, die in die Knoten blasen,',
        english: 'And from the evil of the blowers in knots',
      ),
      QuranVerse(
        surahNumber: 113,
        verseNumber: 5,
        arabic: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        germanBubenheim: 'und vor dem Übel eines Neidischen, wenn er neidet.',
        english: 'And from the evil of an envier when he envies."',
      ),
    ],
  ),
  QuranSurah(
    number: 114,
    nameArabic: 'النَّاس',
    nameGerman: 'Die Menschen',
    nameTransliteration: 'An-Nas',
    nameEnglish: 'The Mankind',
    versesCount: 6,
    revelationType: 'Mekkanisch',
    verses: [
      QuranVerse(
        surahNumber: 114,
        verseNumber: 1,
        arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        germanBubenheim: 'Sag: Ich suche Zuflucht beim Herrn der Menschen,',
        english: 'Say, "I seek refuge in the Lord of mankind,',
      ),
      QuranVerse(
        surahNumber: 114,
        verseNumber: 2,
        arabic: 'مَلِكِ النَّاسِ',
        germanBubenheim: 'dem König der Menschen,',
        english: 'The Sovereign of mankind.',
      ),
      QuranVerse(
        surahNumber: 114,
        verseNumber: 3,
        arabic: 'إِلَٰهِ النَّاسِ',
        germanBubenheim: 'dem Gott der Menschen,',
        english: 'The God of mankind,',
      ),
      QuranVerse(
        surahNumber: 114,
        verseNumber: 4,
        arabic: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
        germanBubenheim: 'vor dem Übel des flüsternden Einflüsterers,',
        english: 'From the evil of the retreating whisperer -',
      ),
      QuranVerse(
        surahNumber: 114,
        verseNumber: 5,
        arabic: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
        germanBubenheim: 'der in die Brust der Menschen einflüstert,',
        english: 'Who whispers (evil) into the breasts of mankind -',
      ),
      QuranVerse(
        surahNumber: 114,
        verseNumber: 6,
        arabic: 'مِنَ الْجِنَّةِ وَالنَّاسِ',
        germanBubenheim: 'aus den Dschinn und den Menschen.',
        english: 'From among the jinn and mankind."',
      ),
    ],
  ),
  QuranSurah(
    number: 36,
    nameArabic: 'يٰسٓ',
    nameGerman: 'Ya Sin',
    nameTransliteration: 'Ya-Sin',
    nameEnglish: 'Ya Sin',
    versesCount: 83,
    revelationType: 'Mekkanisch',
    verses: [
      QuranVerse(
        surahNumber: 36,
        verseNumber: 1,
        arabic: 'يٰسٓ',
        germanBubenheim: 'Ya Sin.',
        english: 'Ya, Seen.',
      ),
      QuranVerse(
        surahNumber: 36,
        verseNumber: 2,
        arabic: 'وَالْقُرْآنِ الْحَكِيمِ',
        germanBubenheim: 'Bei dem weisen Koran!',
        english: 'By the wise Quran.',
      ),
      QuranVerse(
        surahNumber: 36,
        verseNumber: 3,
        arabic: 'إِنَّكَ لَمِنَ الْمُرْسَلِينَ',
        germanBubenheim: 'Du gehörst wahrlich zu den Gesandten,',
        english: 'Indeed you, (O Muhammad), are from among the messengers,',
      ),
      QuranVerse(
        surahNumber: 36,
        verseNumber: 4,
        arabic: 'عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ',
        germanBubenheim: 'auf einem geraden Weg.',
        english: 'On a straight path.',
      ),
      QuranVerse(
        surahNumber: 36,
        verseNumber: 5,
        arabic: 'تَنزِيلَ الْعَزِيزِ الرَّحِيمِ',
        germanBubenheim: '(Dies ist) die Herabsendung des Allmächtigen, des Barmherzigen,',
        english: '(This is) a revelation of the Exalted in Might, the Especially Merciful,',
      ),
    ],
  ),
  QuranSurah(
    number: 55,
    nameArabic: 'الرَّحْمَٰن',
    nameGerman: 'Der Allerbarmer',
    nameTransliteration: 'Ar-Rahman',
    nameEnglish: 'The Beneficent',
    versesCount: 78,
    revelationType: 'Medinensisch',
    verses: [
      QuranVerse(
        surahNumber: 55,
        verseNumber: 1,
        arabic: 'الرَّحْمَٰنُ',
        germanBubenheim: 'Der Allerbarmer,',
        english: 'The Most Merciful',
      ),
      QuranVerse(
        surahNumber: 55,
        verseNumber: 2,
        arabic: 'عَلَّمَ الْقُرْآنَ',
        germanBubenheim: 'hat den Koran gelehrt.',
        english: 'Taught the Quran,',
      ),
      QuranVerse(
        surahNumber: 55,
        verseNumber: 3,
        arabic: 'خَلَقَ الْإِنسَانَ',
        germanBubenheim: 'Er hat den Menschen erschaffen,',
        english: 'Created man,',
      ),
      QuranVerse(
        surahNumber: 55,
        verseNumber: 4,
        arabic: 'عَلَّمَهُ الْبَيَانَ',
        germanBubenheim: 'hat ihn die Rede gelehrt.',
        english: '(And) taught him eloquence.',
      ),
      QuranVerse(
        surahNumber: 55,
        verseNumber: 13,
        arabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
        germanBubenheim: 'Welche der Wohltaten eures Herrn wollt ihr beide leugnen?',
        english: 'So which of the favors of your Lord would you deny?',
      ),
    ],
  ),
];
