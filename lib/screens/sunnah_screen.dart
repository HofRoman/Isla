import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../data/sunnah_data.dart';

class SunnahScreen extends StatefulWidget {
  const SunnahScreen({super.key});
  @override
  State<SunnahScreen> createState() => _SunnahScreenState();
}

class _SunnahScreenState extends State<SunnahScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<SunnahItem> _filtered(String time) =>
      time == 'all' ? sunnahList : sunnahList.where((s) => s.timeOfDay == time).toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        final done = sunnahList.where((s) => provider.isSunnahDone(s.id)).length;
        final progress = done / sunnahList.length;

        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(provider, done, progress),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabs,
                  labelColor: AppTheme.ink,
                  unselectedLabelColor: AppTheme.ink3,
                  indicatorColor: AppTheme.ink,
                  indicatorWeight: 2,
                  labelStyle: AppTheme.body(size: 13, weight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Alle'),
                    Tab(text: 'Morgen'),
                    Tab(text: 'Nachmittag'),
                    Tab(text: 'Abend'),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    _buildList('all', provider),
                    _buildList('morning', provider),
                    _buildList('afternoon', provider),
                    _buildList('evening', provider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(AppProvider provider, int done, double progress) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.bg,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.ink),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF1C2840)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السُّنَّة النَّبَوِيَّة',
                    style: AppTheme.arabic(size: 24, color: AppTheme.gold),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sunnah des Tages',
                    style: AppTheme.display(size: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation(AppTheme.gold),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$done / ${sunnahList.length}',
                        style: AppTheme.body(size: 14, color: Colors.white, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _chip('🔥 ${provider.sunnahStreak} Tage Streak'),
                      const SizedBox(width: 8),
                      _chip('✅ $done abgeschlossen'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Text(text, style: AppTheme.caption(size: 11, color: Colors.white70)),
  );

  Widget _buildList(String filter, AppProvider provider) {
    final items = _filtered(filter);
    if (items.isEmpty) {
      return Center(
        child: Text('Keine Einträge', style: AppTheme.body(color: AppTheme.ink3)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildSunnahCard(items[i], provider, i),
    );
  }

  Widget _buildSunnahCard(SunnahItem item, AppProvider provider, int i) {
    final done = provider.isSunnahDone(item.id);
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        provider.toggleSunnah(item.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done ? AppTheme.ink : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: done ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppTheme.gold.withOpacity(0.15) : AppTheme.bg,
                border: Border.all(
                  color: done ? AppTheme.gold : AppTheme.separator,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded, color: AppTheme.gold, size: 22)
                    : Text(item.icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTheme.body(
                      size: 15,
                      color: done ? Colors.white : AppTheme.ink,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: AppTheme.caption(
                      size: 12,
                      color: done ? Colors.white60 : AppTheme.ink3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.arabic,
                    style: AppTheme.arabic(
                      size: 18,
                      color: done ? AppTheme.gold : AppTheme.ink2,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: done ? Colors.white.withOpacity(0.08) : AppTheme.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '📚 ${item.source}',
                      style: AppTheme.label(size: 10, color: done ? Colors.white54 : AppTheme.ink3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: i * 50)).fadeIn().slideX(begin: 0.04);
  }
}
