import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/start%20_session/presentation/connect_glove_screen/widgets/connect_glove_header.dart';
import 'package:hope_app/features/start%20_session/presentation/connect_glove_screen/widgets/connection_ripple_view.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class ConnectGloveView extends StatefulWidget {
  const ConnectGloveView({
    required this.selectedApproach,
    required this.onConnected,
    super.key,
  });

  final TrainingApproach selectedApproach;
  final VoidCallback onConnected;

  @override
  State<ConnectGloveView> createState() => _ConnectGloveViewState();
}

class _ConnectGloveViewState extends State<ConnectGloveView> {
  @override
  void initState() {
    super.initState();
    _simulateConnection();
  }

  void _simulateConnection() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      widget.onConnected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ConnectGloveHeader(),
          const Expanded(child: Center(child: ConnectionRippleView())),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4EA).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  LocaleKeys.connecting.tr(),
                  style: Styles.s14(
                    context,
                  ).copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
