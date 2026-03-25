import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/duas_data.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  int? _selectedCategory;
  int? _expandedDua;

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
            if (_selectedCategory != null) {
              setState(() { _selectedCategory = null; _expandedDua = null; });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedCategory == null
              ? 'Duas & Gebete'
              : duaCategories[_selectedCategory!].name,
          style: AppTheme.titleStyle(fontSize: 22),
        ),
      ),
      body: _selectedCategory == null ? _buildCategoryGrid() : _buildDuaList(),
    );
  }

  Widget _buildCategoryGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDuaHeader(),
          const SizedBox(height: 24),
          Text('Kategorie wählen', style: AppTheme.titleStyle(fontSize: 20))
              .animate().fadeIn(),
          const SizedBox(height: 4),
          Text(
            'Alltägliche Gebete aus Quran & Sunnah',
            style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
            ),
            itemCount: duaCategories.length,
            itemBuilder: (ctx, i) => _buildCategoryCard(i),
          ),
        ],
      ),
    );
  }

  Widget _buildDuaHeader() {
    return Container(
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
                  'الدُّعَاء',
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 32,
                    color: AppTheme.accentGold,
                    height: 1.4,
                  ),
                ),
                Text(
                  'Ad-Du\'a – Das Gebet',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Du\'a ist das Mark des Gottesdienstes." – Hadith',
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white60, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Text('🤲', style: TextStyle(fontSize: 44)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildCategoryCard(int index) {
    final cat = duaCategories[index];
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = index),
      child: Container(
        padding: const EdgeInsets.all(18),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cat.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 10),
            Text(cat.name, style: AppTheme.titleStyle(fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              '${cat.duas.length} Duas',
              style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.mediumGrey),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 70)).fadeIn().scale(
          begin: const Offset(0.92, 0.92), curve: Curves.easeOut,
        );
  }

  Widget _buildDuaList() {
    final cat = duaCategories[_selectedCategory!];
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: cat.duas.length,
      itemBuilder: (ctx, i) => _buildDuaCard(i, cat.duas[i]),
    );
  }

  Widget _buildDuaCard(int index, Dua dua) {
    final isExpanded = _expandedDua == index;
    return GestureDetector(
      onTap: () => setState(() => _expandedDua = isExpanded ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded ? AppTheme.black : const Color(0xFFE8E8E8),
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isExpanded ? 0.08 : 0.03),
              blurRadius: isExpanded ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isExpanded ? AppTheme.black : AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isExpanded ? Colors.white : AppTheme.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(dua.title, style: AppTheme.titleStyle(fontSize: 16)),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.black,
                  ),
                ],
              ),
            ),
            // Preview arabic
            if (!isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: Text(
                  dua.arabic,
                  style: TextStyle(
                    fontFamily: 'Scheherazade New',
                    fontSize: 22,
                    color: AppTheme.mediumGrey,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // Expanded content
            if (isExpanded)
              Column(
                children: [
                  const Divider(color: Color(0xFFEEEEEE), height: 1),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Arabic
                        Text(
                          dua.arabic,
                          style: TextStyle(
                            fontFamily: 'Scheherazade New',
                            fontSize: 28,
                            color: AppTheme.black,
                            height: 2.2,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 12),
                        // Transliteration
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dua.transliteration,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: AppTheme.mediumGrey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // German
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dua.german,
                            style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.softBlack),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // English
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dua.english,
                            style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Source + Copy
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.lightGrey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('📚', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 5),
                                  Text(
                                    dua.source,
                                    style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.mediumGrey),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: '${dua.arabic}\n\n${dua.german}\n\n${dua.english}\n\n${dua.source}',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Dua kopiert', style: AppTheme.bodyStyle(fontSize: 13, color: Colors.white)),
                                    backgroundColor: AppTheme.black,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.copy, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 60)).fadeIn().slideY(begin: 0.05);
  }
}
