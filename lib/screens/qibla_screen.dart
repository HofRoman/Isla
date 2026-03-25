import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Qibla screen with animated compass needle pointing to Mecca.
// Uses flutter_qiblah / flutter_compass for real sensor data.
// Falls back to a manual bearing input when sensors unavailable.
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with TickerProviderStateMixin {
  late AnimationController _needleController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Mecca coordinates
  static const double _meccaLat = 21.4225;
  static const double _meccaLon = 39.8262;

  // Simulated device heading (0–360°) — replaced by real sensor in production
  double _deviceHeading = 0;
  double _qiblaAngle = 0; // Qibla bearing from north
  bool _sensorAvailable = false;
  bool _permissionGranted = false;
  bool _showManualMode = false;
  double _manualLat = 52.52; // Berlin default
  double _manualLon = 13.405;

  // City presets
  final List<_CityPreset> _cities = const [
    _CityPreset('Berlin', 52.52, 13.405),
    _CityPreset('München', 48.137, 11.576),
    _CityPreset('Hamburg', 53.551, 9.994),
    _CityPreset('Frankfurt', 50.110, 8.682),
    _CityPreset('Istanbul', 41.015, 28.979),
    _CityPreset('Kairo', 30.045, 31.236),
    _CityPreset('Dubai', 25.205, 55.270),
    _CityPreset('London', 51.507, -0.127),
    _CityPreset('Paris', 48.857, 2.352),
  ];
  int _selectedCityIndex = 0;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _calculateQibla(_manualLat, _manualLon);
    _tryStartCompass();
  }

  Future<void> _tryStartCompass() async {
    // In a real build, request permission and start flutter_compass.
    // Here we simulate the flow and use manual mode.
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _showManualMode = true;
        _permissionGranted = true;
      });
    }
  }

  void _calculateQibla(double lat, double lon) {
    // Spherical bearing formula
    final latR = lat * math.pi / 180;
    final lonR = lon * math.pi / 180;
    final meccaLatR = _meccaLat * math.pi / 180;
    final meccaLonR = _meccaLon * math.pi / 180;
    final dLon = meccaLonR - lonR;
    final y = math.sin(dLon) * math.cos(meccaLatR);
    final x = math.cos(latR) * math.sin(meccaLatR) -
        math.sin(latR) * math.cos(meccaLatR) * math.cos(dLon);
    final bearing = math.atan2(y, x) * 180 / math.pi;
    setState(() {
      _qiblaAngle = (bearing + 360) % 360;
    });
  }

  void _selectCity(int index) {
    setState(() => _selectedCityIndex = index);
    _calculateQibla(_cities[index].lat, _cities[index].lon);
  }

  double get _needleAngle {
    // Needle points to Qibla relative to device heading
    return (_qiblaAngle - _deviceHeading) * math.pi / 180;
  }

  @override
  void dispose() {
    _needleController.dispose();
    _pulseController.dispose();
    super.dispose();
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
        title: Text('Qibla-Kompass', style: AppTheme.titleStyle(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 8),
            _buildCitySelector(),
            const SizedBox(height: 32),
            _buildCompass(),
            const SizedBox(height: 32),
            _buildQiblaInfo(),
            const SizedBox(height: 24),
            _buildMeccaInfo(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'القِبْلَة',
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 32,
                    color: AppTheme.accentGold,
                    height: 1.4,
                  ),
                ),
                Text(
                  'Richtung zur Kaaba in Mekka',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mekka: 21.42°N, 39.83°E',
                  style: AppTheme.bodyStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.4), width: 1.5),
            ),
            child: const Center(
              child: Text('🕋', style: TextStyle(fontSize: 30)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildCitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Standort wählen', style: AppTheme.titleStyle(fontSize: 17)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _cities.length,
            itemBuilder: (ctx, i) {
              final city = _cities[i];
              final selected = _selectedCityIndex == i;
              return GestureDetector(
                onTap: () => _selectCity(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.black : AppTheme.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? AppTheme.black : const Color(0xFFDDDDDD),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    city.name,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppTheme.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildCompass() {
    final city = _cities[_selectedCityIndex];
    return Center(
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnim,
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer decorative ring
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE8E8E8), width: 2),
                    ),
                  ),
                  // Compass rose background
                  CustomPaint(
                    size: const Size(260, 260),
                    painter: _CompassRosePainter(),
                  ),
                  // Inner circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.white,
                      border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  // Qibla needle
                  AnimatedRotation(
                    turns: _needleAngle / (2 * math.pi),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _QiblaNeedlePainter(),
                    ),
                  ),
                  // Center dot
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.black,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                  // Kaaba icon at tip
                  Positioned(
                    top: 36,
                    child: Transform.rotate(
                      angle: _needleAngle,
                      child: const Text('🕋', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📍', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  '${city.name}  →  ${_qiblaAngle.toStringAsFixed(1)}° von Nord',
                  style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.black),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOut);
  }

  Widget _buildQiblaInfo() {
    final city = _cities[_selectedCityIndex];
    final distance = _haversineKm(city.lat, city.lon, _meccaLat, _meccaLon);
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
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _infoBlock('Qibla-Richtung', '${_qiblaAngle.toStringAsFixed(1)}°', '🧭'),
          _divider(),
          _infoBlock('Distanz', '${distance.toStringAsFixed(0)} km', '✈️'),
          _divider(),
          _infoBlock('Stadt', city.name, '📍'),
        ],
      ),
    ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _infoBlock(String label, String value, String icon) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(value,
              style: AppTheme.titleStyle(fontSize: 15), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label,
              style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.mediumGrey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 50, color: const Color(0xFFEEEEEE));

  Widget _buildMeccaInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.35), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🕋', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Die Kaaba – Masjid al-Haram', style: AppTheme.titleStyle(fontSize: 16)),
                    Text('Mekka, Saudi-Arabien',
                        style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Die Kaaba ist das heiligste Bauwerk des Islam. Sie befindet sich im Inneren der Masjid al-Haram in Mekka und gilt als das "Haus Allahs" (Baitullah). Muslime auf der ganzen Welt richten sich beim Gebet in ihre Richtung aus.',
            style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.softBlack),
          ),
          const SizedBox(height: 14),
          Text(
            '"Wende dein Gesicht in Richtung der Masjid al-Haram." – Sure Al-Baqara 2:144',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: AppTheme.mediumGrey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn();
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}

