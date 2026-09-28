import 'package:flutter/material.dart';
import 'package:hope_app/features/assessment_result/presentation/assessment_report_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class AssessmentGameWebView extends StatefulWidget {
  const AssessmentGameWebView({super.key});

  @override
  State<AssessmentGameWebView> createState() => _AssessmentGameWebViewState();
}

class _AssessmentGameWebViewState extends State<AssessmentGameWebView> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _assessmentFinished = false;

  Widget? _fullscreenWidget;

  final String gameUrl = 'https://kenzywalid.itch.io/hope-planet';

  static const String _finishLogTrigger = 'Final session send succeeded';

  static const List<String> _noisy = [
    'bindTexture',
    'AudioContext',
    'Trying to get length of sound',
    'Trying to get metadata of sound',
    'memorysetup',
    'Unrecognized feature',
  ];

  static const String _layoutJs = '''
(function() {
  function fixGameLayout() {
    try {
      var header = document.querySelector('.header');
      if (header) header.style.display = 'none';

      document.documentElement.style.margin = '0';
      document.documentElement.style.padding = '0';
      document.body.style.margin = '0';
      document.body.style.padding = '0';
      document.body.style.overflow = 'hidden';
      document.body.style.background = '#1E3A53';

      var iframe = document.querySelector('iframe');
      if (iframe) {
        iframe.style.display = 'block';
        iframe.style.position = 'absolute';
        iframe.style.left = '0';
        iframe.style.top = '0';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.margin = '0';
        iframe.style.padding = '0';
        iframe.style.border = '0';
        iframe.style.maxWidth = 'none';
        iframe.style.maxHeight = 'none';
        iframe.style.transform = 'none';
      }

      var containers = document.querySelectorAll(
        '.game_page, .game_frame, .iframe_wrap, .embed'
      );
      containers.forEach(function(el) {
        el.style.margin = '0';
        el.style.padding = '0';
        el.style.width = '100%';
        el.style.height = '100%';
      });
    } catch (error) {
      console.log("Game layout error: " + error);
    }
  }

  fixGameLayout();
  [300, 800, 1500, 3000].forEach(function(t) {
    setTimeout(fixGameLayout, t);
  });
})();
''';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1E3A53))
      // ==========================================
      ..setOnConsoleMessage((JavaScriptConsoleMessage msg) {
        final text = msg.message;

        if (!_noisy.any(text.contains)) {
          debugPrint('🖥️ CONSOLE: ${text.trim()}');
        }

        if (text.contains(_finishLogTrigger)) {
          _navigateToResults();
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('🌐 Page started: $url');
            if (mounted) setState(() => _isLoading = true);
          },

          onPageFinished: (String url) async {
            debugPrint('✅ Page finished: $url');
            if (mounted) setState(() => _isLoading = false);

            await Future.delayed(const Duration(milliseconds: 300));
            await _runJs(_layoutJs);
          },

          onNavigationRequest: (NavigationRequest request) {
            debugPrint('➡️ Navigation: ${request.url}');

            if (request.url.startsWith('https://kenzywalid.itch.io') ||
                request.url.startsWith('https://html-classic.itch.zone') ||
                request.url.startsWith('https://img.itch.zone') ||
                request.url.startsWith('about:') ||
                request.url.startsWith('blob:') ||
                request.url.startsWith('data:')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(gameUrl));

    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setCustomWidgetCallbacks(
        onShowCustomWidget:
            (Widget widget, OnHideCustomWidgetCallback onHidden) {
              debugPrint('📺 Fullscreen requested -> showing inside body');
              if (mounted) setState(() => _fullscreenWidget = widget);
            },
        onHideCustomWidget: () {
          debugPrint('📺 Fullscreen hidden');
          if (mounted) setState(() => _fullscreenWidget = null);
        },
      );
    }
  }

  Future<void> _runJs(String code) async {
    try {
      await _controller.runJavaScript(code);
    } catch (e) {
      debugPrint('❌ JS error: $e');
    }
  }

  Future<void> _navigateToResults() async {
    if (!mounted || _assessmentFinished) return;
    _assessmentFinished = true;

    debugPrint('🎉 Assessment finished -> navigating to results');

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AssessmentReportPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A53),
      appBar: AppBar(
        title: const Text(
          'HOPE Planet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A53),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: _controller)),

          if (_fullscreenWidget != null)
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF1E3A53),
                child: _fullscreenWidget!,
              ),
            ),

          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1E3A53),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF59C583),
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
