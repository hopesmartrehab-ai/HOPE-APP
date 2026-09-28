import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/assessment/presentation/screens/assessment_connecting_screen.dart';
import 'package:hope_app/features/assessment/presentation/widgets/assessment_option_card.dart';

class AssessmentDeviceSelectionScreen extends StatefulWidget {
  const AssessmentDeviceSelectionScreen({super.key});

  @override
  State<AssessmentDeviceSelectionScreen> createState() =>
      _AssessmentDeviceSelectionScreenState();
}

class _AssessmentDeviceSelectionScreenState
    extends State<AssessmentDeviceSelectionScreen> {
  String selectedDevice = 'Smart Glove';

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
              Row(
                children: [
                  Text(
                    'ASSESSMENT SETUP',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your device\nfor the assessment',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              AssessmentOptionCard(
                icon: Icons.handshake_rounded,
                title: 'Use Smart Glove',
                subtitle:
                    'Connect your HOPE Smart Glove for precise movement tracking during the assessment.',
                selected: selectedDevice == 'Smart Glove',
                onTap: () => setState(() => selectedDevice = 'Smart Glove'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AssessmentConnectingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DBE7A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
