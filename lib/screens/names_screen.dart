import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/names_data.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> with TickerProviderStateMixin {
  String _search = '';
  int? _selectedIndex;
  late AnimationController _detailController;
  final TextEditingController _searchController = TextEditingController();

  List<AllahuName> get _filtered {
    if (_search.isEmpty) return allahNames;
    return allahNames.where((n) {
      final q = _search.toLowerCase();
      return n.transliteration.toLowerCase().contains(q) ||
          n.german.toLowerCase().contains(q) ||
          n.english.toLowerCase().contains(q) ||
          n.arabic.contains(_search);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _detailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _detailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(int index) {
    setState(() => _selectedIndex = index);
    _detailController.forward();
  }

  void _closeDetail() {
    _detailController.reverse().then((_) {
      setState(() => _selectedIndex = null);
    });
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
            _selectedIndex != null ? Icons.close : Icons.arrow_back_ios,
            color: AppTheme.black,
          ),
          onPressed: () {
            if (_selectedIndex != null) {
              _closeDetail();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedIndex != null ? '' : 'أسماء الله الحسنى',
          style: TextStyle(
            fontFamily: 'Scheherazade New',
            fontSize: 26,
            color: AppTheme.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _buildGrid(),
              ),
            ],
          ),
          if (_selectedIndex != null) _buildDetailOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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
                  'Die 99 schönen Namen',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Allahs Namen lernen & verstehen',
                  style: AppTheme.bodyStyle(fontSize: 13, color: Colors.white60),
                ),
                const SizedBox(height: 12),
                Text(
                  '"Allah hat 99 Namen, wer sie zählt, tritt ins Paradies ein."',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: AppTheme.accentGold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '– Sahih al-Bukhari –',
                  style: GoogleFonts.lato(fontSize: 10, color: Colors.white60),
                ),
              ],
            ),
          ),
          Text(
            '٩٩',
            style: TextStyle(
              fontFamily: 'Scheherazade New',
              fontSize: 56,
              color: AppTheme.accentGold.withOpacity(0.4),
              height: 1,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _search = v),
        decoration: InputDecoration(
          hintText: 'Suche nach Namen...',
          hintStyle: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.mediumGrey),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.mediumGrey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _search = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final names = _filtered;
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemCount: names.length,
      itemBuilder: (ctx, i) => _buildNameCard(i, names[i]),
    );
  }

  Widget _buildNameCard(int index, AllahuName name) {
    return GestureDetector(
      onTap: () => _openDetail(allahNames.indexOf(name)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.black,
              ),
              child: Center(
                child: Text(
                  '${name.number}',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              name.arabic,
              style: TextStyle(
                fontFamily: 'Scheherazade New',
                fontSize: 30,
                color: AppTheme.black,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const Spacer(),
            Text(
              name.transliteration,
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              name.german,
              style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.mediumGrey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 30)).fadeIn().scale(
          begin: const Offset(0.95, 0.95),
          curve: Curves.easeOut,
        );
  }

  Widget _buildDetailOverlay() {
    if (_selectedIndex == null) return const SizedBox();
    final name = allahNames[_selectedIndex!];
    return FadeTransition(
      opacity: _detailController,
      child: GestureDetector(
        onTap: _closeDetail,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: _detailController, curve: Curves.easeOut)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.black,
                        ),
                        child: Center(
                          child: Text(
                            '${name.number}',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name.arabic,
                        style: TextStyle(
                          fontFamily: 'Scheherazade New',
                          fontSize: 52,
                          color: AppTheme.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name.transliteration,
                        style: AppTheme.titleStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name.german,
                        style: AppTheme.bodyStyle(fontSize: 16, color: AppTheme.mediumGrey),
                      ),
                      Text(
                        name.english,
                        style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.mediumGrey),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                        ),
                        child: Text(
                          name.meaning,
                          style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.softBlack),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (_selectedIndex! > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _selectedIndex = _selectedIndex! - 1;
                                }),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppTheme.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Icon(Icons.arrow_back, color: AppTheme.black),
                              ),
                            ),
                          if (_selectedIndex! > 0) const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _closeDetail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Schließen',
                                style: GoogleFonts.lato(color: Colors.white),
                              ),
                            ),
                          ),
                          if (_selectedIndex! < 98) const SizedBox(width: 10),
                          if (_selectedIndex! < 98)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _selectedIndex = _selectedIndex! + 1;
                                }),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppTheme.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Icon(Icons.arrow_forward, color: AppTheme.black),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
