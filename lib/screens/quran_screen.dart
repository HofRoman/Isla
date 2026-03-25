import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/quran_data.dart';
import '../providers/app_provider.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with TickerProviderStateMixin {
  int? _selectedSurahIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          onPressed: () {
            if (_selectedSurahIndex != null) {
              setState(() => _selectedSurahIndex = null);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedSurahIndex == null
              ? 'القرآن الكريم'
              : quranSurahs[_selectedSurahIndex!].nameTransliteration,
          style: _selectedSurahIndex == null
              ? TextStyle(
                  fontFamily: 'Scheherazade New',
                  fontSize: 26,
                  color: AppTheme.black,
                  fontWeight: FontWeight.w600,
                )
              : AppTheme.titleStyle(fontSize: 20),
        ),
        actions: [
          if (_selectedSurahIndex != null)
            Consumer<AppProvider>(
              builder: (ctx, provider, _) => TextButton.icon(
                onPressed: provider.toggleTranslation,
                icon: const Icon(Icons.translate, size: 16, color: AppTheme.black),
                label: Text(
                  provider.selectedTranslation == 'de' ? 'DE' : 'EN',
                  style: AppTheme.bodyStyle(fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: _selectedSurahIndex == null ? _buildSurahList() : _buildSurahDetail(),
    );
  }

  Widget _buildSurahList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.black,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Al-Koran Al-Karim',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bubenheim Übersetzung · Englisch · Arabisch',
                      style: AppTheme.bodyStyle(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                      ),
                      child: Text(
                        '${quranSurahs.length} Suren verfügbar',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '﷽',
                style: TextStyle(
                  fontFamily: 'Scheherazade New',
                  fontSize: 40,
                  color: AppTheme.accentGold,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: quranSurahs.length,
            itemBuilder: (ctx, i) => _buildSurahTile(i),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahTile(int index) {
    final surah = quranSurahs[index];
    return GestureDetector(
      onTap: () => setState(() => _selectedSurahIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.nameTransliteration, style: AppTheme.titleStyle(fontSize: 17)),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.nameGerman} · ${surah.versesCount} Verse · ${surah.revelationType}',
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey),
                  ),
                ],
              ),
            ),
            Text(
              surah.nameArabic,
              style: TextStyle(
                fontFamily: 'Scheherazade New',
                fontSize: 22,
                color: AppTheme.black,
                height: 1.6,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 60)).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildSurahDetail() {
    final surah = quranSurahs[_selectedSurahIndex!];
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        return Column(
          children: [
            _buildSurahHeader(surah),
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.black,
              unselectedLabelColor: AppTheme.mediumGrey,
              indicatorColor: AppTheme.black,
              indicatorWeight: 2,
              tabs: const [
                Tab(text: 'Arabisch'),
                Tab(text: 'Übersetzung'),
                Tab(text: 'Alle'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildArabicView(surah),
                  _buildTranslationView(surah, provider.selectedTranslation),
                  _buildAllView(surah, provider.selectedTranslation),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSurahHeader(QuranSurah surah) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(surah.nameGerman, style: AppTheme.titleStyle(fontSize: 18)),
                Text(surah.nameEnglish, style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _infoChip('${surah.versesCount} Verse'),
                    const SizedBox(width: 8),
                    _infoChip(surah.revelationType),
                    const SizedBox(width: 8),
                    _infoChip('Sure ${surah.number}'),
                  ],
                ),
              ],
            ),
          ),
          Text(
            surah.nameArabic,
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 30,
              color: AppTheme.black,
              height: 1.5,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildArabicView(QuranSurah surah) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: surah.verses.length,
      itemBuilder: (ctx, i) {
        final verse = surah.verses[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _verseNumber(verse.verseNumber),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                verse.arabic,
                style: TextStyle(
                  fontFamily: 'Scheherazade New',
                  fontSize: 30,
                  color: AppTheme.black,
                  height: 2.2,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: i * 50)).fadeIn();
      },
    );
  }

  Widget _buildTranslationView(QuranSurah surah, String lang) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: surah.verses.length,
      itemBuilder: (ctx, i) {
        final verse = surah.verses[i];
        final translation = lang == 'de' ? verse.germanBubenheim : verse.english;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _verseNumber(verse.verseNumber),
                  const SizedBox(width: 10),
                  Text(
                    lang == 'de' ? 'Bubenheim' : 'Englisch',
                    style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.mediumGrey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                translation,
                style: AppTheme.bodyStyle(fontSize: 16, color: AppTheme.black),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: i * 50)).fadeIn();
      },
    );
  }

  Widget _buildAllView(QuranSurah surah, String lang) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: surah.verses.length,
      itemBuilder: (ctx, i) {
        final verse = surah.verses[i];
        final translation = lang == 'de' ? verse.germanBubenheim : verse.english;
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Vers ${verse.verseNumber}',
                      style: GoogleFonts.lato(fontSize: 13, color: Colors.white70),
                    ),
                    const Spacer(),
                    Text(
                      '${surah.number}:${verse.verseNumber}',
                      style: GoogleFonts.lato(fontSize: 13, color: AppTheme.accentGold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      verse.arabic,
                      style: TextStyle(
                        fontFamily: 'Scheherazade New',
                        fontSize: 28,
                        color: AppTheme.black,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const Divider(height: 24, color: Color(0xFFEEEEEE)),
                    Text(
                      translation,
                      style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.softBlack),
                      textAlign: TextAlign.left,
                    ),
                    if (lang == 'de' && verse.english.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        verse.english,
                        style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideY(begin: 0.05);
      },
    );
  }

  Widget _verseNumber(int num) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.black, width: 1.5),
      ),
      child: Center(
        child: Text(
          '$num',
          style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.black),
        ),
      ),
    );
  }
}
