import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/session_provider.dart';
import '../../widgets/language_toggle.dart';
import 'exercise_waiting_screen.dart';

enum _AnswerKind { hours, tempC, bloodSugar, bloodPressure, painScale, yesNo }

class _Question {
  final String key;
  final String asset;
  final String Function(AppLocalizations) prompt;
  final _AnswerKind kind;
  const _Question(this.key, this.asset, this.prompt, this.kind);
}

final List<_Question> _questions = [
  _Question('sleep_hours', 'assets/questionnaire/sleep.jpeg',
      (t) => t.qSleep, _AnswerKind.hours),
  _Question('body_temperature', 'assets/questionnaire/temperature.jpeg',
      (t) => t.qTemperature, _AnswerKind.tempC),
  _Question('blood_sugar', 'assets/questionnaire/blood_sugar.jpeg',
      (t) => t.qBloodSugar, _AnswerKind.bloodSugar),
  _Question('blood_pressure', 'assets/questionnaire/blood_pressure.jpeg',
      (t) => t.qBloodPressure, _AnswerKind.bloodPressure),
  _Question('headache', 'assets/questionnaire/headache.jpeg',
      (t) => t.qHeadache, _AnswerKind.yesNo),
  _Question('dizzy', 'assets/questionnaire/dizzy.jpeg',
      (t) => t.qDizzy, _AnswerKind.yesNo),
  _Question('fatigue', 'assets/questionnaire/fatigue.jpeg',
      (t) => t.qFatigue, _AnswerKind.yesNo),
  _Question('arm_pain', 'assets/questionnaire/arm_pain.jpeg',
      (t) => t.qArmPain, _AnswerKind.painScale),
  _Question('hand_movement', 'assets/questionnaire/hand_movement.jpeg',
      (t) => t.qHandMovement, _AnswerKind.yesNo),
  _Question('falls_injuries', 'assets/questionnaire/falls.jpeg',
      (t) => t.qFalls, _AnswerKind.yesNo),
];

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _index = 0;
  final Map<String, dynamic> _answers = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    final q = _questions[_index];
    final a = _answers[q.key];
    if (a == null) return false;
    if (q.kind == _AnswerKind.bloodPressure) {
      return a is Map && a['systolic'] != null && a['diastolic'] != null;
    }
    return true;
  }

  void _next() {
    if (_index < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    if (_index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _submit() async {
    await context.read<SessionProvider>().submitQuestionnaire(Map.from(_answers));
    if (mounted) _navigateToExercise();
  }

  void _skip() {
    context.read<SessionProvider>().skipQuestionnaire();
    _navigateToExercise();
  }

  void _navigateToExercise() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ExerciseWaitingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final total = _questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.dailyCheckin),
        actions: [
          TextButton(
            onPressed: _skip,
            child: Text(
              t.skip,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const LanguageToggle(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.questionProgress(_index + 1, total),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / total,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (ctx, i) => _QuestionPage(
                question: _questions[i],
                value: _answers[_questions[i].key],
                onChanged: (v) => setState(() => _answers[_questions[i].key] = v),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _back,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(t.back),
                      ),
                    ),
                  if (_index > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _canAdvance ? _next : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _index == total - 1 ? t.submit : t.next,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  final _Question question;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;
  const _QuestionPage({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(question.asset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            question.prompt(t),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          _InputForKind(
            kind: question.kind,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _InputForKind extends StatelessWidget {
  final _AnswerKind kind;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;
  const _InputForKind({
    required this.kind,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    switch (kind) {
      case _AnswerKind.yesNo:
        return _YesNoInput(value: value as bool?, onChanged: onChanged);
      case _AnswerKind.hours:
        return _NumberSlider(
          value: (value as num?)?.toDouble() ?? 7,
          min: 0,
          max: 14,
          divisions: 28,
          unit: t.hoursUnit,
          fractionDigits: 1,
          onChanged: onChanged,
          initIfNull: true,
        );
      case _AnswerKind.tempC:
        return _NumberSlider(
          value: (value as num?)?.toDouble() ?? 37.0,
          min: 34,
          max: 42,
          divisions: 80,
          unit: t.celsiusUnit,
          fractionDigits: 1,
          onChanged: onChanged,
          initIfNull: true,
        );
      case _AnswerKind.bloodSugar:
        return _NumberSlider(
          value: (value as num?)?.toDouble() ?? 100,
          min: 40,
          max: 400,
          divisions: 72,
          unit: t.mgdlUnit,
          fractionDigits: 0,
          onChanged: onChanged,
          initIfNull: true,
        );
      case _AnswerKind.painScale:
        return _NumberSlider(
          value: (value as num?)?.toDouble() ?? 0,
          min: 0,
          max: 10,
          divisions: 10,
          unit: '',
          fractionDigits: 0,
          onChanged: onChanged,
          initIfNull: true,
        );
      case _AnswerKind.bloodPressure:
        return _BloodPressureInput(
          value: value as Map?,
          onChanged: onChanged,
        );
    }
  }
}

class _YesNoInput extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool> onChanged;
  const _YesNoInput({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: t.yes,
            icon: Icons.check_circle_outline,
            selected: value == true,
            color: Colors.teal,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ChoiceButton(
            label: t.no,
            icon: Icons.cancel_outlined,
            selected: value == false,
            color: Colors.redAccent,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _ChoiceButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: selected ? color : Colors.grey),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final int fractionDigits;
  final ValueChanged<num> onChanged;
  final bool initIfNull;
  const _NumberSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.fractionDigits,
    required this.onChanged,
    required this.initIfNull,
  });

  @override
  State<_NumberSlider> createState() => _NumberSliderState();
}

class _NumberSliderState extends State<_NumberSlider> {
  @override
  void initState() {
    super.initState();
    if (widget.initIfNull) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(_rounded(widget.value));
      });
    }
  }

  num _rounded(double v) => widget.fractionDigits == 0
      ? v.round()
      : double.parse(v.toStringAsFixed(widget.fractionDigits));

  @override
  Widget build(BuildContext context) {
    final display = widget.fractionDigits == 0
        ? widget.value.round().toString()
        : widget.value.toStringAsFixed(widget.fractionDigits);
    return Column(
      children: [
        Text(
          widget.unit.isEmpty ? display : '$display ${widget.unit}',
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        Slider(
          value: widget.value.clamp(widget.min, widget.max),
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: (v) => widget.onChanged(_rounded(v)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.min.toStringAsFixed(widget.fractionDigits),
                style: const TextStyle(color: Colors.grey)),
            Text(widget.max.toStringAsFixed(widget.fractionDigits),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _BloodPressureInput extends StatefulWidget {
  final Map? value;
  final ValueChanged<Map<String, int>> onChanged;
  const _BloodPressureInput({required this.value, required this.onChanged});

  @override
  State<_BloodPressureInput> createState() => _BloodPressureInputState();
}

class _BloodPressureInputState extends State<_BloodPressureInput> {
  late final TextEditingController _sys;
  late final TextEditingController _dia;

  @override
  void initState() {
    super.initState();
    _sys = TextEditingController(text: widget.value?['systolic']?.toString() ?? '');
    _dia = TextEditingController(text: widget.value?['diastolic']?.toString() ?? '');
  }

  @override
  void dispose() {
    _sys.dispose();
    _dia.dispose();
    super.dispose();
  }

  void _emit() {
    final s = int.tryParse(_sys.text);
    final d = int.tryParse(_dia.text);
    if (s != null && d != null) {
      widget.onChanged({'systolic': s, 'diastolic': d});
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _sys,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: t.systolic,
              border: const OutlineInputBorder(),
              hintText: '120',
            ),
            onChanged: (_) => _emit(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('/', style: TextStyle(fontSize: 28)),
        ),
        Expanded(
          child: TextField(
            controller: _dia,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: t.diastolic,
              border: const OutlineInputBorder(),
              hintText: '80',
            ),
            onChanged: (_) => _emit(),
          ),
        ),
      ],
    );
  }
}
