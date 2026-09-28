import 'package:flutter/material.dart';
import 'package:hope_app/features/game/assessment_game_web_view.dart';
import 'package:hope_app/features/start%20_session/presentation/connect_glove_screen/connect_glove_view.dart';
import 'package:hope_app/features/start%20_session/presentation/shared_widgets/shared_session_app_bar.dart';
import 'package:hope_app/features/start%20_session/presentation/shared_widgets/shared_session_bottom_bar.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';
import 'package:hope_app/features/start%20_session/presentation/training_format_screen/training_format_view.dart';
import 'package:hope_app/features/start%20_session/presentation/training_setup/training_setup_view.dart';

class StartSessionFlowScreen extends StatefulWidget {
  const StartSessionFlowScreen({
    this.initialPage = 0,
    this.initialApproach,
    this.initialFormat,
    this.isAssessmentMode = false,
    super.key,
  });

  final int initialPage;
  final TrainingApproach? initialApproach;
  final TrainingFormatType? initialFormat;
  final bool isAssessmentMode;

  @override
  State<StartSessionFlowScreen> createState() => _StartSessionFlowScreenState();
}

class _StartSessionFlowScreenState extends State<StartSessionFlowScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  TrainingApproach? selectedApproach;
  TrainingFormatType? selectedFormat;

  @override
  void initState() {
    super.initState();
    selectedApproach = widget.isAssessmentMode ? null : widget.initialApproach;
    selectedFormat = widget.initialFormat;

    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    if (_currentPage == 0) {
      return selectedApproach != null;
    }

    if (widget.isAssessmentMode) {
      return selectedApproach != null;
    }

    switch (_currentPage) {
      case 1:
        if (selectedApproach == TrainingApproach.mobileOnly) {
          return selectedFormat != null;
        }
        return selectedApproach == TrainingApproach.smartGlove;
      case 2:
        return selectedApproach == TrainingApproach.smartGlove &&
            selectedFormat != null;
      default:
        return false;
    }
  }

  void _handleBack() {
    if (_currentPage == 0) {
      Navigator.of(context).pop();
      return;
    }

    _pageController.animateToPage(
      _currentPage - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleContinue() {
    if (!_canContinue || selectedApproach == null) {
      return;
    }

    if (widget.isAssessmentMode && _currentPage == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AssessmentGameWebView()),
      );
      return;
    }

    if (_currentPage == 0) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[];

    pages.add(
      TrainingSetupView(
        selectedApproach: selectedApproach,
        onApproachSelected: (value) {
          setState(() {
            selectedApproach = value;
            selectedFormat = widget.isAssessmentMode
                ? TrainingFormatType.video
                : selectedFormat;
          });
        },
      ),
    );

    if (selectedApproach == TrainingApproach.smartGlove) {
      pages.add(
        ConnectGloveView(
          selectedApproach: selectedApproach!,
          onConnected: () {
            if (mounted) {
              _pageController.animateToPage(
                _currentPage + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      );
    }

    pages.add(
      TrainingFormatView(
        selectedApproach: selectedApproach ?? TrainingApproach.mobileOnly,
        selectedFormat: widget.isAssessmentMode
            ? TrainingFormatType.video
            : selectedFormat,
        showPlayGame: !widget.isAssessmentMode,
        onFormatSelected: (value) {
          setState(() {
            selectedFormat = widget.isAssessmentMode
                ? TrainingFormatType.video
                : value;
          });
        },
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: SharedSessionAppBar(
        currentPage: _currentPage,
        onBack: _handleBack,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: SharedSessionBottomBar(
        enabled: _canContinue,
        onPressed: _handleContinue,
      ),
    );
  }
}
