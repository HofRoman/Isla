import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _today;
  late _HijriDate _hijriToday;
  late int _displayHijriMonth;
  late int _displayHijriYear;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _hijriToday = _toHijri(_today);
    _displayHijriMonth = _hijriToday.month;
    _displayHijriYear = _hijriToday.year;
  }

  void _prevMonth() {
    setState(() {
      if (_displayHijriMonth == 1) {
        _displayHijriMonth = 12;
        _displayHijriYear--;
      } else {
        _displayHijriMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_displayHijriMonth == 12) {
        _displayHijriMonth = 1;
        _displayHijriYear++;
      } else {
        _displayHijriMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Hijri-Kalender', style: AppTheme.titleStyle(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateHeader(),
            const SizedBox(height: 16),
            _buildCalendarCard(),
            const SizedBox(height: 16),
            _buildIslamicEvents(),
            const SizedBox(height: 16),
            _buildHijriMonths(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'التَّقْوِيم الهِجْرِي',
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 28,
              color: AppTheme.accentGold,
              height: 1.5,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dateBlock(
                'Heute Hijri',
                '${_hijriToday.day} ${_hijriMonthName(_hijriToday.month)} ${_hijriToday.year}',
                '🌙',
              ),
              Container(width: 1, height: 60, color: Colors.white24),
              _dateBlock(
                'Gregorianisch',
                _formatGregorian(_today),
                '📅',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
            ),
            child: Text(
              'Islamisches Jahr: ${_hijriToday.year} n.H.',
              style: GoogleFonts.lato(fontSize: 13, color: AppTheme.accentGold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _dateBlock(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(value,
            style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Text(label, style: AppTheme.bodyStyle(fontSize: 11, color: Colors.white60)),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigator
          Row(
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: const Icon(Icons.chevron_left, color: AppTheme.black),
              ),
              Expanded(
                child: Text(
                  '${_hijriMonthName(_displayHijriMonth)} $_displayHijriYear H',
                  style: AppTheme.titleStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                _hijriMonthArabic(_displayHijriMonth),
                style: TextStyle(
                  fontFamily: 'Scheherazade New',
                  fontSize: 18,
                  color: AppTheme.mediumGrey,
                  height: 1.6,
                ),
                textDirection: TextDirection.rtl,
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right, color: AppTheme.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Day headers
          Row(
            children: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'].map((d) {
              final isFriday = d == 'Fr';
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isFriday ? AppTheme.accentGold : AppTheme.mediumGrey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Days grid
          _buildDaysGrid(),
        ],
      ),
    ).animate(delay: 150.ms).fadeIn();
  }

  Widget _buildDaysGrid() {
    // Approximate: get the Gregorian date for the 1st of the displayed Hijri month
    final firstGreg = _hijriToGregorian(_HijriDate(_displayHijriYear, _displayHijriMonth, 1));
    final startWeekday = firstGreg.weekday % 7; // 0=Sunday
    final daysInMonth = _hijriDaysInMonth(_displayHijriYear, _displayHijriMonth);
    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final day = cellIndex - startWeekday + 1;
            final isValid = day >= 1 && day <= daysInMonth;
            final isToday = isValid &&
                day == _hijriToday.day &&
                _displayHijriMonth == _hijriToday.month &&
                _displayHijriYear == _hijriToday.year;
            final isFriday = col == 5;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                height: 36,
                decoration: BoxDecoration(
                  color: isToday ? AppTheme.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isValid
                      ? Text(
                          '$day',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday
                                ? Colors.white
                                : isFriday
                                    ? AppTheme.accentGold
                                    : AppTheme.black,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildIslamicEvents() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Islamische Ereignisse', style: AppTheme.titleStyle(fontSize: 19))
              .animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 12),
          ..._islamicEvents.map((e) => _buildEventCard(e)),
        ],
      ),
    );
  }

  Widget _buildEventCard(_IslamicEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
      ),
      child: Row(
        children: [
          Text(e.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name, style: AppTheme.titleStyle(fontSize: 15)),
                Text(e.hijriDate, style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey)),
                const SizedBox(height: 4),
                Text(e.description, style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.softBlack)),
              ],
            ),
          ),
          Text(
            e.arabicName,
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 18,
              color: AppTheme.mediumGrey,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    ).animate(delay: 250.ms).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildHijriMonths() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Die 12 Hijri-Monate', style: AppTheme.titleStyle(fontSize: 19))
              .animate(delay: 400.ms).fadeIn(),
          const SizedBox(height: 12),
          ...List.generate(12, (i) {
            final num = i + 1;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: num == _hijriToday.month ? AppTheme.black : AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: num == _hijriToday.month ? Colors.white.withOpacity(0.15) : AppTheme.white,
                    ),
                    child: Center(
                      child: Text(
                        '$num',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: num == _hijriToday.month ? Colors.white : AppTheme.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _hijriMonthName(num),
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: num == _hijriToday.month ? Colors.white : AppTheme.black,
                      ),
                    ),
                  ),
                  Text(
                    _hijriMonthArabic(num),
                    style: TextStyle(
                      fontFamily: 'Scheherazade New',
                      fontSize: 18,
                      color: num == _hijriToday.month ? AppTheme.accentGold : AppTheme.mediumGrey,
                      height: 1.6,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 400 + i * 40)).fadeIn();
          }),
        ],
      ),
    );
  }

  // ── Hijri conversion (simplified Kuwaiti algorithm) ──────────────────
  _HijriDate _toHijri(DateTime date) {
    // Approximate conversion (Kuwaiti algorithm)
    int jd = _gregorianToJD(date.year, date.month, date.day);
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) ~/ 10631);
    l = l - 10631 * n + 354;
    int j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
    int month = ((24 * l) ~/ 709);
    int day = l - ((709 * month) ~/ 24);
    int year = 30 * n + j - 30;
    return _HijriDate(year, month, day);
  }

  DateTime _hijriToGregorian(_HijriDate h) {
    // Reverse approximate conversion
    int n = h.year;
    int m = h.month;
    int d = h.day;
    int jd = (11 * n + 3) ~/ 30 +
        354 * n +
        30 * m -
        ((m - 1) ~/ 2) +
        d +
        1948440 -
        385;
    return _jdToGregorian(jd);
  }

  int _gregorianToJD(int y, int m, int d) {
    return (1461 * (y + 4800 + (m - 14) ~/ 12)) ~/ 4 +
        (367 * (m - 2 - 12 * ((m - 14) ~/ 12))) ~/ 12 -
        (3 * ((y + 4900 + (m - 14) ~/ 12) ~/ 100)) ~/ 4 +
        d -
        32075;
  }

  DateTime _jdToGregorian(int jd) {
    int l = jd + 68569;
    int n = (4 * l) ~/ 146097;
    l = l - (146097 * n + 3) ~/ 4;
    int i = (4000 * (l + 1)) ~/ 1461001;
    l = l - (1461 * i) ~/ 4 + 31;
    int j = (80 * l) ~/ 2447;
    int d = l - (2447 * j) ~/ 80;
    l = j ~/ 11;
    int m = j + 2 - 12 * l;
    int y = 100 * (n - 49) + i + l;
    return DateTime(y, m, d);
  }

  int _hijriDaysInMonth(int year, int month) {
    // Months 1,3,5,7,9,11 = 30 days; 2,4,6,8,10,12 = 29 days (last in leap year 30)
    if (month % 2 == 1) return 30;
    if (month == 12 && (11 * year + 14) % 30 < 11) return 30;
    return 29;
  }

  String _formatGregorian(DateTime d) {
    final months = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];
    return '${d.day}. ${months[d.month - 1]} ${d.year}';
  }

  String _hijriMonthName(int m) {
    const names = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi ath-Thani',
      'Dschumada al-Ula', 'Dschumada ath-Thaniya', 'Radschab', 'Schaban',
      'Ramadan', 'Schawwal', 'Dhul-Qaida', 'Dhul-Hijja',
    ];
    return names[m - 1];
  }

  String _hijriMonthArabic(int m) {
    const names = [
      'مُحَرَّم', 'صَفَر', 'رَبِيع الأَوَّل', 'رَبِيع الثَّاني',
      'جُمَادَى الأُولَى', 'جُمَادَى الآخِرَة', 'رَجَب', 'شَعْبَان',
      'رَمَضَان', 'شَوَّال', 'ذُو القَعْدَة', 'ذُو الحِجَّة',
    ];
    return names[m - 1];
  }
}

