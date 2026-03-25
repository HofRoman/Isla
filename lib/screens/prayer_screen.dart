import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/prayer_data.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _expandedWuduStep;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Gebet', style: AppTheme.titleStyle(fontSize: 22)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.black,
          unselectedLabelColor: AppTheme.mediumGrey,
          indicatorColor: AppTheme.black,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: 'Gebete'),
            Tab(text: 'Wudu'),
            Tab(text: 'Dhikr-Dua'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrayersTab(),
          _buildWuduTab(),
          _buildDhikrDuaTab(),
        ],
      ),
    );
  }

  Widget _buildPrayersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrayerHeader(),
          const SizedBox(height: 24),
          Text('Die 5 Säulen des Gebets', style: AppTheme.titleStyle(fontSize: 20))
              .animate().fadeIn(),
          const SizedBox(height: 4),
          Text(
            'Salah – die zweite Säule des Islam',
            style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),
          ...prayers.asMap().entries.map((e) => _buildPrayerCard(e.key, e.value)),
          const SizedBox(height: 24),
          _buildRakaatSummary(),
        ],
      ),
    );
  }

  Widget _buildPrayerHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🕌', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصَّلَاة',
                      style: TextStyle(
                        fontFamily: 'Scheherazade New',
                        fontSize: 28,
                        color: AppTheme.accentGold,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'As-Salah – Das Gebet',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Das Gebet ist die Säule der Religion. Wer es aufrechthält, hält die Religion aufrecht, und wer es vernachlässigt, lässt die Religion fallen.',
            style: GoogleFonts.lato(fontSize: 13, color: Colors.white70, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '– Hadith –',
            style: GoogleFonts.lato(fontSize: 11, color: AppTheme.accentGold),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildPrayerCard(int index, PrayerInfo prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prayer.name, style: AppTheme.titleStyle(fontSize: 20)),
                    Text(
                      prayer.time,
                      style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prayer.arabicName,
                    style: TextStyle(
                      fontFamily: 'Scheherazade New',
                      fontSize: 24,
                      color: AppTheme.black,
                      height: 1.6,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${prayer.rakaat} Rakaat',
                      style: GoogleFonts.lato(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            const Divider(color: Color(0xFFEEEEEE), height: 1),
            const SizedBox(height: 14),
            Text(
              prayer.description,
              style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.softBlack),
            ),
            const SizedBox(height: 14),
            ...List.generate(prayer.rakaatBreakdown.length, (i) {
              return Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    '${prayer.rakaatBreakdown[i]} ${prayer.rakaatTypes[i]}',
                    style: AppTheme.bodyStyle(fontSize: 14),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 80)).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildRakaatSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tägliche Rakaat Übersicht', style: AppTheme.titleStyle(fontSize: 17)),
          const SizedBox(height: 16),
          _rakaatRow('Fajr', '2'),
          _rakaatRow('Dhuhr', '4'),
          _rakaatRow('Asr', '4'),
          _rakaatRow('Maghrib', '3'),
          _rakaatRow('Ischa', '4'),
          const Divider(height: 20, color: Color(0xFFDDDDDD)),
          _rakaatRow('Gesamt', '17', bold: true),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _rakaatRow(String name, String count, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: bold
                ? AppTheme.titleStyle(fontSize: 16)
                : AppTheme.bodyStyle(fontSize: 15),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bold ? AppTheme.black : AppTheme.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: bold ? AppTheme.black : const Color(0xFFDDDDDD)),
            ),
            child: Center(
              child: Text(
                count,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: bold ? Colors.white : AppTheme.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWuduTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: wuduSteps.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) return _buildWuduHeader();
        final step = wuduSteps[i - 1];
        return _buildWuduStepCard(i - 1, step);
      },
    );
  }

  Widget _buildWuduHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            'الوُضُوء',
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 36,
              color: AppTheme.accentGold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wudu – Rituelle Waschung',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Die Reinheit ist die Hälfte des Glaubens.',
            style: GoogleFonts.lato(fontSize: 13, color: Colors.white70, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          Text(
            '– Sahih Muslim –',
            style: GoogleFonts.lato(fontSize: 11, color: AppTheme.accentGold),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildWuduStepCard(int index, WuduStep step) {
    final isExpanded = _expandedWuduStep == index;
    return GestureDetector(
      onTap: () => setState(() => _expandedWuduStep = isExpanded ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded ? AppTheme.black : const Color(0xFFE8E8E8),
            width: isExpanded ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isExpanded ? AppTheme.black : AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${step.step}',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isExpanded ? Colors.white : AppTheme.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(step.title, style: AppTheme.titleStyle(fontSize: 17)),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppTheme.black,
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 8),
                    Text(step.description, style: AppTheme.bodyStyle(fontSize: 14)),
                    if (step.arabicDua.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              step.arabicDua,
                              style: TextStyle(
                                fontFamily: 'Scheherazade New',
                                fontSize: 22,
                                color: AppTheme.black,
                                height: 2.0,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                step.germanDua,
                                style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 50)).fadeIn();
  }

  Widget _buildDhikrDuaTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: dhikrList.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dhikr & Duas', style: AppTheme.titleStyle(fontSize: 24))
                  .animate().fadeIn(),
              const SizedBox(height: 6),
              Text(
                'Gedenke Allahs, damit Er deiner gedenkt.',
                style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 20),
            ],
          );
        }
        final dhikr = dhikrList[i - 1];
        return _buildDhikrCard(i - 1, dhikr);
      },
    );
  }

  Widget _buildDhikrCard(int index, DhikrItem dhikr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${dhikr.recommendedCount}×',
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dhikr.transliteration,
                  style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            dhikr.arabic,
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 30,
              color: AppTheme.black,
              height: 2.0,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dhikr.german,
              style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.softBlack),
            ),
          ),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💬', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dhikr.fadl,
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 60)).fadeIn().slideY(begin: 0.05);
  }
}
