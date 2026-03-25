import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'quiz_screen.dart';
import 'qibla_screen.dart';
import 'hadith_screen.dart';
import 'duas_screen.dart';
import 'prophet_stories_screen.dart';
import 'calendar_screen.dart';
import 'wisdom_screen.dart';
import 'names_screen.dart';
import 'prayer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 5) return 'Gute Nacht';
    if (h < 12) return 'Guten Morgen';
    if (h < 17) return 'Guten Tag';
    if (h < 20) return 'Guten Abend';
    return 'Gute Nacht';
  }

  String _arabicGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'صَبَاحُ الْخَيْر';
    return 'مَسَاءُ الْخَيْر';
  }

  void _go(BuildContext context, Widget screen) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppTheme.bg,
            floating: true,
            automaticallyImplyLeading: false,
            expandedHeight: 0,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting(), style: AppTheme.body(size: 13, color: AppTheme.ink3)),
                    Text('Isla', style: AppTheme.display(size: 26)),
                  ],
                ),
                const Spacer(),
                Text('بِسْمِ اللَّهِ', style: AppTheme.arabic(size: 18, color: AppTheme.gold)),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Hero Card ─────────────────────────────
                _HeroCard(p: p).animate().fadeIn(duration: 500.ms).slideY(begin: 0.06),

                const SizedBox(height: 24),

                // ── Today's Salah Progress ────────────────
                _SalahProgressCard(p: p).animate(delay: 80.ms).fadeIn().slideY(begin: 0.06),

                const SizedBox(height: 24),

                // ── Section: Entdecken ────────────────────
                Text(
                  'ENTDECKEN',
                  style: AppTheme.label(size: 12, color: AppTheme.ink3).copyWith(letterSpacing: 1.2),
                ).animate(delay: 160.ms).fadeIn(),
                const SizedBox(height: 10),
                _QuickGrid(onTap: _go).animate(delay: 200.ms).fadeIn().slideY(begin: 0.06),

                const SizedBox(height: 24),

                // ── Daily Verse ──────────────────────────
                Text(
                  'TAGESVERS',
                  style: AppTheme.label(size: 12, color: AppTheme.ink3).copyWith(letterSpacing: 1.2),
                ).animate(delay: 280.ms).fadeIn(),
                const SizedBox(height: 10),
                _DailyVerse().animate(delay: 320.ms).fadeIn().slideY(begin: 0.06),

                const SizedBox(height: 24),

                // ── Quick Links Row ──────────────────────
                Text(
                  'SCHNELLZUGRIFF',
                  style: AppTheme.label(size: 12, color: AppTheme.ink3).copyWith(letterSpacing: 1.2),
                ).animate(delay: 380.ms).fadeIn(),
                const SizedBox(height: 10),
                _QuickLinksRow(onTap: _go).animate(delay: 420.ms).fadeIn().slideY(begin: 0.06),

              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Banner ─────────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final AppProvider p;
  const _HeroCard({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Crescent icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.5), width: 1.5),
                ),
                child: const Center(
                  child: Text('☪', style: TextStyle(fontSize: 26, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إسلا', style: AppTheme.arabic(size: 22, color: AppTheme.gold)),
                    Text(
                      'Islamische Wissens App',
                      style: AppTheme.caption(size: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                ),
                child: Text(
                  'بِسْمِ اللَّهِ',
                  style: AppTheme.arabic(size: 14, color: AppTheme.gold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              _statBox('🔥', '${p.salahStreak}', 'Salah\nSerie'),
              _divider(),
              _statBox('📿', '${p.totalDhikr}', 'Gesamt\nDhikr'),
              _divider(),
              _statBox('🏆', '${p.quizHighScore}', 'Quiz\nBestScore'),
              _divider(),
              _statBox('📖', '${p.completedSurahCount}', 'Suren\ngelesen'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String icon, String value, String label) => Expanded(
    child: Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.title(size: 18, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: AppTheme.caption(size: 9, color: Colors.white38), textAlign: TextAlign.center),
      ],
    ),
  );

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white12);
}

// ── Salah Progress Card ──────────────────────────────────────────────────
class _SalahProgressCard extends StatelessWidget {
  final AppProvider p;
  const _SalahProgressCard({required this.p});

  static const _prayers = [
    ('fajr', 'Fajr', 'الفجر'),
    ('dhuhr', 'Dhuhr', 'الظهر'),
    ('asr', 'Asr', 'العصر'),
    ('maghrib', 'Maghrib', 'المغرب'),
    ('isha', 'Isha', 'العشاء'),
  ];

  @override
  Widget build(BuildContext context) {
    final count = p.todayPrayerCount();
    final progress = count / 5.0;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Heutiges Gebet', style: AppTheme.title(size: 15)),
              const Spacer(),
              Text(
                '$count / 5',
                style: AppTheme.title(size: 15, color: count == 5 ? AppTheme.green : AppTheme.ink3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.separator,
              valueColor: AlwaysStoppedAnimation(count == 5 ? AppTheme.green : AppTheme.gold),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _prayers.map((prayer) {
              final done = p.isPrayerDone(prayer.$1);
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: done ? AppTheme.ink : AppTheme.bg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: done ? AppTheme.ink : AppTheme.separator,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : Text(prayer.$3, style: AppTheme.arabic(size: 10, color: AppTheme.ink3)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(prayer.$2, style: AppTheme.caption(size: 9)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Quick Grid ──────────────────────────────────────────────────────────
class _QuickGrid extends StatelessWidget {
  final void Function(BuildContext, Widget) onTap;
  const _QuickGrid({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _GridItem('Quiz', '🧠', 'Wissen testen', const QuizScreen()),
      _GridItem('Qibla', '🧭', 'Richtung Mekka', const QiblaScreen()),
      _GridItem('Hadithe', '📜', 'Hadith des Tages', const HadithScreen()),
      _GridItem('Duas', '🤲', 'Tagesgebete', const DuasScreen()),
      _GridItem('Propheten', '⭐', 'Qisas al-Anbiya', const ProphetStoriesScreen()),
      _GridItem('Kalender', '🌙', 'Hijri Kalender', const CalendarScreen()),
      _GridItem('99 Namen', '✨', 'Asma ul-Husna', const NamesScreen()),
      _GridItem('Weisheiten', '💫', 'Verse & Hadithe', const WisdomScreen()),
    ];

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => _gridCell(context, item)).toList(),
    );
  }

  Widget _gridCell(BuildContext context, _GridItem item) {
    return GestureDetector(
      onTap: () => onTap(context, item.screen),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5),
            Text(
              item.title,
              style: AppTheme.caption(size: 10, color: AppTheme.ink),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem {
  final String title, icon, subtitle;
  final Widget screen;
  const _GridItem(this.title, this.icon, this.subtitle, this.screen);
}

// ── Daily Verse ─────────────────────────────────────────────────────────
class _DailyVerse extends StatelessWidget {
  const _DailyVerse();

  @override
  Widget build(BuildContext context) {
    // Rotate verse by day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final verses = _verses;
    final v = verses[dayOfYear % verses.length];

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(v[2], style: AppTheme.label(size: 10, color: AppTheme.gold)),
              ),
              const Spacer(),
              Text('✨', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            v[0],
            style: AppTheme.arabic(size: 22, color: AppTheme.ink),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 14),
          Container(width: 40, height: 1, color: AppTheme.separator),
          const SizedBox(height: 14),
          Text(
            '„${v[1]}"',
            style: AppTheme.body(size: 14, color: AppTheme.ink2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static const _verses = [
    ['وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا', 'Und wer Allah fürchtet, dem schafft Er einen Ausweg.', 'At-Talaq 65:2'],
    ['إِنَّ مَعَ الْعُسْرِ يُسْرًا', 'Wahrlich, mit der Schwierigkeit kommt Erleichterung.', 'Al-Inshirah 94:6'],
    ['وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ', 'Und verzweifelt nicht an der Barmherzigkeit Allahs.', 'Yusuf 12:87'],
    ['حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ', 'Allah genügt uns, und Er ist der beste Sachwalter.', 'Al-Imran 3:173'],
    ['وَاللَّهُ يُحِبُّ الصَّابِرِينَ', 'Und Allah liebt die Geduldigen.', 'Al-Imran 3:146'],
    ['لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا', 'Allah belastet keine Seele über ihr Vermögen.', 'Al-Baqara 2:286'],
    ['وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ', 'Und Er ist mit euch, wo auch immer ihr seid.', 'Al-Hadid 57:4'],
  ];
}

// ── Quick Links Row ─────────────────────────────────────────────────────
class _QuickLinksRow extends StatelessWidget {
  final void Function(BuildContext, Widget) onTap;
  const _QuickLinksRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final links = [
      ('Gebet', '🫧', const PrayerScreen()),
      ('Qibla', '🧭', const QiblaScreen()),
      ('Kalender', '🌙', const CalendarScreen()),
      ('Weisheiten', '💫', const WisdomScreen()),
    ];

    return Row(
      children: List.generate(links.length, (idx) {
        final link = links[idx];
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(context, link.$3),
            child: Container(
              margin: EdgeInsets.only(right: idx < links.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                children: [
                  Text(link.$2, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(link.$1, style: AppTheme.caption(size: 10, color: AppTheme.ink)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
