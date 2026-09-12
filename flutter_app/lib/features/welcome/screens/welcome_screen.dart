import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/welcome/widgets/welcome_actions.dart';
import 'package:hope_app/features/welcome/widgets/welcome_header_section.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: 64),
                  WelcomeHeaderSection(),
                  SizedBox(height: 64),
                  WelcomeActions(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
