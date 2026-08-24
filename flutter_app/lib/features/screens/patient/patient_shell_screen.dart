import 'package:flutter/material.dart';

import '../../../core/old_core/l10n/gen/app_localizations.dart';
import '../../../core/old_core/theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';
import 'session_start_screen.dart';

class PatientShellScreen extends StatefulWidget {
  const PatientShellScreen({super.key});

  @override
  State<PatientShellScreen> createState() => _PatientShellScreenState();
}

class _PatientShellScreenState extends State<PatientShellScreen> {
  int _currentIndex = 0;
  bool _snackbarShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_snackbarShown) {
      _snackbarShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final t = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.welcomeSnackbar),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SessionStartScreen(),
          DashboardScreen(mode: DashboardMode.patient),
          _HelpScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: HopeColors.teal.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: t.tabProgress,
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline),
            selectedIcon: const Icon(Icons.help),
            label: t.tabHelp,
          ),
        ],
      ),
    );
  }
}

class _HelpScreen extends StatelessWidget {
  const _HelpScreen();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.helpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Welcome banner ---
          Card(
            color: HopeColors.teal.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    size: 48,
                    color: HopeColors.teal,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.helpWelcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HopeColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.helpWelcomeDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: HopeColors.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- How to Use (dd2.jpeg) ---
          _SectionHeader(t.helpHowToUse),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/help/dd2.jpeg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),

          // --- Exercises Guide ---
          _SectionHeader(t.helpExercisesGuide),
          const SizedBox(height: 8),
          _ExerciseTile(
            icon: Icons.open_with,
            color: Colors.blue,
            title: t.helpReach,
            desc: t.helpReachDesc,
            tip: t.helpReachTip,
          ),
          _ExerciseTile(
            icon: Icons.back_hand,
            color: Colors.orange,
            title: t.helpGrasp,
            desc: t.helpGraspDesc,
            tip: t.helpGraspTip,
          ),
          _ExerciseTile(
            icon: Icons.precision_manufacturing,
            color: Colors.purple,
            title: t.helpManipulation,
            desc: t.helpManipulationDesc,
            tip: t.helpManipulationTip,
          ),
          _ExerciseTile(
            icon: Icons.pan_tool,
            color: Colors.green,
            title: t.helpRelease,
            desc: t.helpReleaseDesc,
            tip: t.helpReleaseTip,
          ),
          const SizedBox(height: 20),

          // --- Understanding Your Results ---
          _SectionHeader(t.helpResultsTitle),
          const SizedBox(height: 8),
          _ResultTile(
            Icons.check_circle,
            Colors.green,
            t.helpResultSuccess,
            t.helpResultSuccessDesc,
          ),
          _ResultTile(
            Icons.refresh,
            Colors.orange,
            t.helpResultTryAgain,
            t.helpResultTryAgainDesc,
          ),
          _ResultTile(
            Icons.fitness_center,
            Colors.red,
            t.helpResultLowForce,
            t.helpResultLowForceDesc,
          ),
          _ResultTile(
            Icons.speed,
            Colors.blue,
            t.helpResultSpeed,
            t.helpResultSpeedDesc,
          ),
          const SizedBox(height: 20),

          // --- Electrode Placement (dd1.jpeg) ---
          _SectionHeader(t.helpElectrodePlacement),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/help/dd1.jpeg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),

          // --- Troubleshooting ---
          _SectionHeader(t.helpTroubleshooting),
          const SizedBox(height: 8),
          _TroubleshootTile(
            t.helpTroubleNoResponse,
            t.helpTroubleNoResponseFix,
          ),
          _TroubleshootTile(t.helpTroubleNoData, t.helpTroubleNoDataFix),
          _TroubleshootTile(t.helpTroubleStrange, t.helpTroubleStrangeFix),
          const SizedBox(height: 20),

          // --- Safety Tips ---
          _SectionHeader(t.helpSafetyTitle),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SafetyRow(t.helpSafety1),
                  _SafetyRow(t.helpSafety2),
                  _SafetyRow(t.helpSafety3),
                  _SafetyRow(t.helpSafety4),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- About + Contact ---
          _SectionHeader(t.helpAbout),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.helpAboutDesc,
                    style: const TextStyle(
                      color: HopeColors.muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: HopeColors.teal,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t.helpTip,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: HopeColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 18,
                        color: HopeColors.muted,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'walidkenzy449@gmail.com',
                        style: TextStyle(color: HopeColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: HopeColors.muted,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '01090080277',
                        style: TextStyle(color: HopeColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: HopeColors.teal,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HopeColors.ink,
          ),
        ),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  final String tip;
  const _ExerciseTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: HopeColors.muted,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  const _ResultTile(this.icon, this.color, this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(desc, style: const TextStyle(color: HopeColors.muted)),
      ),
    );
  }
}

class _TroubleshootTile extends StatelessWidget {
  final String problem;
  final String fix;
  const _TroubleshootTile(this.problem, this.fix);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: const Icon(Icons.warning_amber, color: Colors.orange),
        title: Text(
          problem,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(fix, style: const TextStyle(color: HopeColors.muted)),
      ),
    );
  }
}

class _SafetyRow extends StatelessWidget {
  final String text;
  const _SafetyRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield, color: HopeColors.teal, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: HopeColors.ink, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
