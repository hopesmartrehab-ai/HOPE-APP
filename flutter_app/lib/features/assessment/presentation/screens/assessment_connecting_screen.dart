import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/assessment/presentation/screens/assessment_planet_flow_screen.dart';

class AssessmentConnectingScreen extends StatefulWidget {
  const AssessmentConnectingScreen({super.key});

  @override
  State<AssessmentConnectingScreen> createState() =>
      _AssessmentConnectingScreenState();
}

class _AssessmentConnectingScreenState
    extends State<AssessmentConnectingScreen> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => isConnected = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                'SMART GLOVE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isConnected
                    ? 'Smart Glove Connected'
                    : 'Connecting to Smart Glove',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F0EB),
                    borderRadius: BorderRadius.circular(110),
                    boxShadow: isConnected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF5DBE7A,
                              ).withValues(alpha: 0.18),
                              blurRadius: 28,
                              spreadRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFF5DBE7A)
                            : const Color(0xFF152B3D),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(
                          isConnected
                              ? Icons.check_rounded
                              : Icons.smart_toy_rounded,
                          color: Colors.white,
                          size: 62,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDCE7F0)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isConnected
                          ? Icons.check_circle_rounded
                          : Icons.sync_rounded,
                      color: isConnected
                          ? const Color(0xFF2E7D32)
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isConnected
                            ? 'HOPE Smart Glove connected'
                            : 'Connecting...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isConnected
                              ? const Color(0xFF2E7D32)
                              : AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isConnected)
                      Text(
                        '100%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index < (isConnected ? 5 : 3)
                          ? const Color(0xFF5DBE7A)
                          : const Color(0xFFD8E1EA),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: Color(0xFFDCE7F0)),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isConnected
                          ? () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AssessmentPlanetFlowScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DBE7A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isConnected ? 'Continue' : 'Connecting...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
