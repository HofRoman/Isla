import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/azkar_data.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  // counts[id] = current count
  final Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  int _count(String id) => _counts[id] ?? 0;
  bool _done(AzkarItem a) => _count(a.id) >= a.targetCount;

  void _tap(AzkarItem a) {
    if (_done(a)) return;
    HapticFeedback.lightImpact();
    setState(() {
      _counts[a.id] = (_counts[a.id] ?? 0) + 1;
    });
  }

  int _completedCount(List<AzkarItem> list) => list.where(_done).length;

  void _resetAll(List<AzkarItem> list) {
    for (final a in list) _counts.remove(a.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMorning = _tabCtrl.index == 0;
    final list = isMorning ? morningAzkar : eveningAzkar;
    final done = _completedCount(list);
    final total = list.length;
    final progress = done / total;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.ink,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHero(isMorning, done, total, progress),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: _buildTabBar(),
            ),
            actions: [
              if (done > 0)
                TextButton(
                  onPressed: () => _resetAll(list),
                  child: Text('Zurücksetzen',
                      style: AppTheme.caption(size: 12, color: Colors.white70)),
                ),
            ],
          ),
        ],
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          itemCount: list.length,
          itemBuilder: (ctx, i) => _AzkarCard(
            item: list[i],
            count: _count(list[i].id),
            onTap: () => _tap(list[i]),
          ).animate(delay: Duration(milliseconds: i * 50)).fadeIn(duration: 300.ms).slideY(begin: 0.05),
        ),
      ),
    );
  }

  Widget _buildHero(bool isMorning, int done, int total, double progress) {
    return Container(
      decoration: const BoxDecoration(color: AppTheme.ink),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isMorning ? '🌅' : '🌙',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMorning ? 'Morgen-Azkar' : 'Abend-Azkar',
                    style: AppTheme.title(size: 20, color: Colors.white),
                  ),
                  Text(
                    isMorning ? 'أَذْكَار الصَّبَاح' : 'أَذْكَار الْمَسَاء',
                    style: AppTheme.arabic(size: 16, color: AppTheme.gold),
                  ),
                ],
              ),
              const Spacer(),
              _RingProgress(progress: progress, done: done, total: total),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0 ? AppTheme.green : AppTheme.gold,
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            done == total
                ? 'Alle Azkar abgeschlossen — ما شاء الله'
                : '$done von $total abgeschlossen',
            style: AppTheme.caption(size: 12, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.ink,
      child: TabBar(
        controller: _tabCtrl,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        indicatorColor: AppTheme.gold,
        indicatorWeight: 2,
        labelStyle: AppTheme.body(size: 14, color: Colors.white, weight: FontWeight.w600),
        unselectedLabelStyle: AppTheme.body(size: 14, color: Colors.white38),
        tabs: const [
          Tab(text: '🌅  Morgen'),
          Tab(text: '🌙  Abend'),
        ],
      ),
    );
  }
}

// ── Individual Azkar Card ──────────────────────────────────────────────────
class _AzkarCard extends StatelessWidget {
  final AzkarItem item;
  final int count;
  final VoidCallback onTap;

  const _AzkarCard({required this.item, required this.count, required this.onTap});

  bool get _done => count >= item.targetCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _done ? AppTheme.ink : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _done ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        border: _done
            ? Border.all(color: AppTheme.gold.withOpacity(0.4), width: 1)
            : null,
      ),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Arabic text
              Text(
                item.arabic,
                style: AppTheme.arabic(
                  size: 20,
                  color: _done ? Colors.white : AppTheme.ink,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 10),
              // German translation
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.german,
                  style: AppTheme.body(
                    size: 13,
                    color: _done ? Colors.white60 : AppTheme.ink2,
                  ),
                ),
              ),
              // Virtue text if present
              if (item.virtueDE != null) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(_done ? 0.2 : 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.virtueDE!,
                      style: AppTheme.caption(
                        size: 11,
                        color: _done ? AppTheme.gold : AppTheme.gold,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              // Bottom row: source + counter
              Row(
                children: [
                  Text(
                    item.source,
                    style: AppTheme.label(
                      size: 10,
                      color: _done ? Colors.white38 : AppTheme.ink3,
                    ),
                  ),
                  const Spacer(),
                  // Counter button
                  GestureDetector(
                    onTap: onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: _done
                            ? AppTheme.gold.withOpacity(0.25)
                            : AppTheme.bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _done ? AppTheme.gold : AppTheme.separator,
                          width: 1.5,
                        ),
                      ),
                      child: _done
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_rounded, color: AppTheme.gold, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${item.targetCount}×',
                                  style: AppTheme.title(size: 14, color: AppTheme.gold),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$count',
                                  style: AppTheme.title(size: 16, color: AppTheme.ink),
                                ),
                                Text(
                                  ' / ${item.targetCount}',
                                  style: AppTheme.caption(size: 12, color: AppTheme.ink3),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ring Progress Widget ───────────────────────────────────────────────────
class _RingProgress extends StatelessWidget {
  final double progress;
  final int done, total;
  const _RingProgress({required this.progress, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(
              progress >= 1.0 ? AppTheme.green : AppTheme.gold,
            ),
            strokeWidth: 4,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$done',
                style: AppTheme.title(size: 14, color: Colors.white),
              ),
              Text(
                '/$total',
                style: AppTheme.caption(size: 9, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
