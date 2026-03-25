import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Full-screen swipeable wisdom quotes with geometric Islamic art backgrounds
class WisdomScreen extends StatefulWidget {
  const WisdomScreen({super.key});
  @override
  State<WisdomScreen> createState() => _WisdomScreenState();
}

class _WisdomScreenState extends State<WisdomScreen> with TickerProviderStateMixin {
  late PageController _ctrl;
  int _current = 0;
  late AnimationController _geomCtrl;

  @override
  void initState() {
    super.initState();
    _current = Random().nextInt(_quotes.length);
    _ctrl = PageController(initialPage: _current);
    _geomCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _geomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: _quotes.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (ctx, i) => _buildPage(_quotes[i], i),
          ),
          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
          // Page indicator – right side
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_quotes.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    width: 4,
                    height: i == _current ? 20 : 6,
                    decoration: BoxDecoration(
                      color: i == _current ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Swipe hint at bottom
          if (_current == 0)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Icon(Icons.keyboard_arrow_up, color: Colors.white60, size: 28)
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(begin: 0, end: -6, duration: 800.ms, curve: Curves.easeInOut)
                      .then()
                      .moveY(begin: -6, end: 0, duration: 800.ms),
                  Text('Nach oben wischen', style: AppTheme.caption(color: Colors.white54)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(_Quote q, int i) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: q.colors,
        ),
      ),
      child: Stack(
        children: [
          // Animated geometric Islamic pattern
          AnimatedBuilder(
            animation: _geomCtrl,
            builder: (ctx, _) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _IslamicPatternPainter(_geomCtrl.value, q.colors.last),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 80, 32, 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      q.category,
                      style: AppTheme.label(size: 11, color: Colors.white70),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 32),
                  // Arabic quote
                  Text(
                    q.arabic,
                    style: TextStyle(
                      fontFamily: 'Scheherazade New',
                      fontSize: 26,
                      color: Colors.white,
                      height: 2.2,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.95, 0.95)),
                  const SizedBox(height: 24),
                  Container(
                    width: 50,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.4),
                  ).animate().scaleX(delay: 400.ms),
                  const SizedBox(height: 24),
                  // German quote
                  Text(
                    '„${q.german}"',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      color: Colors.white,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 16),
                  Text(
                    q.source,
                    style: AppTheme.caption(size: 12, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 40),
                  // Share button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: '${q.arabic}\n\n„${q.german}"\n\n${q.source}'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Kopiert!'),
                          backgroundColor: Colors.white.withOpacity(0.15),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('Kopieren', style: AppTheme.body(size: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Islamic Geometric Pattern Painter ─────────────────────────────────
class _IslamicPatternPainter extends CustomPainter {
  final double t;
  final Color accentColor;

  _IslamicPatternPainter(this.t, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 180.0;

    // Rotating star pattern (8-pointed Islamic star)
    for (int ring = 0; ring < 4; ring++) {
      final rr = r * (ring + 1) * 0.5;
      final path = Path();
      final rotate = t * 2 * pi * (ring % 2 == 0 ? 1 : -1) * 0.08;
      for (int j = 0; j < 8; j++) {
        final angle = j * pi / 4 + rotate;
        final innerAngle = angle + pi / 8;
        final ox = cx + rr * cos(angle);
        final oy = cy + rr * sin(angle);
        final ix = cx + rr * 0.5 * cos(innerAngle);
        final iy = cy + rr * 0.5 * sin(innerAngle);
        j == 0 ? path.moveTo(ox, oy) : path.lineTo(ox, oy);
        path.lineTo(ix, iy);
      }
      path.close();
      canvas.drawPath(path, paint..color = Colors.white.withOpacity(0.04 + ring * 0.01));
    }

    // Corner ornaments
    for (final offset in [
      Offset(-cx * 0.3, -cy * 0.3),
      Offset(cx * 1.3, -cy * 0.3),
      Offset(-cx * 0.3, cy * 1.3),
      Offset(cx * 1.3, cy * 1.3),
    ]) {
      _drawRosette(canvas, offset, 60, t, paint..color = Colors.white.withOpacity(0.05));
    }
  }

  void _drawRosette(Canvas canvas, Offset center, double r, double t, Paint p) {
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 + t * 0.2;
      canvas.drawCircle(
        Offset(center.dx + r * cos(angle) * 0.5, center.dy + r * sin(angle) * 0.5),
        r * 0.5,
        p,
      );
    }
    canvas.drawCircle(center, r * 0.5, p);
  }

  @override
  bool shouldRepaint(_IslamicPatternPainter old) => old.t != t;
}

// ── Quotes Data ────────────────────────────────────────────────────────
class _Quote {
  final String arabic;
  final String german;
  final String source;
  final String category;
  final List<Color> colors;

  const _Quote({
    required this.arabic,
    required this.german,
    required this.source,
    required this.category,
    required this.colors,
  });
}

const _quotes = [
  _Quote(
    arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
    german: 'Und wer Allah fürchtet, dem schafft Er einen Ausweg.',
    source: 'Sure At-Talaq 65:2',
    category: 'Taqwa',
    colors: [Color(0xFF0A1628), Color(0xFF1A2E4A)],
  ),
  _Quote(
    arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
    german: 'Wahrlich, mit der Schwierigkeit kommt Erleichterung.',
    source: 'Sure Al-Inshirah 94:6',
    category: 'Hoffnung',
    colors: [Color(0xFF1A0A0A), Color(0xFF3A1515)],
  ),
  _Quote(
    arabic: 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ',
    german: 'Und verzweifelt nicht an der Barmherzigkeit Allahs.',
    source: 'Sure Yusuf 12:87',
    category: 'Hoffnung',
    colors: [Color(0xFF0A1A0A), Color(0xFF153025)],
  ),
  _Quote(
    arabic: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
    german: 'Wahrlich, Taten werden nur nach Absichten bewertet.',
    source: 'Sahih al-Bukhari',
    category: 'Hadith',
    colors: [Color(0xFF1A1A0A), Color(0xFF2A2A10)],
  ),
  _Quote(
    arabic: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ',
    german: 'Dein Lächeln ins Gesicht deines Bruders ist Sadaqa.',
    source: 'Tirmidhi',
    category: 'Charakter',
    colors: [Color(0xFF0A0A1A), Color(0xFF151540)],
  ),
  _Quote(
    arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    german: 'Allah genügt uns, und Er ist der beste Sachwalter.',
    source: 'Sure Al-Imran 3:173',
    category: 'Tawakkul',
    colors: [Color(0xFF1A0A1A), Color(0xFF3A1530)],
  ),
  _Quote(
    arabic: 'وَاللَّهُ يُحِبُّ الصَّابِرِينَ',
    german: 'Und Allah liebt die Geduldigen.',
    source: 'Sure Al-Imran 3:146',
    category: 'Sabr',
    colors: [Color(0xFF0A1A1A), Color(0xFF103030)],
  ),
  _Quote(
    arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
    german: 'Allah belastet keine Seele über ihr Vermögen.',
    source: 'Sure Al-Baqara 2:286',
    category: 'Rahma',
    colors: [Color(0xFF0D0D1F), Color(0xFF1A1A3A)],
  ),
  _Quote(
    arabic: 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ',
    german: 'Und Er ist mit euch, wo auch immer ihr seid.',
    source: 'Sure Al-Hadid 57:4',
    category: 'Imaan',
    colors: [Color(0xFF101A10), Color(0xFF1A2A1A)],
  ),
  _Quote(
    arabic: 'خَيْرُ الْكَلَامِ كَلَامُ اللَّهِ',
    german: 'Die beste Rede ist die Rede Allahs.',
    source: 'Sahih Muslim',
    category: 'Koran',
    colors: [Color(0xFF1A1000), Color(0xFF2A1A00)],
  ),
  _Quote(
    arabic: 'وَاذْكُر رَّبَّكَ إِذَا نَسِيتَ',
    german: 'Und gedenke deines Herrn, wenn du vergessen hast.',
    source: 'Sure Al-Kahf 18:24',
    category: 'Dhikr',
    colors: [Color(0xFF0A0A12), Color(0xFF12121F)],
  ),
  _Quote(
    arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
    german: 'Wahrlich, Allah ist mit den Geduldigen.',
    source: 'Sure Al-Baqara 2:153',
    category: 'Sabr',
    colors: [Color(0xFF120A1A), Color(0xFF1E1228)],
  ),
];
