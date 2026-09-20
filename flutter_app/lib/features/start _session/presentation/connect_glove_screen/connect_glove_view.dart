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
          Center(
            child: Text(
              LocaleKeys.connecting.tr(),
              style: Styles.s14(context).copyWith(color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
