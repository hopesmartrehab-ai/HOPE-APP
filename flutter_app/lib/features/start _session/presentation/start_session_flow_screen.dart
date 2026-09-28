import 'package:flutter/material.dart';
import 'package:hope_app/features/assessment/presentation/screens/assessment_planet_flow_screen.dart';
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

  int _normalizedPageIndex(int page) {
    return page;
  }

  @override
  void initState() {
    super.initState();
    selectedApproach =
        widget.initialApproach ??
        (widget.isAssessmentMode ? TrainingApproach.smartGlove : null);
    selectedFormat =
        widget.initialFormat ??
        (widget.isAssessmentMode ? TrainingFormatType.video : null);
    _currentPage = _normalizedPageIndex(widget.initialPage);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    switch (_currentPage) {
      case 0:
        return selectedApproach != null;
      case 1:
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
    if (!_canContinue) {
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

    if (_currentPage == 2 && selectedFormat != null) {
      if (widget.isAssessmentMode) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AssessmentPlanetFlowScreen()),
        );
        return;
      }

      // Standard training flow can continue here if needed.
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
            if (widget.isAssessmentMode) {
              selectedApproach = TrainingApproach.smartGlove;
            }
            selectedFormat = widget.isAssessmentMode
                ? TrainingFormatType.video
                : null;

            if (widget.isAssessmentMode) {
              _currentPage = 0;
              _pageController.jumpToPage(0);
              return;
            }

            if (value == TrainingApproach.smartGlove && _currentPage > 1) {
              _currentPage = 1;
              _pageController.jumpToPage(1);
            }
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
                2,
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
        selectedApproach: selectedApproach ?? TrainingApproach.smartGlove,
        selectedFormat: widget.isAssessmentMode
            ? TrainingFormatType.video
            : selectedFormat,
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
        onPageChanged: (index) {
          setState(() {
            _currentPage = _normalizedPageIndex(index);
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