class _HijriDate {
  final int year, month, day;
  const _HijriDate(this.year, this.month, this.day);
}

class _IslamicEvent {
  final String name;
  final String arabicName;
  final String hijriDate;
  final String description;
  final String icon;

  const _IslamicEvent({
    required this.name,
    required this.arabicName,
    required this.hijriDate,
    required this.description,
    required this.icon,
  });
}

const List<_IslamicEvent> _islamicEvents = [
  _IslamicEvent(
    name: 'Islamisches Neujahr',
    arabicName: 'رَأْس السَّنَة الهِجْرِيَّة',
    hijriDate: '1. Muharram',
    description: 'Beginn des islamischen Jahres. Der Monat Muharram ist einer der heiligen Monate.',
    icon: '🌙',
  ),
  _IslamicEvent(
    name: 'Aschura',
    arabicName: 'عَاشُورَاء',
    hijriDate: '10. Muharram',
    description: 'Fasten am Tag der Aschura sühnt die Sünden des vergangenen Jahres.',
    icon: '✨',
  ),
  _IslamicEvent(
    name: 'Maulid an-Nabi',
    arabicName: 'مَوْلِد النَّبِي',
    hijriDate: '12. Rabi al-Awwal',
    description: 'Geburtstag des Propheten Muhammad (ﷺ) im Jahr 570 n.Chr.',
    icon: '☪️',
  ),
  _IslamicEvent(
    name: 'Isra wa Miradsch',
    arabicName: 'الإِسْرَاء وَالمِعْرَاج',
    hijriDate: '27. Radschab',
    description: 'Nachtreise des Propheten (ﷺ) von Mekka nach Jerusalem und Himmelfahrt.',
    icon: '🌟',
  ),
  _IslamicEvent(
    name: 'Ramadan Beginn',
    arabicName: 'رَمَضَان',
    hijriDate: '1. Ramadan',
    description: 'Beginn des heiligen Fastenmonats. Der Koran wurde in diesem Monat herabgesandt.',
    icon: '🌒',
  ),
  _IslamicEvent(
    name: 'Lailat al-Qadr',
    arabicName: 'لَيْلَة القَدْر',
    hijriDate: '27. Ramadan (wahrscheinlich)',
    description: 'Die Nacht der Macht – besser als tausend Monate (Sure 97).',
    icon: '💫',
  ),
  _IslamicEvent(
    name: 'Eid al-Fitr',
    arabicName: 'عِيد الفِطْر',
    hijriDate: '1. Schawwal',
    description: 'Fest des Fastenbrechens nach dem Ramadan. Eines der zwei großen Feste im Islam.',
    icon: '🎉',
  ),
  _IslamicEvent(
    name: 'Tag von Arafat',
    arabicName: 'يَوْم عَرَفَة',
    hijriDate: '9. Dhul-Hijja',
    description: 'Höhepunkt der Pilgerfahrt (Hadj). Fasten an diesem Tag sühnt zwei Jahre.',
    icon: '⛰️',
  ),
  _IslamicEvent(
    name: 'Eid al-Adha',
    arabicName: 'عِيد الأَضْحَى',
    hijriDate: '10. Dhul-Hijja',
    description: 'Opferfest – Gedenken an Ibrahims Bereitschaft, seinen Sohn zu opfern.',
    icon: '🐑',
  ),
];