class _CityPreset {
  final String name;
  final double lat;
  final double lon;
  const _CityPreset(this.name, this.lat, this.lon);
}

// ── Custom Painters ────────────────────────────────────────────────────

class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final tickPaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final majorTickPaint = Paint()
      ..color = AppTheme.black
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw tick marks
    for (int i = 0; i < 72; i++) {
      final angle = i * math.pi / 36;
      final isMajor = i % 9 == 0;
      final isCardinal = i % 18 == 0;
      final innerR = isCardinal ? radius - 20 : isMajor ? radius - 14 : radius - 8;
      final outerR = radius - 2;
      final start = Offset(center.dx + innerR * math.sin(angle), center.dy - innerR * math.cos(angle));
      final end = Offset(center.dx + outerR * math.sin(angle), center.dy - outerR * math.cos(angle));
      canvas.drawLine(start, end, isCardinal || isMajor ? majorTickPaint : tickPaint);
    }

    // Cardinal labels
    final labels = ['N', 'O', 'S', 'W'];
    final angles = [0.0, math.pi / 2, math.pi, 3 * math.pi / 2];
    for (int i = 0; i < 4; i++) {
      final angle = angles[i];
      final pos = Offset(
        center.dx + (radius - 34) * math.sin(angle),
        center.dy - (radius - 34) * math.cos(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: labels[i] == 'N' ? Colors.red.shade700 : AppTheme.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QiblaNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // North needle (grey)
    final greyPaint = Paint()
      ..color = const Color(0xFFBBBBBB)
      ..style = PaintingStyle.fill;

    final southPath = Path()
      ..moveTo(center.dx, center.dy + 10)
      ..lineTo(center.dx - 8, center.dy + 70)
      ..lineTo(center.dx, center.dy + 80)
      ..lineTo(center.dx + 8, center.dy + 70)
      ..close();
    canvas.drawPath(southPath, greyPaint);

    // Qibla needle (black, pointing up = towards Qibla)
    final blackPaint = Paint()
      ..color = AppTheme.black
      ..style = PaintingStyle.fill;
    final goldPaint = Paint()
      ..color = AppTheme.accentGold
      ..style = PaintingStyle.fill;

    final northPath = Path()
      ..moveTo(center.dx, center.dy - 10)
      ..lineTo(center.dx - 9, center.dy - 72)
      ..lineTo(center.dx, center.dy - 86)
      ..lineTo(center.dx + 9, center.dy - 72)
      ..close();
    canvas.drawPath(northPath, blackPaint);

    // Gold tip
    final tipPath = Path()
      ..moveTo(center.dx - 6, center.dy - 78)
      ..lineTo(center.dx, center.dy - 90)
      ..lineTo(center.dx + 6, center.dy - 78)
      ..close();
    canvas.drawPath(tipPath, goldPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
