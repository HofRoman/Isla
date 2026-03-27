import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'quiz_screen.dart';
import 'prayer_screen.dart';
import 'names_screen.dart';
import 'qibla_screen.dart';
import 'hadith_screen.dart';
import 'duas_screen.dart';
import 'prophet_stories_screen.dart';
import 'calendar_screen.dart';
import 'sunnah_screen.dart';
import 'khatma_screen.dart';
import 'wisdom_screen.dart';
import 'salah_tracker_screen.dart';
import 'azkar_screen.dart';
import 'zakat_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _go(BuildContext context, Widget screen) {
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
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.bg,
            floating: true,
            automaticallyImplyLeading: false,
            title: Text('Entdecken', style: AppTheme.display(size: 28)),
            centerTitle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  context,
                  'Persönlich',
                  0,
                  [
                    _MoreItem('Salah Tracker', 'Tägliche Gebete verfolgen', '🕌',
                        () => _go(context, const SalahTrackerScreen())),
                    _MoreItem('Azkar', 'Morgen- & Abend-Gebetsformeln', '🌿',
                        () => _go(context, const AzkarScreen())),
                    _MoreItem('Sunnah Checkliste', 'Prophetische Handlungen täglich', '📿',
                        () => _go(context, const SunnahScreen())),
                    _MoreItem('Khatma Tracker', 'Koran-Lektüre verfolgen', '📖',
                        () => _go(context, const KhatmaScreen())),
                  ],
                ),
                _buildSection(
                  context,
                  'Wissen',
                  1,
                  [
                    _MoreItem('Quiz', 'Islamisches Wissen testen', '🧠',
                        () => _go(context, const QuizScreen())),
                    _MoreItem('Prophetengeschichten', 'Qisas al-Anbiya', '⭐',
                        () => _go(context, const ProphetStoriesScreen())),
                    _MoreItem('Hadith', 'Hadith des Tages', '📜',
                        () => _go(context, const HadithScreen())),
                    _MoreItem('99 Namen Allahs', 'Asma ul-Husna', '✨',
                        () => _go(context, const NamesScreen())),
                  ],
                ),
                _buildSection(
                  context,
                  'Praxis',
                  2,
                  [
                    _MoreItem('Duas', 'Tagesgebete & Schutz', '🤲',
                        () => _go(context, const DuasScreen())),
                    _MoreItem('Gebet & Wudu', 'Anleitungen & Dhikr-Duas', '🫧',
                        () => _go(context, const PrayerScreen())),
                    _MoreItem('Qibla-Kompass', 'Richtung nach Mekka', '🧭',
                        () => _go(context, const QiblaScreen())),
                    _MoreItem('Hijri-Kalender', 'Islamischer Kalender', '🌙',
                        () => _go(context, const CalendarScreen())),
                  ],
                ),
                _buildSection(
                  context,
                  'Inspiration',
                  3,
                  [
                    _MoreItem('Islamische Weisheiten', 'Verse & Hadithe als Kunstwerke', '💫',
                        () => _go(context, const WisdomScreen())),
                    _MoreItem('Zakat Rechner', 'Zakat berechnen & erklären', '⚖️',
                        () => _go(context, const ZakatScreen())),
                  ],
                ),
                const SizedBox(height: 28),
                _buildStatsCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext ctx, String title, int sectionIndex, List<_MoreItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(
          title.toUpperCase(),
          style: AppTheme.label(size: 12, color: AppTheme.ink3).copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return _buildRow(ctx, e.value, isLast);
            }).toList(),
          ),
        ),
      ],
    ).animate(delay: Duration(milliseconds: 80 + sectionIndex * 60)).fadeIn().slideY(begin: 0.06);
  }

  Widget _buildRow(BuildContext ctx, _MoreItem item, bool isLast) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(20))
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(item.icon, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: AppTheme.body(size: 15, weight: FontWeight.w600)),
                      Text(item.subtitle, style: AppTheme.caption()),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppTheme.ink3, size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 72, endIndent: 0, color: AppTheme.separator),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, p, _) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.ink,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Meine Statistiken', style: AppTheme.title(size: 17, color: Colors.white)),
                const Spacer(),
                Text('بِسْمِ اللَّهِ', style: AppTheme.arabic(size: 16, color: AppTheme.gold)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _stat('🔥', '${p.salahStreak}', 'Salah\nSerie'),
                _stat('📿', '${p.totalDhikr}', 'Gesamt\nDhikr'),
                _stat('🏆', '${p.quizHighScore}', 'Best\nScore'),
                _stat('📖', '${p.completedSurahCount}', 'Suren\ngelesen'),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _stat(String icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(value, style: AppTheme.title(size: 20, color: Colors.white)),
          const SizedBox(height: 3),
          Text(label, style: AppTheme.caption(size: 10, color: Colors.white54), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MoreItem {
  final String title, subtitle, icon;
  final VoidCallback onTap;
  const _MoreItem(this.title, this.subtitle, this.icon, this.onTap);
}
