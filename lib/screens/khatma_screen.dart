import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

// Full list of all 114 Surahs with their names
const _allSurahs = [
  [1,'Al-Fatiha','الفاتحة',7],
  [2,'Al-Baqara','البقرة',286],
  [3,'Al-Imran','آل عمران',200],
  [4,'An-Nisa','النساء',176],
  [5,'Al-Maida','المائدة',120],
  [6,'Al-Anam','الأنعام',165],
  [7,'Al-Araf','الأعراف',206],
  [8,'Al-Anfal','الأنفال',75],
  [9,'At-Tawba','التوبة',129],
  [10,'Yunus','يونس',109],
  [11,'Hud','هود',123],
  [12,'Yusuf','يوسف',111],
  [13,'Ar-Rad','الرعد',43],
  [14,'Ibrahim','إبراهيم',52],
  [15,'Al-Hijr','الحجر',99],
  [16,'An-Nahl','النحل',128],
  [17,'Al-Isra','الإسراء',111],
  [18,'Al-Kahf','الكهف',110],
  [19,'Maryam','مريم',98],
  [20,'Ta-Ha','طه',135],
  [21,'Al-Anbiya','الأنبياء',112],
  [22,'Al-Hajj','الحج',78],
  [23,'Al-Muminun','المؤمنون',118],
  [24,'An-Nur','النور',64],
  [25,'Al-Furqan','الفرقان',77],
  [26,'Ash-Shuara','الشعراء',227],
  [27,'An-Naml','النمل',93],
  [28,'Al-Qasas','القصص',88],
  [29,'Al-Ankabut','العنكبوت',69],
  [30,'Ar-Rum','الروم',60],
  [31,'Luqman','لقمان',34],
  [32,'As-Sajda','السجدة',30],
  [33,'Al-Ahzab','الأحزاب',73],
  [34,'Saba','سبأ',54],
  [35,'Fatir','فاطر',45],
  [36,'Ya-Sin','يس',83],
  [37,'As-Saffat','الصافات',182],
  [38,'Sad','ص',88],
  [39,'Az-Zumar','الزمر',75],
  [40,'Ghafir','غافر',85],
  [41,'Fussilat','فصلت',54],
  [42,'Ash-Shura','الشورى',53],
  [43,'Az-Zukhruf','الزخرف',89],
  [44,'Ad-Dukhan','الدخان',59],
  [45,'Al-Jathiya','الجاثية',37],
  [46,'Al-Ahqaf','الأحقاف',35],
  [47,'Muhammad','محمد',38],
  [48,'Al-Fath','الفتح',29],
  [49,'Al-Hujurat','الحجرات',18],
  [50,'Qaf','ق',45],
  [51,'Adh-Dhariyat','الذاريات',60],
  [52,'At-Tur','الطور',49],
  [53,'An-Najm','النجم',62],
  [54,'Al-Qamar','القمر',55],
  [55,'Ar-Rahman','الرحمن',78],
  [56,'Al-Waqia','الواقعة',96],
  [57,'Al-Hadid','الحديد',29],
  [58,'Al-Mujadila','المجادلة',22],
  [59,'Al-Hashr','الحشر',24],
  [60,'Al-Mumtahana','الممتحنة',13],
  [61,'As-Saf','الصف',14],
  [62,'Al-Jumua','الجمعة',11],
  [63,'Al-Munafiqun','المنافقون',11],
  [64,'At-Taghabun','التغابن',18],
  [65,'At-Talaq','الطلاق',12],
  [66,'At-Tahrim','التحريم',12],
  [67,'Al-Mulk','الملك',30],
  [68,'Al-Qalam','القلم',52],
  [69,'Al-Haqqa','الحاقة',52],
  [70,'Al-Maarij','المعارج',44],
  [71,'Nuh','نوح',28],
  [72,'Al-Jinn','الجن',28],
  [73,'Al-Muzzammil','المزمل',20],
  [74,'Al-Muddaththir','المدثر',56],
  [75,'Al-Qiyama','القيامة',40],
  [76,'Al-Insan','الإنسان',31],
  [77,'Al-Mursalat','المرسلات',50],
  [78,'An-Naba','النبأ',40],
  [79,'An-Naziat','النازعات',46],
  [80,'Abasa','عبس',42],
  [81,'At-Takwir','التكوير',29],
  [82,'Al-Infitar','الانفطار',19],
  [83,'Al-Mutaffifin','المطففين',36],
  [84,'Al-Inshiqaq','الانشقاق',25],
  [85,'Al-Buruj','البروج',22],
  [86,'At-Tariq','الطارق',17],
  [87,'Al-Ala','الأعلى',19],
  [88,'Al-Ghashiya','الغاشية',26],
  [89,'Al-Fajr','الفجر',30],
  [90,'Al-Balad','البلد',20],
  [91,'Ash-Shams','الشمس',15],
  [92,'Al-Lail','الليل',21],
  [93,'Ad-Duha','الضحى',11],
  [94,'Ash-Sharh','الشرح',8],
  [95,'At-Tin','التين',8],
  [96,'Al-Alaq','العلق',19],
  [97,'Al-Qadr','القدر',5],
  [98,'Al-Bayyina','البينة',8],
  [99,'Az-Zalzala','الزلزلة',8],
  [100,'Al-Adiyat','العاديات',11],
  [101,'Al-Qaria','القارعة',11],
  [102,'At-Takathur','التكاثر',8],
  [103,'Al-Asr','العصر',3],
  [104,'Al-Humaza','الهمزة',9],
  [105,'Al-Fil','الفيل',5],
  [106,'Quraish','قريش',4],
  [107,'Al-Maun','الماعون',7],
  [108,'Al-Kawthar','الكوثر',3],
  [109,'Al-Kafirun','الكافرون',6],
  [110,'An-Nasr','النصر',3],
  [111,'Al-Masad','المسد',5],
  [112,'Al-Ikhlas','الإخلاص',4],
  [113,'Al-Falaq','الفلق',5],
  [114,'An-Nas','الناس',6],
];

