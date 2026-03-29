import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../utils/prayer_times.dart';
import '../utils/prayer_api_service.dart';
import 'quiz_screen.dart';
import 'qibla_screen.dart';
import 'hadith_screen.dart';
import 'duas_screen.dart';
import 'prophet_stories_screen.dart';
import 'calendar_screen.dart';
import 'wisdom_screen.dart';
import 'names_screen.dart';
import 'prayer_screen.dart';
import 'azkar_screen.dart';
import 'zakat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Location & times
  double _lat = 52.52, _lon = 13.405;
  String _cityName = 'Wird ermittelt...';
  bool _loadingLocation = true;
  bool _locationFailed = false;
  PrayerTimes? _times;
  double _qiblaBearing = 148.6;

  // Animations
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _compassCtrl;
  late Animation<double> _compassAnim;

  // Countdown
  Timer? _countdownTimer;
  String _countdown = '--:--';
  String _nextKey = '';

  static const _cities = [
    ('Berlin', 52.520, 13.405),
    ('München', 48.137, 11.576),
    ('Hamburg', 53.551, 9.994),
    ('Frankfurt', 50.110, 8.682),
    ('Köln', 50.938, 6.960),
    ('Stuttgart', 48.775, 9.182),
    ('Düsseldorf', 51.227, 6.773),
    ('Istanbul', 41.015, 28.979),
    ('Kairo', 30.045, 31.236),
    ('Dubai', 25.205, 55.270),
    ('London', 51.507, -0.127),
    ('Paris', 48.857, 2.352),
    ('Wien', 48.208, 16.373),
    ('Zürich', 47.376, 8.548),
  ];
  int _cityIdx = 0;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _compassCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _compassAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _compassCtrl, curve: Curves.easeOutCubic));

    _fetchLocation();
    _countdownTimer = Timer.periodic(const Duration(seconds: 30), (_) => _updateCountdown());
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _compassCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    try {
      bool svcEnabled = await Geolocator.isLocationServiceEnabled();
      if (!svcEnabled) throw Exception('service disabled');

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        throw Exception('permission denied');
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 10));

      _applyLocation(pos.latitude, pos.longitude, 'Aktueller Standort');
    } catch (_) {
      if (!mounted) return;
      setState(() { _locationFailed = true; });
      _applyLocation(52.52, 13.405, 'Berlin');
    }
  }

  void _applyLocation(double lat, double lon, String name) {
    if (!mounted) return;
    // Show local calc immediately, then replace with API result
    final times = PrayerTimes.calculate(lat: lat, lon: lon, date: DateTime.now());
    PrayerApiService.fetch(lat: lat, lon: lon).then((apiTimes) {
      if (mounted) setState(() => _prayerTimes = apiTimes);
      _updateCountdown();
    });
    setState(() {
      _lat = lat; _lon = lon;
      _cityName = name;
      _times = times;
      _qiblaBearing = _calcQibla(lat, lon);
      _loadingLocation = false;
    });
    _compassCtrl.forward(from: 0);
    _updateCountdown();
  }

  double _calcQibla(double lat, double lon) {
    const mLat = 21.4225, mLon = 39.8262;
    final φ1 = lat * math.pi / 180;
    final φ2 = mLat * math.pi / 180;
    final Δλ = (mLon - lon) * math.pi / 180;
    final y = math.sin(Δλ) * math.cos(φ2);
    final x = math.cos(φ1) * math.sin(φ2) - math.sin(φ1) * math.cos(φ2) * math.cos(Δλ);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  void _updateCountdown() {
    if (_times == null || !mounted) return;
    final now = DateTime.now();
    final next = _times!.nextPrayerTime(now);
    final diff = next.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    setState(() {
      _countdown = h > 0 ? '${h}h ${m}min' : '${m} min';
      _nextKey = _times!.nextPrayerKey(now);
    });
  }

  void _showCityPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: AppTheme.separator, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text('Stadt auswählen', style: AppTheme.title(size: 17)),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: _cities.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.separator),
              itemBuilder: (_, idx) {
                final selected = idx == _cityIdx;
                return ListTile(
                  title: Text(
                    _cities[idx].$1,
                    style: AppTheme.body(size: 15, weight: selected ? FontWeight.w700 : FontWeight.w400),
                  ),
                  trailing: selected ? const Icon(Icons.check_rounded, color: AppTheme.gold) : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _cityIdx = idx);
                    _applyLocation(_cities[idx].$2, _cities[idx].$3, _cities[idx].$1);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _go(Widget screen) {
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

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 5) return 'Gute Nacht';
    if (h < 12) return 'Guten Morgen';
    if (h < 17) return 'Guten Tag';
    if (h < 20) return 'Guten Abend';
    return 'Gute Nacht';
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────
          SliverAppBar(
            backgroundColor: AppTheme.bg,
            floating: true,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_greeting(), style: AppTheme.caption(size: 12, color: AppTheme.ink3)),
                    Text('Isla', style: AppTheme.display(size: 24)),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _locationFailed ? _showCityPicker : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _loadingLocation
                              ? Icons.location_searching_rounded
                              : _locationFailed
                                  ? Icons.location_on_outlined
                                  : Icons.location_on_rounded,
                          size: 13,
                          color: _locationFailed ? AppTheme.ink3 : AppTheme.green,
                        ),
                        const SizedBox(width: 4),
                        Text(_cityName, style: AppTheme.caption(size: 11)),
                        if (_locationFailed) ...[
                          const SizedBox(width: 2),
                          const Icon(Icons.expand_more_rounded, size: 13, color: AppTheme.ink3),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── 1. Qibla Compass Hero ─────────
                _buildQiblaHero(),
                const SizedBox(height: 16),

                // ── 2. Prayer Times ───────────────
                _buildPrayerCard(),
                const SizedBox(height: 28),

                // ── 3. Entdecken grid ─────────────
                Text('ENTDECKEN',
                  style: AppTheme.label(size: 11, color: AppTheme.ink3)
                      .copyWith(letterSpacing: 1.3),
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: 10),
                _buildQuickGrid(),
                const SizedBox(height: 28),

                // ── 4. Tagesvers ──────────────────
                Text('TAGESVERS',
                  style: AppTheme.label(size: 11, color: AppTheme.ink3)
                      .copyWith(letterSpacing: 1.3),
                ).animate(delay: 400.ms).fadeIn(),
                const SizedBox(height: 10),
                _buildDailyVerse(),
                const SizedBox(height: 28),

                // ── 5. Statistik ──────────────────
                Text('STATISTIK',
                  style: AppTheme.label(size: 11, color: AppTheme.ink3)
                      .copyWith(letterSpacing: 1.3),
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 10),
                _buildStatsCard(p),

              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Qibla Compass Hero ────────────────────────────────────────────────────
  Widget _buildQiblaHero() {
    if (_loadingLocation) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppTheme.ink,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 28, height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppTheme.gold),
              ),
            ),
            const SizedBox(height: 16),
            Text('Standort wird ermittelt...', style: AppTheme.body(size: 14, color: Colors.white54)),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    return AnimatedBuilder(
      animation: _compassAnim,
      builder: (_, child) => Transform.scale(
        scale: 0.86 + 0.14 * _compassAnim.value,
        child: Opacity(opacity: _compassAnim.value.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          color: AppTheme.ink,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                const Icon(Icons.mosque_outlined, color: Colors.white38, size: 15),
                const SizedBox(width: 8),
                Text('القبلة', style: AppTheme.arabic(size: 18, color: AppTheme.gold)),
                const Spacer(),
                Text(
                  '${_qiblaBearing.toStringAsFixed(1)}° von Nord',
                  style: AppTheme.caption(size: 11, color: Colors.white38),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Compass
            Center(
              child: SizedBox(
                width: 240, height: 240,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => CustomPaint(
                    painter: _QiblaCompassPainter(
                      qiblaBearing: _qiblaBearing,
                      pulseValue: _pulseAnim.value,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Footer label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 7, height: 7,
                  decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  'Richtung Mekka  ·  مكة المكرمة',
                  style: AppTheme.caption(size: 12, color: Colors.white54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Prayer Times Card ─────────────────────────────────────────────────────
  Widget _buildPrayerCard() {
    if (_loadingLocation || _times == null) {
      return AppCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text('Gebetszeiten werden berechnet...', style: AppTheme.body(size: 14, color: AppTheme.ink3)),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final prayers = [
      ('fajr',    'Fajr',    'الفجر',  _times!.fajr),
      ('dhuhr',   'Dhuhr',   'الظهر',  _times!.dhuhr),
      ('asr',     'Asr',     'العصر',  _times!.asr),
      ('maghrib', 'Maghrib', 'المغرب', _times!.maghrib),
      ('isha',    'Isha',    'العشاء',  _times!.isha),
    ];

    return AppCard(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Text('Gebetszeiten', style: AppTheme.title(size: 15)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 11, color: AppTheme.gold),
                      const SizedBox(width: 4),
                      Text('in $_countdown', style: AppTheme.label(size: 10, color: AppTheme.gold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.separator),

          // Prayer rows
          ...prayers.map((pr) {
            final isNext = pr.$1 == _nextKey;
            final isPast = pr.$4.isBefore(now) && !isNext;
            return Container(
              decoration: BoxDecoration(
                color: isNext ? AppTheme.gold.withOpacity(0.06) : null,
                border: isNext
                    ? const Border(left: BorderSide(color: AppTheme.gold, width: 3))
                    : null,
              ),
              padding: EdgeInsets.fromLTRB(isNext ? 17 : 20, 13, 20, 13),
              child: Row(
                children: [
                  Text(
                    pr.$3,
                    style: AppTheme.arabic(size: 19, color: isNext ? AppTheme.gold : AppTheme.ink3),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      pr.$2,
                      style: AppTheme.body(
                        size: 15,
                        color: isPast ? AppTheme.ink3 : AppTheme.ink,
                        weight: isNext ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    _fmt(pr.$4),
                    style: AppTheme.title(
                      size: 16,
                      color: isNext ? AppTheme.ink : isPast ? AppTheme.ink3 : AppTheme.ink2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isPast)
                    const Icon(Icons.check_circle_rounded, size: 15, color: AppTheme.green)
                  else if (isNext)
                    Container(
                      width: 7, height: 7,
                      decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
                    )
                  else
                    const SizedBox(width: 7),
                ],
              ),
            );
          }),

          const Divider(height: 1, color: AppTheme.separator),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 15),
            child: Row(
              children: [
                Icon(
                  _locationFailed
                      ? Icons.location_searching_rounded
                      : Icons.location_on_rounded,
                  size: 13,
                  color: _locationFailed ? AppTheme.ink3 : AppTheme.green,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(_cityName, style: AppTheme.caption(size: 12, color: AppTheme.ink3)),
                ),
                if (_locationFailed)
                  GestureDetector(
                    onTap: _showCityPicker,
                    child: Text(
                      'Ort ändern',
                      style: AppTheme.label(size: 11, color: AppTheme.blue),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.04);
  }

  // ── Quick Grid ────────────────────────────────────────────────────────────
  Widget _buildQuickGrid() {
    final items = [
      ('Quiz',     '🧠', const QuizScreen()),
      ('Azkar',    '🌿', const AzkarScreen()),
      ('Duas',     '🤲', const DuasScreen()),
      ('Hadithe',  '📜', const HadithScreen()),
      ('Zakat',    '⚖️', const ZakatScreen()),
      ('Kalender', '🌙', const CalendarScreen()),
      ('99 Namen', '✨', const NamesScreen()),
      ('Propheten','⭐', const ProphetStoriesScreen()),
    ];

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => GestureDetector(
        onTap: () => _go(item.$3),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.$2, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 5),
              Text(item.$1,
                style: AppTheme.caption(size: 10, color: AppTheme.ink),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )).toList(),
    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.04);
  }

  // ── Daily Verse ───────────────────────────────────────────────────────────
  Widget _buildDailyVerse() {
    final dayIdx = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    const verses = [
      ['وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
        'Und wer Allah fürchtet, dem schafft Er einen Ausweg.', 'At-Talaq 65:2'],
      ['إِنَّ مَعَ الْعُسْرِ يُسْرًا',
        'Wahrlich, mit der Schwierigkeit kommt Erleichterung.', 'Al-Inshirah 94:6'],
      ['وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ',
        'Und verzweifelt nicht an der Barmherzigkeit Allahs.', 'Yusuf 12:87'],
      ['حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
        'Allah genügt uns, und Er ist der beste Sachwalter.', 'Al-Imran 3:173'],
      ['وَاللَّهُ يُحِبُّ الصَّابِرِينَ',
        'Und Allah liebt die Geduldigen.', 'Al-Imran 3:146'],
      ['لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
        'Allah belastet keine Seele über ihr Vermögen.', 'Al-Baqara 2:286'],
      ['وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ',
        'Und Er ist mit euch, wo auch immer ihr seid.', 'Al-Hadid 57:4'],
    ];
    final v = verses[dayIdx % verses.length];

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
              const Text('✨', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            v[0],
            style: AppTheme.arabic(size: 22),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 14),
          Container(width: 36, height: 1, color: AppTheme.separator),
          const SizedBox(height: 14),
          Text(
            '„${v[1]}"',
            style: AppTheme.body(size: 14, color: AppTheme.ink2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.04);
  }

  // ── Stats Card ────────────────────────────────────────────────────────────
  Widget _buildStatsCard(AppProvider p) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deine Fortschritte', style: AppTheme.title(size: 15)),
          const SizedBox(height: 16),
          Row(
            children: [
              _statTile('🔥', '${p.salahStreak}', 'Salah\nSerie'),
              _statTile('📿', '${p.totalDhikr}', 'Gesamt\nDhikr'),
              _statTile('🏆', '${p.quizHighScore}', 'Quiz\nBestScore'),
              _statTile('📖', '${p.completedSurahCount}', 'Suren\ngelesen'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text('Khatma', style: AppTheme.caption(size: 12)),
              const Spacer(),
              Text('${p.completedSurahCount}/114',
                style: AppTheme.caption(size: 12, color: AppTheme.ink3)),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p.khatmaProgress,
              backgroundColor: AppTheme.separator,
              valueColor: const AlwaysStoppedAnimation(AppTheme.gold),
              minHeight: 6,
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.04);
  }

  Widget _statTile(String icon, String value, String label) => Expanded(
    child: Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.title(size: 18)),
        const SizedBox(height: 2),
        Text(label,
          style: AppTheme.caption(size: 9, color: AppTheme.ink3),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ── Qibla Compass Painter ────────────────────────────────────────────────────
class _QiblaCompassPainter extends CustomPainter {
  final double qiblaBearing;
  final double pulseValue;

  const _QiblaCompassPainter({required this.qiblaBearing, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 1;

    // ── Background
    canvas.drawCircle(c, outerR, Paint()..color = const Color(0xFF111114));

    // ── Subtle inner glow
    canvas.drawCircle(c, outerR * 0.75, Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.03), Colors.transparent],
      ).createShader(Rect.fromCircle(center: c, radius: outerR * 0.75)));

    // ── Gold gradient border ring
    canvas.drawCircle(c, outerR, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = SweepGradient(
        colors: [
          AppTheme.gold.withOpacity(0.9),
          AppTheme.gold.withOpacity(0.2),
          AppTheme.gold.withOpacity(0.9),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: outerR)));

    // ── Tick marks
    for (int deg = 0; deg < 360; deg += 5) {
      final angle = (deg - 90) * math.pi / 180;
      final isMajor = deg % 90 == 0;
      final isMed   = deg % 30 == 0;
      final len     = isMajor ? 14.0 : isMed ? 8.0 : 4.0;
      final opacity = isMajor ? 0.9 : isMed ? 0.45 : 0.18;
      final sw      = isMajor ? 2.0 : 1.0;
      final o = Offset(c.dx + outerR * math.cos(angle), c.dy + outerR * math.sin(angle));
      final i = Offset(c.dx + (outerR - len) * math.cos(angle), c.dy + (outerR - len) * math.sin(angle));
      canvas.drawLine(o, i, Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..strokeWidth = sw);
    }

    // ── Cardinal direction labels
    final labelR = outerR - 28.0;
    _label(canvas, c, 'N',  -90, labelR, size: 15, bold: true,  color: Colors.white);
    _label(canvas, c, 'O',    0, labelR, size: 11, bold: false, color: Colors.white54);
    _label(canvas, c, 'S',   90, labelR, size: 11, bold: false, color: Colors.white54);
    _label(canvas, c, 'W',  180, labelR, size: 11, bold: false, color: Colors.white54);

    // ── Qibla beam (radial glow sector)
    final qAngle = (qiblaBearing - 90) * math.pi / 180;
    final beamRect = Rect.fromCircle(center: c, radius: outerR - 10);
    final beamPath = Path()
      ..moveTo(c.dx, c.dy)
      ..arcTo(beamRect, qAngle - 0.19, 0.38, false)
      ..close();
    canvas.drawPath(beamPath, Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.gold.withOpacity(0.4), AppTheme.gold.withOpacity(0)],
        radius: 0.95,
      ).createShader(Rect.fromCircle(center: c, radius: outerR)));

    // ── Needle
    final tipR = outerR - 13;
    final tip = Offset(c.dx + tipR * math.cos(qAngle), c.dy + tipR * math.sin(qAngle));

    // glow
    canvas.drawLine(c, tip, Paint()
      ..color = AppTheme.gold.withOpacity(0.28)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    // body
    canvas.drawLine(c, tip, Paint()
      ..color = AppTheme.gold
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round);

    // ── Pulsing dot at needle tip
    final glowR = 7.0 * pulseValue * 2.2;
    canvas.drawCircle(tip, glowR, Paint()
      ..color = AppTheme.gold.withOpacity(0.12));
    canvas.drawCircle(tip, 7, Paint()
      ..color = AppTheme.gold
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(tip, 7, Paint()..color = AppTheme.gold);
    canvas.drawCircle(tip, 3, Paint()..color = Colors.white);

    // ── Center pivot
    canvas.drawCircle(c, 6, Paint()..color = Colors.white.withOpacity(0.85));
    canvas.drawCircle(c, 3.5, Paint()..color = AppTheme.gold);
  }

  void _label(Canvas canvas, Offset c, String text, double angleDeg, double r,
      {double size = 12, bool bold = false, Color color = Colors.white54}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
          letterSpacing: bold ? 1.5 : 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rad = angleDeg * math.pi / 180;
    tp.paint(canvas, Offset(
      c.dx + r * math.cos(rad) - tp.width / 2,
      c.dy + r * math.sin(rad) - tp.height / 2,
    ));
  }

  @override
  bool shouldRepaint(_QiblaCompassPainter old) =>
      old.qiblaBearing != qiblaBearing || old.pulseValue != pulseValue;
}
