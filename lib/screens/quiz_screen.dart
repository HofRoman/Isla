import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/quiz_data.dart';
import '../providers/app_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int? _selectedCategoryIndex;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  int _correctCount = 0;
  bool _quizDone = false;
  List<QuizQuestion> _questions = [];
  late ConfettiController _confettiController;
  late AnimationController _progressController;
  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _progressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _cardController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _cardController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _progressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _startCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _questions = List.from(quizCategories[index].questions)..shuffle();
      _currentQuestion = 0;
      _selectedAnswer = null;
      _answered = false;
      _score = 0;
      _correctCount = 0;
      _quizDone = false;
    });
    _cardController.reset();
    _cardController.forward();
  }

  void _selectAnswer(int answerIndex) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = answerIndex;
      _answered = true;
      if (answerIndex == _questions[_currentQuestion].correctIndex) {
        _score += 10;
        _correctCount++;
      }
    });
    _progressController.animateTo((_currentQuestion + 1) / _questions.length);
  }

  void _nextQuestion() {
    if (_currentQuestion + 1 >= _questions.length) {
      setState(() => _quizDone = true);
      if (_correctCount == _questions.length) {
        _confettiController.play();
      }
      context.read<AppProvider>().updateQuizScore(_score, _correctCount);
      return;
    }
    setState(() {
      _currentQuestion++;
      _selectedAnswer = null;
      _answered = false;
    });
    _cardController.reset();
    _cardController.forward();
  }

  void _reset() {
    setState(() {
      _selectedCategoryIndex = null;
      _quizDone = false;
      _score = 0;
      _correctCount = 0;
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
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.black),
          onPressed: () {
            if (_selectedCategoryIndex != null && !_quizDone) {
              _reset();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedCategoryIndex == null
              ? 'Quiz'
              : _quizDone
                  ? 'Ergebnis'
                  : quizCategories[_selectedCategoryIndex!].name,
          style: AppTheme.titleStyle(fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          _selectedCategoryIndex == null
              ? _buildCategorySelector()
              : _quizDone
                  ? _buildResults()
                  : _buildQuiz(),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [AppTheme.black, AppTheme.accentGold, Colors.white],
              numberOfParticles: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wähle eine Kategorie',
            style: AppTheme.titleStyle(fontSize: 26),
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 8),
          Text(
            'Teste dein islamisches Wissen',
            style: AppTheme.bodyStyle(fontSize: 15, color: AppTheme.mediumGrey),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 28),
          ...quizCategories.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            return _buildCategoryCard(i, cat);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(int index, QuizCategory cat) {
    return GestureDetector(
      onTap: () => _startCategory(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
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
            Text(cat.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.name, style: AppTheme.titleStyle(fontSize: 19)),
                  const SizedBox(height: 4),
                  Text(
                    '${cat.questions.length} Fragen',
                    style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 80)).fadeIn().slideX(begin: 0.1);
  }

  Widget _buildQuiz() {
    final q = _questions[_currentQuestion];
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Frage ${_currentQuestion + 1} von ${_questions.length}',
                  style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
                      .animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut)),
                  child: FadeTransition(
                    opacity: _cardController,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        q.question,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...q.options.asMap().entries.map((entry) {
                  final i = entry.key;
                  final opt = entry.value;
                  return _buildOptionTile(i, opt, q.correctIndex);
                }),
                if (_answered) _buildExplanation(q.explanation),
                const SizedBox(height: 20),
                if (_answered)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _currentQuestion + 1 >= _questions.length ? 'Ergebnis anzeigen' : 'Nächste Frage',
                      style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punkte: $_score', style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
              Text('$_correctCount richtig', style: AppTheme.bodyStyle(fontSize: 13, color: AppTheme.mediumGrey)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentQuestion + 1) / _questions.length,
              backgroundColor: AppTheme.lightGrey,
              valueColor: const AlwaysStoppedAnimation(AppTheme.black),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int index, String option, int correctIndex) {
    Color bgColor = AppTheme.white;
    Color borderColor = const Color(0xFFE8E8E8);
    Color textColor = AppTheme.black;
    IconData? trailingIcon;

    if (_answered) {
      if (index == correctIndex) {
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
      } else if (index == _selectedAnswer && index != correctIndex) {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
        trailingIcon = Icons.cancel;
      }
    } else if (_selectedAnswer == index) {
      bgColor = AppTheme.lightGrey;
      borderColor = AppTheme.black;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _answered && index == correctIndex
                    ? Colors.green
                    : _answered && index == _selectedAnswer
                        ? Colors.red
                        : AppTheme.lightGrey,
              ),
              child: Center(
                child: Text(
                  ['A', 'B', 'C', 'D'][index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _answered ? Colors.white : AppTheme.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(option, style: AppTheme.bodyStyle(fontSize: 15, color: textColor)),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: index == correctIndex ? Colors.green : Colors.red, size: 22),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 + index * 60)).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildExplanation(String explanation) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanation,
              style: AppTheme.bodyStyle(fontSize: 14, color: AppTheme.softBlack),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildResults() {
    final percentage = (_correctCount / _questions.length * 100).round();
    final isGreat = percentage >= 70;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isGreat ? '🏆' : '📚',
              style: const TextStyle(fontSize: 72),
            ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
            const SizedBox(height: 24),
            Text(
              isGreat ? 'Mashallah!' : 'Weiter so!',
              style: AppTheme.titleStyle(fontSize: 32),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              isGreat ? 'Ausgezeichnet!' : 'Mehr lernen bringt mehr Wissen',
              style: AppTheme.bodyStyle(fontSize: 16, color: AppTheme.mediumGrey),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: BorderRadius.circular(28),
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
                  Text(
                    '$percentage%',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGold,
                    ),
                  ),
                  Text(
                    '$_correctCount von ${_questions.length} richtig',
                    style: AppTheme.bodyStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Punkte: $_score',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate().scale(delay: 400.ms, curve: Curves.easeOut),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.black, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Kategorien', style: AppTheme.bodyStyle(fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startCategory(_selectedCategoryIndex!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Nochmal',
                      style: GoogleFonts.lato(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
