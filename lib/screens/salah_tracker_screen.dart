import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

const _prayers = [
  {'key': 'fajr',    'name': 'Fajr',    'arabic': 'الفَجْر',   'time': 'Morgengrauen', 'rakaat': 2,  'icon': '🌅'},
  {'key': 'dhuhr',   'name': 'Dhuhr',   'arabic': 'الظُّهْر',  'time': 'Mittag',       'rakaat': 4,  'icon': '☀️'},
  {'key': 'asr',     'name': 'Asr',     'arabic': 'الْعَصْر',  'time': 'Nachmittag',   'rakaat': 4,  'icon': '🌤️'},
  {'key': 'maghrib', 'name': 'Maghrib', 'arabic': 'الْمَغْرِب','time': 'Sonnenuntergang','rakaat': 3, 'icon': '🌇'},
  {'key': 'ischa',   'name': 'Ischa',   'arabic': 'الْعِشَاء', 'time': 'Nacht',         'rakaat': 4, 'icon': '🌙'},
];

class SalahTrackerScreen extends StatefulWidget {
  const SalahTrackerScreen({super.key});
  @override
  State<SalahTrackerScreen> createState() => _SalahTrackerScreenState();
}

class _SalahTrackerScreenState extends State<SalahTrackerScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  final _checkControllers = <String, AnimationController>{};

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    for (final p in _prayers) {
      _checkControllers[p['key'] as String] = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350),
      );
    }
    _ringController.forward();
  }

  @override
  void dispose() {
    _ringController.dispose();
    for (final c in _checkControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String get _weekday {
    const days = ['Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag','Sonntag'];
    return days[DateTime.now().weekday - 1];
  }

  String get _dateLabel {
    final now = DateTime.now();
    const months = ['Januar','Februar','März','April','Mai','Juni','Juli','August','September','Oktober','November','Dezember'];
    return '${now.day}. ${months[now.month - 1]} ${now.year}';
  }

  void _toggle(AppProvider p, String key) {
    HapticFeedback.mediumImpact();
    final wasDone = p.isPrayerDone(key);
    p.togglePrayer(key);
    if (!wasDone) {
      _checkControllers[key]!.forward(from: 0);
    } else {
      _checkControllers[key]!.reverse();
    }
    _ringController.reset();
    _ringController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        final count = provider.todayPrayerCount();
        final progress = count / 5.0;

        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(provider, count, progress),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStreakRow(provider),
                    const SizedBox(height: 20),
                    _buildPrayerLabel(),
                    const SizedBox(height: 12),
                    ..._prayers.asMap().entries.map(
                      (e) => _buildPrayerCard(e.key, e.value, provider),
                    ),
                    const SizedBox(height: 24),
                    _buildWeekHistory(provider),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(AppProvider provider, int count, double progress) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppTheme.bg,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.subtleShadow),
          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.ink),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF1C1C2E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(_weekday, style: AppTheme.label(color: Colors.white60)),
                const SizedBox(height: 4),
                Text(_dateLabel, style: AppTheme.body(color: Colors.white70)),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (ctx, _) => CustomPaint(
                    size: const Size(120, 120),
                    painter: _RingPainter(
                      progress: progress * _ringController.value,
                      count: count,
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$count/5',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Gebete',
                              style: AppTheme.label(size: 11, color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  count == 5 ? 'Alhamdulillah! Alle Gebete ✓' :
                  count == 0 ? 'Fang jetzt an – بِسْمِ اللَّه' :
                  '${5 - count} ${count == 4 ? 'Gebet' : 'Gebete'} verbleiben',
                  style: AppTheme.body(size: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakRow(AppProvider provider) {
    return Row(
      children: [
        _streakCard('🔥', '${provider.salahStreak}', 'Tage\nSerie', AppTheme.gold),
        const SizedBox(width: 12),
        _streakCard('✅', '${provider.todayPrayerCount()}', 'Heute\ngebetet', AppTheme.green),
        const SizedBox(width: 12),
        _streakCard('📅', '${provider.salahHistory.length}', 'Tage\ngetrackt', AppTheme.blue),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _streakCard(String icon, String value, String label, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value, style: AppTheme.title(size: 22, color: accent)),
            const SizedBox(height: 2),
            Text(label, style: AppTheme.caption(color: AppTheme.ink3), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerLabel() {
    return Text(
      'Heutige Gebete',
      style: AppTheme.title(size: 18),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildPrayerCard(int i, Map<String, Object> prayer, AppProvider provider) {
    final key = prayer['key'] as String;
    final isDone = provider.isPrayerDone(key);
    final ctrl = _checkControllers[key]!;

    // sync animation state
    if (isDone && ctrl.value < 0.5) ctrl.forward(from: ctrl.value);
    if (!isDone && ctrl.value > 0.5) ctrl.reverse();

    return GestureDetector(
      onTap: () => _toggle(provider, key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDone ? AppTheme.ink : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDone ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: ctrl,
              builder: (ctx, _) => Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppTheme.gold.withOpacity(0.15) : AppTheme.bg,
                  border: Border.all(
                    color: isDone ? AppTheme.gold : AppTheme.separator,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: ctrl.value > 0.5
                      ? ScaleTransition(
                          scale: CurvedAnimation(parent: ctrl, curve: Curves.elasticOut),
                          child: const Icon(Icons.check_rounded, color: AppTheme.gold, size: 24),
                        )
                      : Text(prayer['icon'] as String, style: const TextStyle(fontSize: 22)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayer['name'] as String,
                    style: AppTheme.title(
                      size: 17,
                      color: isDone ? Colors.white : AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    prayer['time'] as String,
                    style: AppTheme.caption(color: isDone ? Colors.white60 : AppTheme.ink3),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  prayer['arabic'] as String,
                  style: AppTheme.arabic(size: 20, color: isDone ? AppTheme.gold : AppTheme.ink2),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.white.withOpacity(0.1) : AppTheme.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${prayer['rakaat']} Rak.',
                    style: AppTheme.label(size: 10, color: isDone ? Colors.white60 : AppTheme.ink3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 200 + i * 70)).fadeIn().slideX(begin: 0.04);
  }

  Widget _buildWeekHistory(AppProvider provider) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diese Woche', style: AppTheme.title(size: 18))
            .animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final date = now.subtract(Duration(days: 6 - i));
              final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              final count = provider.salahHistory[key]?.prayed.length ?? 0;
              final isToday = i == 6;
              const days = ['Mo','Di','Mi','Do','Fr','Sa','So'];
              final dayLabel = days[date.weekday - 1];

              return Column(
                children: [
                  Text(dayLabel, style: AppTheme.caption(color: AppTheme.ink3)),
                  const SizedBox(height: 8),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: count == 5
                          ? AppTheme.ink
                          : count > 0
                              ? AppTheme.ink.withOpacity(0.15)
                              : AppTheme.bg,
                      border: isToday
                          ? Border.all(color: AppTheme.gold, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: count == 5
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : Text(
                              '$count',
                              style: AppTheme.label(
                                size: 13,
                                color: count > 0 ? AppTheme.ink : AppTheme.ink3,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.05),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final int count;

  _RingPainter({required this.progress, required this.count});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background ring
    canvas.drawCircle(center, radius, Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round);

    if (progress <= 0) return;

    // Progress ring
    final sweepAngle = 2 * math.pi * progress;
    final paint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [AppTheme.gold, AppTheme.goldLight, AppTheme.gold],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
