import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../data/prayer_data.dart';
import '../providers/app_provider.dart';

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({super.key});

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _pulseAnim;
  late Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _ringAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  void _onTap(AppProvider provider) {
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    if (provider.dhikrCount < provider.dhikrTarget) {
      provider.incrementDhikr();
      if (provider.dhikrCount == provider.dhikrTarget) {
        _ringController.forward().then((_) => _ringController.reset());
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        final dhikr = dhikrList[provider.selectedDhikrIndex];
        final progress = provider.dhikrTarget > 0
            ? (provider.dhikrCount / provider.dhikrTarget).clamp(0.0, 1.0)
            : 0.0;
        final isComplete = provider.dhikrCount >= provider.dhikrTarget;

        return Scaffold(
          backgroundColor: AppTheme.white,
          appBar: AppBar(
            backgroundColor: AppTheme.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Dhikr', style: AppTheme.titleStyle(fontSize: 22)),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.black),
                onPressed: () {
                  provider.resetDhikr();
                  _ringController.reset();
                },
                tooltip: 'Zurücksetzen',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildDhikrSelector(ctx, provider),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dhikr.arabic,
                      style: TextStyle(
                        fontFamily: 'Scheherazade New',
                        fontSize: 36,
                        color: AppTheme.black,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ).animate().fadeIn(),
                    const SizedBox(height: 4),
                    Text(
                      dhikr.german,
                      style: AppTheme.bodyStyle(fontSize: 16, color: AppTheme.mediumGrey),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 40),
                    _buildCounterButton(provider, progress, isComplete),
                    const SizedBox(height: 32),
                    if (isComplete)
                      Text(
                        'Subhanallah! Fertig! 🌙',
                        style: AppTheme.titleStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ).animate().scale(curve: Curves.elasticOut),
                    if (!isComplete)
                      Text(
                        '${provider.dhikrCount} / ${provider.dhikrTarget}',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ).animate().fadeIn(),
                    const SizedBox(height: 16),
                    _buildTotalCounter(provider),
                  ],
                ),
              ),
              _buildFadlBox(dhikr),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDhikrSelector(BuildContext context, AppProvider provider) {
    return Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dhikrList.length,
        itemBuilder: (ctx, i) {
          final d = dhikrList[i];
          final isSelected = provider.selectedDhikrIndex == i;
          return GestureDetector(
            onTap: () => provider.setSelectedDhikr(i, d.recommendedCount),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.black : AppTheme.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppTheme.black : const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d.transliteration,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d.recommendedCount}×',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCounterButton(AppProvider provider, double progress, bool isComplete) {
    return GestureDetector(
      onTap: () => _onTap(provider),
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (ctx, child) {
          return Transform.scale(
            scale: _pulseAnim.value,
            child: child,
          );
        },
        child: CircularPercentIndicator(
          radius: 110.0,
          lineWidth: 8.0,
          percent: progress,
          animation: false,
          backgroundColor: AppTheme.lightGrey,
          progressColor: AppTheme.black,
          circularStrokeCap: CircularStrokeCap.round,
          center: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete ? AppTheme.black : AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black.withOpacity(isComplete ? 0.25 : 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isComplete ? '✓' : '${provider.dhikrCount}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: isComplete ? 52 : 52,
                  fontWeight: FontWeight.bold,
                  color: isComplete ? Colors.white : AppTheme.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCounter(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📿', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            'Gesamt: ${provider.totalDhikr}',
            style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildFadlBox(DhikrItem dhikr) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💬', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              dhikr.fadl,
              style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.softBlack),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
