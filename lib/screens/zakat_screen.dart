import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> with TickerProviderStateMixin {
  // Prices (user-editable)
  double _goldPricePerGram = 58.0;  // EUR/gram (approx.)
  double _silverPricePerGram = 0.85; // EUR/gram (approx.)

  // Inputs
  final _goldCtrl    = TextEditingController(text: '0');
  final _silverCtrl  = TextEditingController(text: '0');
  final _cashCtrl    = TextEditingController(text: '0');
  final _businessCtrl = TextEditingController(text: '0');
  final _investCtrl  = TextEditingController(text: '0');
  final _debtsCtrl   = TextEditingController(text: '0');

  // Nisab constants
  static const double _goldNisabGrams   = 85.0;
  static const double _silverNisabGrams = 595.0;
  static const double _zakatRate        = 0.025;

  bool _hawlConfirmed = false;

  double _parse(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0.0;

  double get _goldGrams   => _parse(_goldCtrl);
  double get _silverGrams => _parse(_silverCtrl);
  double get _cashEur     => _parse(_cashCtrl);
  double get _businessEur => _parse(_businessCtrl);
  double get _investEur   => _parse(_investCtrl);
  double get _debtsEur    => _parse(_debtsCtrl);

  double get _goldValue    => _goldGrams * _goldPricePerGram;
  double get _silverValue  => _silverGrams * _silverPricePerGram;
  double get _goldNisab    => _goldNisabGrams * _goldPricePerGram;
  double get _silverNisab  => _silverNisabGrams * _silverPricePerGram;
  double get _nisab        => math.min(_goldNisab, _silverNisab); // use lower

  double get _totalWealth  => _goldValue + _silverValue + _cashEur + _businessEur + _investEur;
  double get _netWealth    => math.max(0, _totalWealth - _debtsEur);
  bool   get _nisabMet     => _netWealth >= _nisab;
  double get _zakatDue     => _nisabMet && _hawlConfirmed ? _netWealth * _zakatRate : 0;

  @override
  void dispose() {
    _goldCtrl.dispose(); _silverCtrl.dispose(); _cashCtrl.dispose();
    _businessCtrl.dispose(); _investCtrl.dispose(); _debtsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.ink,
            foregroundColor: Colors.white,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.ink,
                padding: const EdgeInsets.fromLTRB(24, 64, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('الزَّكَاة', style: AppTheme.arabic(size: 26, color: AppTheme.gold)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                          ),
                          child: Text('2,5% vom Vermögen',
                              style: AppTheme.caption(size: 11, color: AppTheme.gold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Zakat Rechner', style: AppTheme.title(size: 22, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Result Card ───────────────────────────────
                _buildResultCard().animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
                const SizedBox(height: 24),

                // ── Nisab Info ────────────────────────────────
                _sectionLabel('NISAB (Mindestgrenze)'),
                const SizedBox(height: 10),
                _buildNisabCard().animate(delay: 60.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 24),

                // ── Gold & Silver ─────────────────────────────
                _sectionLabel('EDELMETALLE'),
                const SizedBox(height: 10),
                _buildMetalsCard().animate(delay: 100.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 16),

                // ── Cash & Business ───────────────────────────
                _sectionLabel('GELD & VERMÖGEN'),
                const SizedBox(height: 10),
                _buildWealthCard().animate(delay: 140.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 16),

                // ── Debts ─────────────────────────────────────
                _sectionLabel('SCHULDEN (abzuziehen)'),
                const SizedBox(height: 10),
                _buildDebtsCard().animate(delay: 180.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 24),

                // ── Hawl confirmation ─────────────────────────
                _buildHawlCard().animate(delay: 220.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 24),

                // ── Price settings ────────────────────────────
                _sectionLabel('PREISE ANPASSEN'),
                const SizedBox(height: 10),
                _buildPricesCard().animate(delay: 260.ms).fadeIn().slideY(begin: 0.04),
                const SizedBox(height: 24),

                // ── Info card ─────────────────────────────────
                _buildInfoCard().animate(delay: 300.ms).fadeIn(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Result Card ──────────────────────────────────────────────────────────
  Widget _buildResultCard() {
    final Color statusColor;
    final String statusText;
    final String statusIcon;

    if (!_hawlConfirmed) {
      statusColor = AppTheme.ink3;
      statusText = 'Bestätige den Hawl';
      statusIcon = '⏳';
    } else if (!_nisabMet) {
      statusColor = AppTheme.ink3;
      statusText = 'Nisab nicht erreicht — kein Zakat fällig';
      statusIcon = '⚖️';
    } else {
      statusColor = AppTheme.green;
      statusText = 'Zakat ist fällig — بارك الله فيك';
      statusIcon = '✅';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(statusIcon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(statusText,
                    style: AppTheme.body(size: 14, color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _resultTile('Nettovermögen',
                  '${_netWealth.toStringAsFixed(2)} €', Colors.white),
              _vDivider(),
              _resultTile('Nisab',
                  '${_nisab.toStringAsFixed(2)} €', Colors.white54),
              _vDivider(),
              _resultTile('Zakat fällig',
                  _zakatDue > 0 ? '${_zakatDue.toStringAsFixed(2)} €' : '—',
                  _zakatDue > 0 ? AppTheme.gold : AppTheme.ink3),
            ],
          ),
          if (_zakatDue > 0) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('Dein Zakat für dieses Jahr',
                      style: AppTheme.caption(size: 12, color: AppTheme.gold)),
                  const SizedBox(height: 6),
                  Text('${_zakatDue.toStringAsFixed(2)} €',
                      style: AppTheme.display(size: 32, color: AppTheme.gold)),
                  Text('= ${(_netWealth * _zakatRate * 100).toStringAsFixed(4)}% von Nettovermögen',
                      style: AppTheme.caption(size: 10, color: Colors.white38)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _resultTile(String label, String value, Color color) => Expanded(
    child: Column(
      children: [
        Text(value, style: AppTheme.title(size: 14, color: color),
            textAlign: TextAlign.center),
        const SizedBox(height: 3),
        Text(label, style: AppTheme.caption(size: 10, color: Colors.white38),
            textAlign: TextAlign.center),
      ],
    ),
  );

  Widget _vDivider() => Container(width: 1, height: 36, color: Colors.white12);

  // ── Nisab Card ───────────────────────────────────────────────────────────
  Widget _buildNisabCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _nisabRow('Gold-Nisab', '85g × ${_goldPricePerGram.toStringAsFixed(0)}€',
              '${_goldNisab.toStringAsFixed(2)} €',
              _goldValue >= _goldNisab && _goldGrams > 0),
          const Divider(height: 20, color: AppTheme.separator),
          _nisabRow('Silber-Nisab', '595g × ${_silverPricePerGram.toStringAsFixed(2)}€',
              '${_silverNisab.toStringAsFixed(2)} €',
              _silverValue >= _silverNisab && _silverGrams > 0),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('⚖️'),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Es wird der niedrigere Nisab-Wert verwendet (Silber). Dies ist die strengere Meinung zum Schutz der Armen.',
                    style: AppTheme.caption(size: 11, color: AppTheme.ink3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nisabRow(String title, String formula, String value, bool met) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.body(size: 14, weight: FontWeight.w600)),
              Text(formula, style: AppTheme.caption()),
            ],
          ),
        ),
        Text(value, style: AppTheme.title(size: 14)),
      ],
    );
  }

  // ── Metals Card ──────────────────────────────────────────────────────────
  Widget _buildMetalsCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _inputRow(
            label: 'Gold',
            icon: '🥇',
            unit: 'Gramm',
            ctrl: _goldCtrl,
            calculatedValue: _goldValue,
          ),
          const Divider(height: 20, color: AppTheme.separator),
          _inputRow(
            label: 'Silber',
            icon: '🥈',
            unit: 'Gramm',
            ctrl: _silverCtrl,
            calculatedValue: _silverValue,
          ),
        ],
      ),
    );
  }

  // ── Wealth Card ──────────────────────────────────────────────────────────
  Widget _buildWealthCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _inputRow(
            label: 'Bargeld & Bankguthaben',
            icon: '💶',
            unit: '€',
            ctrl: _cashCtrl,
          ),
          const Divider(height: 20, color: AppTheme.separator),
          _inputRow(
            label: 'Geschäftswaren',
            icon: '📦',
            unit: '€',
            ctrl: _businessCtrl,
          ),
          const Divider(height: 20, color: AppTheme.separator),
          _inputRow(
            label: 'Investitionen (Halal)',
            icon: '📈',
            unit: '€',
            ctrl: _investCtrl,
          ),
        ],
      ),
    );
  }

  // ── Debts Card ───────────────────────────────────────────────────────────
  Widget _buildDebtsCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: _inputRow(
        label: 'Kurzfristige Schulden',
        icon: '📉',
        unit: '€',
        ctrl: _debtsCtrl,
      ),
    );
  }

  Widget _inputRow({
    required String label,
    required String icon,
    required String unit,
    required TextEditingController ctrl,
    double? calculatedValue,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.body(size: 14, weight: FontWeight.w600)),
              if (calculatedValue != null)
                Text('≈ ${calculatedValue.toStringAsFixed(2)} €',
                    style: AppTheme.caption(size: 11, color: AppTheme.gold)),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: AppTheme.title(size: 16),
            decoration: InputDecoration(
              suffixText: unit,
              suffixStyle: AppTheme.caption(size: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              isDense: true,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  // ── Hawl Card ─────────────────────────────────────────────────────────────
  Widget _buildHawlCard() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _hawlConfirmed = !_hawlConfirmed);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hawlConfirmed ? AppTheme.ink : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
          border: _hawlConfirmed
              ? Border.all(color: AppTheme.gold.withOpacity(0.4))
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hawlConfirmed ? AppTheme.gold : AppTheme.bg,
                border: Border.all(
                  color: _hawlConfirmed ? AppTheme.gold : AppTheme.separator,
                  width: 2,
                ),
              ),
              child: _hawlConfirmed
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hawl (Ein Jahr) bestätigen',
                    style: AppTheme.body(
                        size: 15,
                        weight: FontWeight.w600,
                        color: _hawlConfirmed ? Colors.white : AppTheme.ink),
                  ),
                  Text(
                    'Mein Vermögen übersteigt den Nisab seit mindestens einem islamischen Jahr.',
                    style: AppTheme.caption(
                        size: 11,
                        color: _hawlConfirmed ? Colors.white54 : AppTheme.ink3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Prices Card ───────────────────────────────────────────────────────────
  Widget _buildPricesCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktuelle Preise eingeben (€ pro Gramm)',
            style: AppTheme.caption(size: 12, color: AppTheme.ink3),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _priceField(
                  '🥇 Gold (€/g)',
                  _goldPricePerGram.toString(),
                  (v) { final d = double.tryParse(v); if (d != null) setState(() => _goldPricePerGram = d); },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _priceField(
                  '🥈 Silber (€/g)',
                  _silverPricePerGram.toString(),
                  (v) { final d = double.tryParse(v); if (d != null) setState(() => _silverPricePerGram = d); },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceField(String label, String init, void Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.caption(size: 11)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: init,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTheme.body(size: 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.separator),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.separator),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            isDense: true,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ── Info Card ─────────────────────────────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('ℹ️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text('Wichtige Hinweise', style: AppTheme.body(size: 14, weight: FontWeight.w600, color: AppTheme.gold)),
          ]),
          const SizedBox(height: 10),
          _infoLine('Zakat beträgt 2,5% des Nettovermögens nach Abzug kurzfristiger Schulden.'),
          _infoLine('Gold (85g) und Silber (595g) sind die Nisab-Grenzen. Es wird der niedrigere Wert verwendet.'),
          _infoLine('Zakatable Vermögenswerte: Gold, Silber, Bargeld, Geschäftswaren, Investitionen.'),
          _infoLine('Nicht zakatable: Eigenheim, Fahrzeuge, persönliche Gebrauchsgegenstände.'),
          _infoLine('Diese App dient nur als Orientierungshilfe. Bitte konsultiere bei Unklarheiten einen Gelehrten.'),
        ],
      ),
    );
  }

  Widget _infoLine(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: AppTheme.caption(size: 12, color: AppTheme.gold)),
        Expanded(child: Text(text, style: AppTheme.caption(size: 12, color: AppTheme.ink2))),
      ],
    ),
  );

  Widget _sectionLabel(String text) => Text(
    text,
    style: AppTheme.label(size: 11, color: AppTheme.ink3).copyWith(letterSpacing: 1.2),
  );
}
