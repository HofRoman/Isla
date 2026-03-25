import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/hadith_data.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showArabic = true;
  late AnimationController _cardFlipController;

  @override
  void initState() {
    super.initState();
    // Start with a random hadith of the day (based on day of year)
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    _currentIndex = dayOfYear % hadiths.length;
    _pageController = PageController(initialPage: _currentIndex, viewportFraction: 0.92);
    _cardFlipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _cardFlipController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardFlipController.dispose();
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
        title: Text('Hadith des Tages', style: AppTheme.titleStyle(fontSize: 22)),
        actions: [
          IconButton(
            icon: Icon(
              _showArabic ? Icons.translate : Icons.text_fields,
              color: AppTheme.black,
            ),
            onPressed: () => setState(() => _showArabic = !_showArabic),
            tooltip: 'Arabisch / Übersetzung',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopBanner(),
          const SizedBox(height: 12),
          _buildPageCounter(),
          const SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: hadiths.length,
              onPageChanged: (i) {
                setState(() => _currentIndex = i);
                _cardFlipController.reset();
                _cardFlipController.forward();
              },
              itemBuilder: (ctx, i) => _buildHadithCard(hadiths[i], i == _currentIndex),
            ),
          ),
          const SizedBox(height: 16),
          _buildNavButtons(),
          const SizedBox(height: 24),
          _buildTopicChips(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('📜', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الْحَدِيث',
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 22,
                    color: AppTheme.accentGold,
                    height: 1.4,
                  ),
                ),
                Text(
                  '${hadiths.length} Hadithe aus sahih Quellen',
                  style: AppTheme.bodyStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
            ),
            child: Text(
              '${_currentIndex + 1} / ${hadiths.length}',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: AppTheme.accentGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildPageCounter() {
    return SizedBox(
      height: 6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: hadiths.length,
        itemBuilder: (ctx, i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 4),
          width: i == _currentIndex ? 20 : 6,
          decoration: BoxDecoration(
            color: i == _currentIndex ? AppTheme.black : const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(Hadith hadith, bool isActive) {
    return FadeTransition(
      opacity: isActive ? _cardFlipController : const AlwaysStoppedAnimation(0.7),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.08 : 0.03),
              blurRadius: isActive ? 25 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Topic badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hadith.topic,
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ).animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 24),

              if (_showArabic) ...[
                Text(
                  hadith.arabic,
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 28,
                    color: AppTheme.black,
                    height: 2.2,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ).animate().fadeIn(),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),
              ],

              Text(
                '„${hadith.german}"',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: AppTheme.black,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 150.ms).fadeIn(),
              const SizedBox(height: 12),
              Text(
                '„${hadith.english}"',
                style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn(),
              const SizedBox(height: 24),

              // Narrator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('👤', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Überliefert von ${hadith.narrator}',
                    style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Source
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      hadith.source,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppTheme.softBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 300.ms).fadeIn(),

              const SizedBox(height: 16),
              // Share / copy
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                    text: '${hadith.arabic}\n\n${hadith.german}\n\nÜberliefert von ${hadith.narrator}\n${hadith.source}',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hadith kopiert', style: AppTheme.bodyStyle(fontSize: 13, color: Colors.white)),
                      backgroundColor: AppTheme.black,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.copy, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text('Hadith kopieren',
                          style: GoogleFonts.lato(fontSize: 13, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentIndex > 0
                  ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 350), curve: Curves.easeOut)
                  : null,
              icon: const Icon(Icons.arrow_back_ios, size: 14),
              label: const Text('Zurück'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.black,
                side: const BorderSide(color: Color(0xFFDDDDDD), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final random = Random().nextInt(hadiths.length);
                _pageController.animateToPage(
                  random,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.shuffle, size: 14, color: Colors.white),
              label: Text('Zufällig', style: GoogleFonts.lato(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.black,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentIndex < hadiths.length - 1
                  ? () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 350), curve: Curves.easeOut)
                  : null,
              icon: const Icon(Icons.arrow_forward_ios, size: 14),
              label: const Text('Weiter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.black,
                side: const BorderSide(color: Color(0xFFDDDDDD), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChips() {
    final topics = hadiths.map((h) => h.topic).toSet().toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Nach Thema', style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: topics.length,
            itemBuilder: (ctx, i) {
              final topicIndex = hadiths.indexWhere((h) => h.topic == topics[i]);
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  topicIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child: Text(
                    topics[i],
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.black),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
