import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';
import 'session_list_screen.dart';

class PractitionerShellScreen extends StatefulWidget {
  const PractitionerShellScreen({super.key});

  @override
  State<PractitionerShellScreen> createState() => _PractitionerShellScreenState();
}

class _PractitionerShellScreenState extends State<PractitionerShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SessionListScreen(),
          DashboardScreen(mode: DashboardMode.practitioner),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: HopeColors.navy.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: t.tabSessions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: t.tabDashboard,
          ),
        ],
      ),
    );
  }
}
