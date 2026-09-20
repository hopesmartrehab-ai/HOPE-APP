import 'package:flutter/material.dart';
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
    super.key,
  });

  final int initialPage;
  final TrainingApproach? initialApproach;
  final TrainingFormatType? initialFormat;

  @override
  State<StartSessionFlowScreen> createState() => _StartSessionFlowScreenState();
}

class _StartSessionFlowScreenState extends State<StartSessionFlowScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  TrainingApproach? selectedApproach;
  TrainingFormatType? selectedFormat;

  int _normalizedPageIndex(int page) {
    if (selectedApproach == TrainingApproach.mobileOnly && page > 1) {
      return 1;
    }
    return page;
  }

  @override
  void initState() {
    super.initState();
    selectedApproach = widget.initialApproach;
    selectedFormat = widget.initialFormat;
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
        if (selectedApproach == TrainingApproach.mobileOnly) {
          return selectedFormat != null;
        }
        return false;
      case 2:
        return selectedApproach == TrainingApproach.smartGlove &&
            selectedFormat != null;
      default:
        return false;
    }
  }

  int get _formatPageIndex {
    return selectedApproach == TrainingApproach.smartGlove ? 2 : 1;
  }

  void _handleBack() {
    if (_currentPage == 0) {
      Navigator.of(context).pop();
      return;
    }

    final targetPage =
        selectedApproach == TrainingApproach.mobileOnly && _currentPage == 1
        ? 0
        : _currentPage - 1;

    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleContinue() {
    if (!_canContinue) {
      return;
    }

    if (_currentPage == 0) {
      final nextPage = selectedApproach == TrainingApproach.smartGlove
          ? 1
          : _formatPageIndex;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (_currentPage == _formatPageIndex && selectedFormat != null) {
      // Hook for next screen navigation if needed.
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
            selectedFormat = null;

            if (value == TrainingApproach.mobileOnly) {
              _currentPage = 0;
              _pageController.jumpToPage(0);
            } else if (value == TrainingApproach.smartGlove &&
                _currentPage > 1) {
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
        selectedFormat: selectedFormat,
        onFormatSelected: (value) {
          setState(() {
            selectedFormat = value;
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
