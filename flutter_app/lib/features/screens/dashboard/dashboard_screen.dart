import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../models/session.dart';
import '../../state/session_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/language_toggle.dart';

/// Whether the dashboard was opened from the patient flow or the practitioner
/// flow. Drives small surface tweaks (greeting + accent colour, mirroring the
/// role-selection cards) — the data shown is identical.
enum DashboardMode { patient, practitioner }

const _categories = ['Reach', 'Grasp', 'Manipulation', 'Release'];

class DashboardScreen extends StatefulWidget {
  final DashboardMode mode;
  const DashboardScreen({super.key, required this.mode});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SessionProvider>().loadSessionHistory();
      if (mounted) setState(() => _loaded = true);
    });
  }

  // Patient and practitioner share the same brand palette as the role-select
  // cards: teal for patient, navy for doctor. (See role_selection_screen.dart.)
  Color get _accent => widget.mode == DashboardMode.practitioner
      ? HopeColors.navy
      : HopeColors.teal;

  String _greeting(AppLocalizations t) =>
      widget.mode == DashboardMode.practitioner
          ? t.dashboardWelcomeDoctor
          : t.dashboardWelcomePatient;

  /// Walk the session history (oldest → newest) and pull out the
  /// (sessionIndex, score) pairs for one exercise category.
  ///
  /// `sessionIndex` is 1-based across ALL sessions in the history so the
  /// x-axis on each chart aligns with "session N" in real time. A category
  /// with sparse data ends up as a sparse line, which is intentional — the
  /// gaps show that the user wasn't prescribed that exercise on that visit.
  List<FlSpot> _spotsFor(String category, List<SessionSummary> ordered) {
    final spots = <FlSpot>[];
    for (var i = 0; i < ordered.length; i++) {
      final s = ordered[i];
      if (s.exerciseName == category && s.exerciseOverallPercent != null) {
        spots.add(FlSpot((i + 1).toDouble(), s.exerciseOverallPercent!));
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final t = AppLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.errorMessage != null) {
        showSessionError(context, provider.errorMessage);
        provider.clearError();
      }
    });

    // Sort oldest → newest so session index reads naturally left-to-right.
    final history = [...provider.sessionHistory]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final maxX = history.length.toDouble();
    final hasAnyData = history.any(
      (s) => s.exerciseName != null && s.exerciseOverallPercent != null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.dashboard),
        actions: const [LanguageToggle()],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  context.read<SessionProvider>().loadSessionHistory(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _GreetingHeader(
                    greeting: _greeting(t),
                    subtitle: t.dashboardSubtitle,
                    accent: _accent,
                    icon: widget.mode == DashboardMode.practitioner
                        ? Icons.medical_services
                        : Icons.personal_injury,
                  ),
                  const SizedBox(height: 20),
                  if (!hasAnyData)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        t.dashboardEmpty,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: HopeColors.muted),
                      ),
                    )
                  else
                    ..._categories.map(
                      (cat) => _CategoryChartCard(
                        category: cat,
                        spots: _spotsFor(cat, history),
                        maxX: maxX,
                        accent: _accent,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;
  final Color accent;
  final IconData icon;

  const _GreetingHeader({
    required this.greeting,
    required this.subtitle,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Mirrors the look of the role-select cards: tinted circular avatar with a
    // role icon, brand-colored title, muted subtitle. Keeps the dashboard
    // visually anchored to the rest of the app.
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: accent.withValues(alpha: 0.15),
          child: Icon(icon, color: accent, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: HopeColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChartCard extends StatelessWidget {
  final String category;
  final List<FlSpot> spots;
  final double maxX;
  final Color accent;

  const _CategoryChartCard({
    required this.category,
    required this.spots,
    required this.maxX,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HopeColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: spots.isEmpty
                  ? Center(
                      child: Text(
                        t.dashboardEmptyForCategory,
                        style: const TextStyle(color: HopeColors.muted),
                      ),
                    )
                  : LineChart(_chartData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: 1,
      maxX: maxX < 1 ? 1 : maxX,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: HopeColors.muted.withValues(alpha: 0.15),
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 25,
            getTitlesWidget: (v, _) => Text(
              v.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: HopeColors.muted),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: _bottomInterval(),
            getTitlesWidget: (v, _) {
              if (v != v.roundToDouble()) return const SizedBox.shrink();
              return Text(
                v.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: HopeColors.muted),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: accent,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
              radius: 4,
              color: accent,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: accent.withValues(alpha: 0.10),
          ),
        ),
      ],
    );
  }

  double _bottomInterval() {
    if (maxX <= 6) return 1;
    if (maxX <= 20) return 2;
    return (maxX / 10).ceilToDouble();
  }
}
