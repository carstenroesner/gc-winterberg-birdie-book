// Scorecard-Seite im Pager (letzte Seite: nach Loch 9 bei 9-Loch-Runde,
// nach Loch 18 bei 18-Loch-Runde). 1:1-Verhalten aus buildScorecardPage()
// in js/app.js: Vorne/Hinten-Umschalter nur bei hc>9, Score-Eingabe wird
// pro Runde persistiert, fehlende Referenzdaten zeigen "–".

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/course_data.dart';
import '../models/hole.dart';
import '../models/round.dart';
import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../services/weather_service.dart';
import '../theme/golf_palette.dart';

class ScorecardPage extends StatefulWidget {
  final int holeCount;

  const ScorecardPage({super.key, required this.holeCount});

  @override
  State<ScorecardPage> createState() => _ScorecardPageState();
}

class _ScorecardPageState extends State<ScorecardPage> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final rounds = context.watch<RoundsService>();
    final round = rounds.currentRound;
    final showToggle = widget.holeCount > 9;
    final isBack = showToggle && _showBack;

    final visibleHoles = holes.take(widget.holeCount < 9 ? widget.holeCount : 9);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GCWBB',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: GolfPalette.goldDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Text(locale.t('scorecardTitle'), style: Theme.of(context).textTheme.headlineSmall),
                Row(
                  children: [
                    Text(
                      round == null ? '–' : _fmtDate(round.date),
                      style: TextStyle(color: GolfPalette.inkSoft),
                    ),
                    if (round?.weatherCode != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        weatherIconFor(weatherCategoryForCode(round!.weatherCode!)),
                        size: 15,
                        color: GolfPalette.inkSoft,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${locale.t(weatherLabelKeyFor(weatherCategoryForCode(round.weatherCode!)))}'
                        ' · ${round.weatherTempC!.round()}\u00b0C',
                        style: TextStyle(color: GolfPalette.inkSoft),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (showToggle)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(locale.t('frontNine'))),
                  ButtonSegment(value: true, label: Text(locale.t('backNine'))),
                ],
                selected: {_showBack},
                onSelectionChanged: (selection) =>
                    setState(() => _showBack = selection.first),
              ),
            ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _HeaderRow(locale: locale),
                  for (final hole in visibleHoles)
                    _ScoreRow(
                      hole: hole,
                      isBack: isBack,
                      round: round,
                      onScoreChanged: (score) => rounds.setScore(
                        isBack: isBack,
                        n: hole.n,
                        score: score,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    locale.t('scoreNote'),
                    style: TextStyle(fontSize: 12, color: GolfPalette.inkFaint),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _HeaderRow extends StatelessWidget {
  final LocaleService locale;

  const _HeaderRow({required this.locale});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: GolfPalette.inkSoft,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(locale.t('hole'), style: style)),
          Expanded(flex: 2, child: Text(locale.t('par'), style: style)),
          Expanded(flex: 2, child: Text(locale.t('hcp'), style: style)),
          Expanded(flex: 3, child: Text(locale.t('herren'), style: style)),
          Expanded(flex: 3, child: Text(locale.t('damen'), style: style)),
          Expanded(flex: 3, child: Text(locale.t('score'), style: style)),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatefulWidget {
  final Hole hole;
  final bool isBack;
  final Round? round;
  final ValueChanged<int?> onScoreChanged;

  const _ScoreRow({
    required this.hole,
    required this.isBack,
    required this.round,
    required this.onScoreChanged,
  });

  @override
  State<_ScoreRow> createState() => _ScoreRowState();
}

class _ScoreRowState extends State<_ScoreRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _initialValue());
  }

  @override
  void didUpdateWidget(covariant _ScoreRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final v = _initialValue();
    if (_controller.text != v) _controller.text = v;
  }

  String _initialValue() {
    final round = widget.round;
    if (round == null) return '';
    final key = Round.scoreKey(isBack: widget.isBack, n: widget.hole.n);
    return round.scores[key]?.toString() ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sc = widget.hole.scorecard;
    final displayNum = widget.isBack ? widget.hole.n + 9 : widget.hole.n;
    final valueStyle = TextStyle(color: sc == null ? GolfPalette.inkFaint : GolfPalette.ink);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('$displayNum', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Expanded(
            flex: 2,
            child: Text(sc == null ? '–' : '${sc.par}', style: valueStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sc == null ? '–' : '${widget.isBack ? sc.hcp.back : sc.hcp.front}',
              style: valueStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sc == null ? '–' : '${widget.isBack ? sc.herren.back : sc.herren.front}',
              style: valueStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sc == null ? '–' : '${widget.isBack ? sc.damen.back : sc.damen.front}',
              style: valueStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(isDense: true, hintText: '–'),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                widget.onScoreChanged(value.isEmpty ? null : parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
