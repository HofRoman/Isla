import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/prophet_stories_data.dart';

class ProphetStoriesScreen extends StatefulWidget {
  const ProphetStoriesScreen({super.key});

  @override
  State<ProphetStoriesScreen> createState() => _ProphetStoriesScreenState();
}

class _ProphetStoriesScreenState extends State<ProphetStoriesScreen>
    with TickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _detailController;

  @override
  void initState() {
    super.initState();
    _detailController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _detailController.dispose();
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
          icon: Icon(
            _selectedIndex != null ? Icons.arrow_back_ios : Icons.arrow_back_ios,
            color: AppTheme.black,
          ),
          onPressed: () {
            if (_selectedIndex != null) {
              _detailController.reverse().then((_) => setState(() => _selectedIndex = null));
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedIndex == null ? 'Prophetengeschichten' : prophetStories[_selectedIndex!].name,
          style: AppTheme.titleStyle(fontSize: 22),
        ),
      ),
      body: _selectedIndex == null ? _buildList() : _buildDetail(),
    );
  }

  Widget _buildList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildProphetCard(i),
              childCount: prophetStories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      padding: const EdgeInsets.all(22),
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
                  'قِصَصُ الأَنْبِيَاء',
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 26,
                    color: AppTheme.accentGold,
                    height: 1.5,
                  ),
                ),
                Text(
                  'Geschichten der Propheten',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"Alles, was Wir dir von den Nachrichten der Gesandten erzählen, ist das, womit Wir dein Herz festigen." – 11:120',
                  style: GoogleFonts.lato(fontSize: 11, color: Colors.white60, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('📖', style: TextStyle(fontSize: 40)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildProphetCard(int index) {
    final prophet = prophetStories[index];
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        _detailController.forward();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
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
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(child: Text(prophet.icon, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(prophet.name, style: AppTheme.titleStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('(ﷺ)', style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey)),
                    ],
                  ),
                  Text(prophet.title, style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
                  const SizedBox(height: 6),
                  Text(
                    prophet.shortBio,
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.softBlack),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(prophet.arabicName, style: TextStyle(fontFamily: 'Scheherazade New', fontSize: 22, color: AppTheme.black, height: 1.6), textDirection: TextDirection.rtl),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: AppTheme.black, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 70)).fadeIn().slideX(begin: 0.06);
  }

  Widget _buildDetail() {
    final prophet = prophetStories[_selectedIndex!];
    return FadeTransition(
      opacity: _detailController,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailHero(prophet),
            _buildBioSection(prophet),
            _buildKeyEvents(prophet),
            _buildLessonBox(prophet),
            _buildQuranBox(prophet),
            const SizedBox(height: 32),
            if (_selectedIndex! < prophetStories.length - 1)
              _buildNextProphet(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailHero(ProphetStory prophet) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(26),
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
          Text(prophet.icon, style: const TextStyle(fontSize: 56)).animate().scale(curve: Curves.elasticOut, delay: 100.ms),
          const SizedBox(height: 16),
          Text(
            prophet.arabicName,
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 44,
              color: AppTheme.accentGold,
              height: 1.4,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),
          Text(
            '${prophet.name} (ﷺ)',
            style: GoogleFonts.playfairDisplay(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(prophet.title, style: AppTheme.bodyStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
            ),
            child: Text(
              'Im Koran ${prophet.quranMentions}× erwähnt',
              style: GoogleFonts.lato(fontSize: 12, color: AppTheme.accentGold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.05);
  }

  Widget _buildBioSection(ProphetStory prophet) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        prophet.shortBio,
        style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.softBlack),
        textAlign: TextAlign.justify,
      ),
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildKeyEvents(ProphetStory prophet) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wichtige Ereignisse', style: AppTheme.titleStyle(fontSize: 18))
              .animate(delay: 150.ms).fadeIn(),
          const SizedBox(height: 12),
          ...prophet.keyEvents.asMap().entries.map((entry) {
            final i = entry.key;
            final event = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.black),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(event, style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.softBlack)),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 200 + i * 50)).fadeIn().slideX(begin: 0.05);
          }),
        ],
      ),
    );
  }

  Widget _buildLessonBox(ProphetStory prophet) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('Lektion & Weisheit', style: GoogleFonts.playfairDisplay(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(prophet.lesson, style: AppTheme.bodyStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildQuranBox(ProphetStory prophet) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.35), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📖', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Koran-Referenzen', style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey)),
                const SizedBox(height: 4),
                Text(prophet.quranMention, style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.softBlack)),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn();
  }

  Widget _buildNextProphet() {
    final next = prophetStories[_selectedIndex! + 1];
    return GestureDetector(
      onTap: () {
        _detailController.reset();
        setState(() => _selectedIndex = _selectedIndex! + 1);
        _detailController.forward();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        ),
        child: Row(
          children: [
            const Text('Nächster:', style: TextStyle(color: AppTheme.mediumGrey, fontSize: 13)),
            const SizedBox(width: 12),
            Text(next.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text('${next.name} – ${next.title}', style: AppTheme.titleStyle(fontSize: 15))),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.black),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn();
  }
}
