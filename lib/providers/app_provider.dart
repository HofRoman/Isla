import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalahDay {
  final String date; // yyyy-MM-dd
  final Set<String> prayed; // {'fajr','dhuhr','asr','maghrib','ischa'}

  SalahDay({required this.date, required this.prayed});

  Map<String, dynamic> toJson() => {'date': date, 'prayed': prayed.toList()};
  factory SalahDay.fromJson(Map<String, dynamic> j) =>
      SalahDay(date: j['date'], prayed: Set<String>.from(j['prayed'] ?? []));
}

class AppProvider extends ChangeNotifier {
  // Dhikr
  int _dhikrCount = 0;
  int _dhikrTarget = 33;
  int _selectedDhikrIndex = 0;
  int _totalDhikr = 0;

  // Quiz
  int _quizHighScore = 0;
  int _totalCorrect = 0;

  // Koran
  String _selectedTranslation = 'de';

  // Salah Tracker
  Map<String, SalahDay> _salahHistory = {}; // key = date string
  int _salahStreak = 0;

  // Sunnah Checklist
  Map<String, Set<String>> _sunnahHistory = {}; // date -> completed sunnah ids
  int _sunnahStreak = 0;

  // Khatma Tracker: set of surah numbers completed
  Set<int> _completedSurahs = {};

  // Getters – Dhikr
  int get dhikrCount => _dhikrCount;
  int get dhikrTarget => _dhikrTarget;
  int get selectedDhikrIndex => _selectedDhikrIndex;
  int get totalDhikr => _totalDhikr;

  // Getters – Quiz
  int get quizHighScore => _quizHighScore;
  int get totalCorrect => _totalCorrect;

  // Getters – Koran
  String get selectedTranslation => _selectedTranslation;

  // Getters – Salah
  int get salahStreak => _salahStreak;
  SalahDay todaySalah => _salahHistory[_today] ?? SalahDay(date: _today, prayed: {});
  Map<String, SalahDay> get salahHistory => _salahHistory;

  // Getters – Sunnah
  int get sunnahStreak => _sunnahStreak;
  Set<String> get todaySunnah => _sunnahHistory[_today] ?? {};
  int get totalSunnahDays => _sunnahHistory.length;

  // Getters – Khatma
  Set<int> get completedSurahs => _completedSurahs;
  int get completedSurahCount => _completedSurahs.length;
  double get khatmaProgress => _completedSurahs.length / 114.0;

  String get _today {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  AppProvider() {
    _load();
  }

  // ── Dhikr ──────────────────────────────────────────────────
  void incrementDhikr() {
    _dhikrCount++;
    _totalDhikr++;
    _save();
    notifyListeners();
  }

  void resetDhikr() {
    _dhikrCount = 0;
    notifyListeners();
  }

  void setSelectedDhikr(int index, int target) {
    _selectedDhikrIndex = index;
    _dhikrTarget = target;
    _dhikrCount = 0;
    notifyListeners();
  }

  // ── Quiz ───────────────────────────────────────────────────
  void updateQuizScore(int score, int correct) {
    if (score > _quizHighScore) _quizHighScore = score;
    _totalCorrect += correct;
    _save();
    notifyListeners();
  }

  // ── Translation ────────────────────────────────────────────
  void toggleTranslation() {
    _selectedTranslation = _selectedTranslation == 'de' ? 'en' : 'de';
    _save();
    notifyListeners();
  }

  // ── Salah Tracker ──────────────────────────────────────────
  void togglePrayer(String prayerKey) {
    final day = _salahHistory[_today] ?? SalahDay(date: _today, prayed: {});
    final newPrayed = Set<String>.from(day.prayed);
    if (newPrayed.contains(prayerKey)) {
      newPrayed.remove(prayerKey);
    } else {
      newPrayed.add(prayerKey);
    }
    _salahHistory[_today] = SalahDay(date: _today, prayed: newPrayed);
    _computeSalahStreak();
    _save();
    notifyListeners();
  }

  bool isPrayerDone(String key) => todaySalah.prayed.contains(key);
  int todayPrayerCount() => todaySalah.prayed.length;

  void _computeSalahStreak() {
    int streak = 0;
    DateTime date = DateTime.now();
    while (true) {
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final day = _salahHistory[key];
      if (day != null && day.prayed.length == 5) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    _salahStreak = streak;
  }

  // ── Sunnah Tracker ─────────────────────────────────────────
  void toggleSunnah(String sunnahId) {
    final set = Set<String>.from(_sunnahHistory[_today] ?? {});
    if (set.contains(sunnahId)) {
      set.remove(sunnahId);
    } else {
      set.add(sunnahId);
    }
    _sunnahHistory[_today] = set;
    _computeSunnahStreak();
    _save();
    notifyListeners();
  }

  bool isSunnahDone(String id) => todaySunnah.contains(id);

  void _computeSunnahStreak() {
    int streak = 0;
    DateTime date = DateTime.now();
    while (true) {
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final set = _sunnahHistory[key];
      if (set != null && set.length >= 5) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    _sunnahStreak = streak;
  }

  // ── Khatma Tracker ─────────────────────────────────────────
  void toggleSurah(int surahNumber) {
    if (_completedSurahs.contains(surahNumber)) {
      _completedSurahs.remove(surahNumber);
    } else {
      _completedSurahs.add(surahNumber);
    }
    _save();
    notifyListeners();
  }

  bool isSurahCompleted(int n) => _completedSurahs.contains(n);

  void resetKhatma() {
    _completedSurahs.clear();
    _save();
    notifyListeners();
  }

  // ── Persistence ────────────────────────────────────────────
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _totalDhikr      = p.getInt('total_dhikr') ?? 0;
    _quizHighScore   = p.getInt('quiz_high_score') ?? 0;
    _totalCorrect    = p.getInt('total_correct') ?? 0;
    _selectedTranslation = p.getString('translation') ?? 'de';

    // Salah
    final salahJson = p.getString('salah_history');
    if (salahJson != null) {
      final map = jsonDecode(salahJson) as Map<String, dynamic>;
      _salahHistory = map.map((k, v) => MapEntry(k, SalahDay.fromJson(v as Map<String, dynamic>)));
    }

    // Sunnah
    final sunnahJson = p.getString('sunnah_history');
    if (sunnahJson != null) {
      final map = jsonDecode(sunnahJson) as Map<String, dynamic>;
      _sunnahHistory = map.map((k, v) => MapEntry(k, Set<String>.from(v as List)));
    }

    // Khatma
    final khatmaList = p.getStringList('completed_surahs');
    if (khatmaList != null) {
      _completedSurahs = khatmaList.map(int.parse).toSet();
    }

    _computeSalahStreak();
    _computeSunnahStreak();
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    p.setInt('total_dhikr', _totalDhikr);
    p.setInt('quiz_high_score', _quizHighScore);
    p.setInt('total_correct', _totalCorrect);
    p.setString('translation', _selectedTranslation);

    // Salah
    final salahMap = _salahHistory.map((k, v) => MapEntry(k, v.toJson()));
    p.setString('salah_history', jsonEncode(salahMap));

    // Sunnah
    final sunnahMap = _sunnahHistory.map((k, v) => MapEntry(k, v.toList()));
    p.setString('sunnah_history', jsonEncode(sunnahMap));

    // Khatma
    p.setStringList('completed_surahs', _completedSurahs.map((n) => n.toString()).toList());
  }
}
