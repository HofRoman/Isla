import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  int _dhikrCount = 0;
  int _dhikrTarget = 33;
  int _selectedDhikrIndex = 0;
  int _totalDhikr = 0;
  int _quizHighScore = 0;
  int _totalCorrect = 0;
  String _selectedTranslation = 'de'; // 'de' or 'en'

  int get dhikrCount => _dhikrCount;
  int get dhikrTarget => _dhikrTarget;
  int get selectedDhikrIndex => _selectedDhikrIndex;
  int get totalDhikr => _totalDhikr;
  int get quizHighScore => _quizHighScore;
  int get totalCorrect => _totalCorrect;
  String get selectedTranslation => _selectedTranslation;

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _totalDhikr = prefs.getInt('total_dhikr') ?? 0;
    _quizHighScore = prefs.getInt('quiz_high_score') ?? 0;
    _totalCorrect = prefs.getInt('total_correct') ?? 0;
    _selectedTranslation = prefs.getString('translation') ?? 'de';
    notifyListeners();
  }

  void incrementDhikr() {
    _dhikrCount++;
    _totalDhikr++;
    _savePrefs();
    notifyListeners();
  }

  void resetDhikr() {
    _dhikrCount = 0;
    notifyListeners();
  }

  void setDhikrTarget(int target) {
    _dhikrTarget = target;
    notifyListeners();
  }

  void setSelectedDhikr(int index, int target) {
    _selectedDhikrIndex = index;
    _dhikrTarget = target;
    _dhikrCount = 0;
    notifyListeners();
  }

  void updateQuizScore(int score, int correct) {
    if (score > _quizHighScore) {
      _quizHighScore = score;
    }
    _totalCorrect += correct;
    _savePrefs();
    notifyListeners();
  }

  void toggleTranslation() {
    _selectedTranslation = _selectedTranslation == 'de' ? 'en' : 'de';
    _savePrefs();
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('total_dhikr', _totalDhikr);
    prefs.setInt('quiz_high_score', _quizHighScore);
    prefs.setInt('total_correct', _totalCorrect);
    prefs.setString('translation', _selectedTranslation);
  }
}