class KhatmaScreen extends StatefulWidget {
  const KhatmaScreen({super.key});
  @override
  State<KhatmaScreen> createState() => _KhatmaScreenState();
}

class _KhatmaScreenState extends State<KhatmaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  String _filter = 'all'; // 'all' | 'done' | 'pending'
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _progressCtrl.forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        final done = provider.completedSurahCount;
        final progress = provider.khatmaProgress;

        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(provider, done, progress),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFilterRow(),
                    const SizedBox(height: 16),
                    ..._buildSurahList(provider),
                    const SizedBox(height: 40),
                  ]),
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
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppTheme.bg,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.ink),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.subtleShadow,
            ),
            child: const Icon(Icons.refresh_rounded, size: 16, color: AppTheme.red),
          ),
          onPressed: () => _confirmReset(context, provider),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF1A2A1A)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 44, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('خَتْمَة القُرْآن', style: AppTheme.arabic(size: 22, color: AppTheme.gold), textDirection: TextDirection.rtl),
                  const SizedBox(height: 4),
                  Text('Khatma Tracker', style: AppTheme.display(size: 28, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Verfolge deine Koran-Komplettle sung', style: AppTheme.body(size: 13, color: Colors.white60)),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _progressCtrl,
                    builder: (ctx, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$done / 114 Suren',
                              style: AppTheme.body(size: 15, color: Colors.white, weight: FontWeight.w700),
                            ),
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}%',
                              style: AppTheme.title(size: 17, color: AppTheme.gold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress * _progressCtrl.value,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            valueColor: const AlwaysStoppedAnimation(AppTheme.gold),
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _pill('📖 ${114 - done} verbleiben'),
                            const SizedBox(width: 8),
                            if (done == 114) _pill('🎉 Khatma complete!'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Text(text, style: AppTheme.label(size: 11, color: Colors.white70)),
  );

  Widget _buildFilterRow() {
    final options = [
      {'key': 'all', 'label': 'Alle'},
      {'key': 'done', 'label': 'Gelesen'},
      {'key': 'pending', 'label': 'Ausstehend'},
    ];
    return Row(
      children: options.map((o) {
        final selected = _filter == o['key'];
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => setState(() => _filter = o['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? AppTheme.ink : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: selected ? AppTheme.subtleShadow : [],
              ),
              child: Text(
                o['label']!,
                style: AppTheme.body(
                  size: 13,
                  color: selected ? Colors.white : AppTheme.ink2,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 100.ms);
  }

  List<Widget> _buildSurahList(AppProvider provider) {
    final filtered = _allSurahs.where((s) {
      final done = provider.isSurahCompleted(s[0] as int);
      if (_filter == 'done') return done;
      if (_filter == 'pending') return !done;
      return true;
    }).toList();

    return filtered.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      final num = s[0] as int;
      final name = s[1] as String;
      final arabic = s[2] as String;
      final verses = s[3] as int;
      final done = provider.isSurahCompleted(num);

      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          provider.toggleSurah(num);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: done ? AppTheme.ink : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: done ? AppTheme.elevatedShadow : AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              // Number badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 40,
                height: 40,
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
                      ? const Icon(Icons.check_rounded, color: AppTheme.gold, size: 18)
                      : Text(
                          '$num',
                          style: AppTheme.label(size: 12, color: done ? AppTheme.gold : AppTheme.ink2),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTheme.body(size: 15, color: done ? Colors.white : AppTheme.ink, weight: FontWeight.w600),
                    ),
                    Text(
                      '$verses Verse',
                      style: AppTheme.caption(color: done ? Colors.white54 : AppTheme.ink3),
                    ),
                  ],
                ),
              ),
              Text(
                arabic,
                style: AppTheme.arabic(size: 20, color: done ? AppTheme.gold : AppTheme.ink2),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ).animate(delay: Duration(milliseconds: i * 20)).fadeIn();
    }).toList();
  }

  void _confirmReset(BuildContext ctx, AppProvider provider) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.separator, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('⚠️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('Khatma zurücksetzen?', style: AppTheme.title(size: 20)),
            const SizedBox(height: 8),
            Text(
              'Alle ${provider.completedSurahCount} markierten Suren werden zurückgesetzt.',
              style: AppTheme.body(color: AppTheme.ink2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.ink,
                      side: const BorderSide(color: AppTheme.separator),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Abbrechen', style: AppTheme.body(size: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.resetKhatma();
                      Navigator.pop(ctx);
                      _progressCtrl.reset();
                      _progressCtrl.forward();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Zurücksetzen', style: AppTheme.body(size: 15, color: Colors.white, weight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
