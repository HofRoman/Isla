import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'quiz_screen.dart';
import 'quran_screen.dart';
import 'prayer_screen.dart';
import 'dhikr_screen.dart';
import 'names_screen.dart';
import 'qibla_screen.dart';
import 'hadith_screen.dart';
import 'duas_screen.dart';
import 'prophet_stories_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  final List<_FeatureCard> _features = const [
    _FeatureCard(
      title: 'Quiz',
      subtitle: 'Islamisches Wissen testen',
      arabicLabel: 'اختبار',
      icon: '🧠',
      tag: 'quiz',
    ),
    _FeatureCard(
      title: 'Koran',
      subtitle: 'Lesen & Übersetzen',
      arabicLabel: 'القرآن الكريم',
      icon: '📖',
      tag: 'quran',
    ),
    _FeatureCard(
      title: 'Qibla-Kompass',
      subtitle: 'Richtung nach Mekka',
      arabicLabel: 'القِبْلَة',
      icon: '🧭',
      tag: 'qibla',
    ),
    _FeatureCard(
      title: 'Gebetszeiten',
      subtitle: 'Die 5 täglichen Gebete',
      arabicLabel: 'الصلاة',
      icon: '🕌',
      tag: 'prayer',
    ),
    _FeatureCard(
      title: 'Dhikr',
      subtitle: 'Zikr & Tasbih Zähler',
      arabicLabel: 'ذِكْر',
      icon: '📿',
      tag: 'dhikr',
    ),
    _FeatureCard(
      title: '99 Namen',
      subtitle: 'Asma ul-Husna',
      arabicLabel: 'أسماء الله الحسنى',
      icon: '✨',
      tag: 'names',
    ),
    _FeatureCard(
      title: 'Hadith',
      subtitle: 'Hadith des Tages',
      arabicLabel: 'الْحَدِيث',
      icon: '📜',
      tag: 'hadith',
    ),
    _FeatureCard(
      title: 'Duas',
      subtitle: 'Tagesgebete & Schutz',
      arabicLabel: 'الدُّعَاء',
      icon: '🤲',
      tag: 'duas',
    ),
    _FeatureCard(
      title: 'Prophetengeschichten',
      subtitle: 'Qisas al-Anbiya',
      arabicLabel: 'قِصَصُ الأَنْبِيَاء',
      icon: '⭐',
      tag: 'prophets',
    ),
    _FeatureCard(
      title: 'Hijri-Kalender',
      subtitle: 'Islamischer Kalender',
      arabicLabel: 'التَّقْوِيم الهِجْرِي',
      icon: '🌙',
      tag: 'calendar',
    ),
  ];

  void _navigate(BuildContext context, String tag) {
    Widget screen;
    switch (tag) {
      case 'quiz':
        screen = const QuizScreen();
        break;
      case 'quran':
        screen = const QuranScreen();
        break;
      case 'prayer':
        screen = const PrayerScreen();
        break;
      case 'dhikr':
        screen = const DhikrScreen();
        break;
      case 'names':
        screen = const NamesScreen();
        break;
      case 'qibla':
        screen = const QiblaScreen();
        break;
      case 'hadith':
        screen = const HadithScreen();
        break;
      case 'duas':
        screen = const DuasScreen();
        break;
      case 'prophets':
        screen = const ProphetStoriesScreen();
        break;
      case 'calendar':
        screen = const CalendarScreen();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildHeader(provider),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final feature = _features[i];
                    return _buildFeatureCard(ctx, feature, i);
                  },
                  childCount: _features.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: _buildDailyVerse(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بِسْمِ اللَّهِ',
                      style: TextStyle(
                        fontFamily: 'Scheherazade New',
                        fontSize: 26,
                        color: AppTheme.accentGold,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Im Namen Allahs',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Isla',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      'Islamische Wissens App',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.white60,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.4), width: 1.5),
                ),
                child: const Center(
                  child: Text('☪', style: TextStyle(fontSize: 34, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatChip('Dhikr', '${provider.totalDhikr}', '📿'),
              const SizedBox(width: 10),
              _buildStatChip('Bestpunktzahl', '${provider.quizHighScore}', '🏆'),
              const SizedBox(width: 10),
              _buildStatChip('Richtig', '${provider.totalCorrect}', '✅'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, String icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.lato(fontSize: 10, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _FeatureCard feature, int index) {
    return GestureDetector(
      onTap: () => _navigate(context, feature.tag),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigate(context, feature.tag),
            borderRadius: BorderRadius.circular(22),
            splashColor: AppTheme.black.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(feature.icon, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.title,
                          style: AppTheme.titleStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          feature.subtitle,
                          style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        feature.arabicLabel,
                        style: TextStyle(
                          fontFamily: 'Scheherazade New',
                          fontSize: 18,
                          color: AppTheme.mediumGrey,
                          height: 1.8,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + index * 80))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.15, curve: Curves.easeOut);
  }

  Widget _buildDailyVerse() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '✨',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Tagesvers',
                style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 26,
              color: AppTheme.black,
              height: 2.0,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          Text(
            '„Und wer Allah fürchtet, dem schafft Er einen Ausweg."',
            style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.softBlack),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Sure At-Talaq 65:2',
            style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }
}

class _FeatureCard {
  final String title;
  final String subtitle;
  final String arabicLabel;
  final String icon;
  final String tag;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.arabicLabel,
    required this.icon,
    required this.tag,
  });
}
