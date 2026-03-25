class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
  });
}

class QuizCategory {
  final String name;
  final String icon;
  final List<QuizQuestion> questions;

  const QuizCategory({
    required this.name,
    required this.icon,
    required this.questions,
  });
}

final List<QuizCategory> quizCategories = [
  QuizCategory(
    name: 'Grundlagen',
    icon: '🕌',
    questions: [
      QuizQuestion(
        question: 'Was bedeutet das Wort "Islam"?',
        options: ['Friede', 'Hingabe/Unterwerfung', 'Glaube', 'Gebet'],
        correctIndex: 1,
        explanation:
            'Islam bedeutet "Hingabe" oder "Unterwerfung unter den Willen Allahs". Es leitet sich vom arabischen Wort "Salam" (Friede) ab.',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Wie viele Säulen hat der Islam?',
        options: ['3', '4', '5', '6'],
        correctIndex: 2,
        explanation:
            'Der Islam hat 5 Säulen: Schahada, Salah, Zakat, Saum und Hadj.',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Was ist die erste Säule des Islam?',
        options: ['Gebet (Salah)', 'Glaubensbekenntnis (Schahada)', 'Fasten (Saum)', 'Pilgerfahrt (Hadj)'],
        correctIndex: 1,
        explanation:
            'Die Schahada ist die Aussage: "Es gibt keinen Gott außer Allah und Muhammad ist sein Gesandter."',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Wie viele Glaubensartikel (Arkan al-Iman) gibt es?',
        options: ['4', '5', '6', '7'],
        correctIndex: 2,
        explanation:
            'Es gibt 6 Glaubensartikel: Glaube an Allah, die Engel, die Schriften, die Propheten, den Jüngsten Tag und das Schicksal (Qadar).',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'In welcher Stadt wurde Prophet Muhammad (ﷺ) geboren?',
        options: ['Medina', 'Jerusalem', 'Mekka', 'Taif'],
        correctIndex: 2,
        explanation:
            'Prophet Muhammad (ﷺ) wurde im Jahr 570 n. Chr. in Mekka geboren.',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Was ist die Hijra?',
        options: [
          'Die erste Offenbarung',
          'Die Auswanderung des Propheten nach Medina',
          'Das Gebet in der Nacht',
          'Der Beginn des Ramadan'
        ],
        correctIndex: 1,
        explanation:
            'Die Hijra (622 n. Chr.) bezeichnet die Auswanderung des Propheten Muhammad (ﷺ) von Mekka nach Medina. Sie markiert den Beginn des islamischen Kalenders.',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Wie heißt die heilige Stadt der Muslime in Saudi-Arabien?',
        options: ['Riad', 'Medina', 'Mekka', 'Dschidda'],
        correctIndex: 2,
        explanation:
            'Mekka ist die heiligste Stadt des Islam und Geburtsort des Propheten Muhammad (ﷺ). Die Kaaba befindet sich in der Masjid al-Haram in Mekka.',
        category: 'Grundlagen',
      ),
      QuizQuestion(
        question: 'Was ist das Shahada?',
        options: [
          'Das Pflichtgebet',
          'Das Glaubensbekenntnis',
          'Die Pilgerfahrt',
          'Das Fasten'
        ],
        correctIndex: 1,
        explanation:
            'Das Shahada ist das islamische Glaubensbekenntnis: "Aschadu an la ilaha illa Allah, wa aschadu anna Muhammadan rasul Allah."',
        category: 'Grundlagen',
      ),
    ],
  ),
  QuizCategory(
    name: 'Koran',
    icon: '📖',
    questions: [
      QuizQuestion(
        question: 'Wie viele Suren hat der Koran?',
        options: ['99', '112', '114', '120'],
        correctIndex: 2,
        explanation: 'Der Koran hat genau 114 Suren (Kapitel).',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'Wie heißt die erste Sure des Korans?',
        options: ['Al-Baqara', 'Al-Fatiha', 'Al-Ikhlas', 'Al-Nas'],
        correctIndex: 1,
        explanation:
            'Al-Fatiha ("Die Eröffnende") ist die erste Sure des Korans und wird in jedem Gebet rezitiert.',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'In welchem Monat wurde der Koran erstmals offenbart?',
        options: ['Rajab', 'Schaban', 'Ramadan', 'Dhul-Hijja'],
        correctIndex: 2,
        explanation:
            'Der Koran wurde im Monat Ramadan erstmals offenbart, in der Nacht der Macht (Lailat al-Qadr).',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'Was bedeutet "Bismillah"?',
        options: [
          'Alles Lob gebührt Allah',
          'Allah ist groß',
          'Im Namen Allahs',
          'Es gibt keinen Gott außer Allah'
        ],
        correctIndex: 2,
        explanation:
            '"Bismillah ir-Rahman ir-Rahim" bedeutet "Im Namen Allahs, des Allerbarmers, des Barmherzigen".',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'Welche Sure ist die längste im Koran?',
        options: ['Al-Imran', 'Al-Baqara', 'An-Nisa', 'Al-Maidah'],
        correctIndex: 1,
        explanation:
            'Al-Baqara ("Die Kuh") ist mit 286 Versen die längste Sure des Korans.',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'Was ist "Ayat al-Kursi"?',
        options: [
          'Ein Kapitel des Korans',
          'Der berühmteste Vers des Korans (2:255)',
          'Ein Gebet',
          'Ein Hadith'
        ],
        correctIndex: 1,
        explanation:
            'Ayat al-Kursi (Sure 2, Vers 255) ist der "Thronvers" und gilt als einer der bedeutendsten Verse des Korans.',
        category: 'Koran',
      ),
      QuizQuestion(
        question: 'Wie viele Verse (Ayat) hat der Koran ungefähr?',
        options: ['3.236', '6.236', '9.236', '12.236'],
        correctIndex: 1,
        explanation: 'Der Koran hat 6.236 Verse (Ayat).',
        category: 'Koran',
      ),
    ],
  ),
  QuizCategory(
    name: 'Propheten',
    icon: '☪️',
    questions: [
      QuizQuestion(
        question: 'Wie viele Propheten werden im Koran namentlich erwähnt?',
        options: ['20', '25', '30', '35'],
        correctIndex: 1,
        explanation:
            'Im Koran werden 25 Propheten namentlich erwähnt. Es wird jedoch gelehrt, dass es insgesamt 124.000 Propheten gab.',
        category: 'Propheten',
      ),
      QuizQuestion(
        question: 'Welcher Prophet wurde im Feuer nicht verletzt?',
        options: ['Musa (ﷺ)', 'Ibrahim (ﷺ)', 'Isa (ﷺ)', 'Nuh (ﷺ)'],
        correctIndex: 1,
        explanation:
            'Ibrahim (Abraham) wurde von Nimrod ins Feuer geworfen, aber Allah machte das Feuer kühl und sicher für ihn.',
        category: 'Propheten',
      ),
      QuizQuestion(
        question: 'Welcher Prophet ist als "Kalimullah" bekannt?',
        options: ['Ibrahim (ﷺ)', 'Muhammad (ﷺ)', 'Musa (ﷺ)', 'Isa (ﷺ)'],
        correctIndex: 2,
        explanation:
            'Musa (Moses) wird als "Kalimullah" (Der mit Allah Sprechende) bezeichnet, da Allah direkt mit ihm sprach.',
        category: 'Propheten',
      ),
      QuizQuestion(
        question: 'Welcher Prophet baute die Kaaba?',
        options: ['Nuh (ﷺ)', 'Musa (ﷺ)', 'Ibrahim (ﷺ) und Ismail (ﷺ)', 'Dawud (ﷺ)'],
        correctIndex: 2,
        explanation:
            'Ibrahim und sein Sohn Ismail bauten die Kaaba in Mekka wieder auf, wie im Koran (2:127) beschrieben.',
        category: 'Propheten',
      ),
      QuizQuestion(
        question: 'Wer war der erste Mensch und Prophet?',
        options: ['Nuh (ﷺ)', 'Ibrahim (ﷺ)', 'Adam (ﷺ)', 'Idris (ﷺ)'],
        correctIndex: 2,
        explanation:
            'Adam (Friede sei mit ihm) war der erste Mensch und der erste Prophet, den Allah erschaffen hat.',
        category: 'Propheten',
      ),
      QuizQuestion(
        question: 'In welchem Alter starb Prophet Muhammad (ﷺ)?',
        options: ['55', '60', '63', '70'],
        correctIndex: 2,
        explanation:
            'Prophet Muhammad (ﷺ) starb im Jahr 632 n. Chr. im Alter von 63 Jahren in Medina.',
        category: 'Propheten',
      ),
    ],
  ),
  QuizCategory(
    name: 'Gebet & Ibadah',
    icon: '🤲',
    questions: [
      QuizQuestion(
        question: 'Wie viele Pflichtgebete hat ein Muslim pro Tag?',
        options: ['3', '4', '5', '6'],
        correctIndex: 2,
        explanation:
            'Ein Muslim verrichtet täglich 5 Pflichtgebete: Fajr, Dhuhr, Asr, Maghrib und Ischa.',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Wie viele Rakaat hat das Fajr-Gebet?',
        options: ['2', '3', '4', '6'],
        correctIndex: 0,
        explanation: 'Das Fajr-Gebet besteht aus 2 Fard-Rakaat (Pflicht-Rakaat).',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Was sagt man beim Beginn des Gebets?',
        options: ['Alhamdulillah', 'Allahu Akbar', 'Subhanallah', 'Bismillah'],
        correctIndex: 1,
        explanation:
            'Das Gebet wird mit der Takbirat al-Ihram "Allahu Akbar" (Allah ist am Größten) begonnen.',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Wie wird die Gebetsrichtung der Muslime genannt?',
        options: ['Salah', 'Wudu', 'Qibla', 'Hijab'],
        correctIndex: 2,
        explanation:
            'Die Qibla ist die Gebetsrichtung in Richtung der Kaaba in Mekka.',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Was ist Wudu?',
        options: ['Ein Gebet', 'Die rituelle Waschung', 'Eine Sure', 'Das Fasten'],
        correctIndex: 1,
        explanation:
            'Wudu ist die rituelle Reinigung (Waschung) vor dem Gebet. Sie umfasst das Waschen von Gesicht, Händen, Armen und Füßen.',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Wie viele Rakaat hat das Dhuhr-Gebet?',
        options: ['2', '3', '4', '6'],
        correctIndex: 2,
        explanation: 'Das Dhuhr-Gebet (Mittagsgebet) hat 4 Fard-Rakaat.',
        category: 'Gebet & Ibadah',
      ),
      QuizQuestion(
        question: 'Was ist Zakat?',
        options: [
          'Das Pflichtgebet',
          'Das Fasten im Ramadan',
          'Die Pflichtabgabe (Armensteuer)',
          'Die Pilgerfahrt'
        ],
        correctIndex: 2,
        explanation:
            'Zakat ist die jährliche Pflichtabgabe von 2,5% des Vermögens, das über dem Nisab (Mindestvermögen) liegt, an Bedürftige.',
        category: 'Gebet & Ibadah',
      ),
    ],
  ),
  QuizCategory(
    name: 'Geschichte',
    icon: '📜',
    questions: [
      QuizQuestion(
        question: 'In welchem Jahr begann die Offenbarung des Korans?',
        options: ['570 n. Chr.', '610 n. Chr.', '622 n. Chr.', '632 n. Chr.'],
        correctIndex: 1,
        explanation:
            'Die erste Offenbarung erfolgte im Jahr 610 n. Chr. in der Höhle Hira, als der Engel Jibril (Gabriel) zum Propheten kam.',
        category: 'Geschichte',
      ),
      QuizQuestion(
        question: 'Welche Stadt wird als die "Stadt des Propheten" bezeichnet?',
        options: ['Mekka', 'Jerusalem', 'Medina', 'Bagdad'],
        correctIndex: 2,
        explanation:
            'Medina (früher Yathrib) wird als "Madinat an-Nabi" (Stadt des Propheten) bezeichnet und ist nach Mekka die zweitheiligste Stadt des Islam.',
        category: 'Geschichte',
      ),
      QuizQuestion(
        question: 'Was war das erste Wort, das an den Propheten offenbart wurde?',
        options: ['Bismillah', 'Iqra (Lies!)', 'Alhamdulillah', 'Subhanallah'],
        correctIndex: 1,
        explanation:
            '"Iqra" (Lies/Rezitiere) war das erste Wort der Offenbarung, durch den Engel Jibril übermittelt (Sure 96, Al-Alaq).',
        category: 'Geschichte',
      ),
      QuizQuestion(
        question: 'Wie hieß die erste Frau, die zum Islam konvertierte?',
        options: ['Aisha', 'Fatima', 'Khadijah', 'Maryam'],
        correctIndex: 2,
        explanation:
            'Khadijah (Möge Allah mit ihr zufrieden sein), die erste Ehefrau des Propheten, war die erste Person, die zum Islam konvertierte.',
        category: 'Geschichte',
      ),
      QuizQuestion(
        question: 'Was ist die Bedeutung von "Al-Amin"?',
        options: ['Der Mutige', 'Der Vertrauenswürdige', 'Der Weise', 'Der Geduldige'],
        correctIndex: 1,
        explanation:
            '"Al-Amin" bedeutet "Der Vertrauenswürdige" und war der Ehrenname, den die Mekkaner dem Propheten Muhammad (ﷺ) gaben.',
        category: 'Geschichte',
      ),
    ],
  ),
];
