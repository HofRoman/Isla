import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'salah_tracker_screen.dart';
import 'quran_screen.dart';
import 'dhikr_screen.dart';
import 'more_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _tabAnimCtrl;

  final _pages = const [
    HomeScreen(),
    SalahTrackerScreen(),
    QuranScreen(),
    DhikrScreen(),
    MoreScreen(),
  ];

  final _tabItems = const [
    _TabItem(icon: Icons.home_rounded, label: 'Home'),
    _TabItem(icon: Icons.check_circle_outline_rounded, label: 'Gebet'),
    _TabItem(icon: Icons.menu_book_rounded, label: 'Koran'),
    _TabItem(icon: Icons.water_drop_rounded, label: 'Dhikr'),
    _TabItem(icon: Icons.grid_view_rounded, label: 'Mehr'),
  ];

  @override
  void initState() {
    super.initState();
    _tabAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _tabAnimCtrl.dispose();
    super.dispose();
  }

  void _switchTab(int i) {
    if (_currentIndex == i) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = i);
    _tabAnimCtrl.reset();
    _tabAnimCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: IndexedStack(index: _currentIndex, children: _pages),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 24, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(top: 12, bottom: bottom > 0 ? 4 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabItems.length, (i) => _buildTabButton(i)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int i) {
    final item = _tabItems[i];
    final isSelected = _currentIndex == i;

    return GestureDetector(
      onTap: () => _switchTab(i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 22,
              color: isSelected ? Colors.white : AppTheme.ink3,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: isSelected
                  ? Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: AppTheme.body(
                            size: 13,
                            color: Colors.white,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
