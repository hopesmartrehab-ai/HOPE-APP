import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class ConnectionRippleView extends StatelessWidget {
  const ConnectionRippleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الدوائر الخلفية باستخدام دالة مساعدة لمنع التكرار
        _buildCircle(size: 300, opacity: 0.1),
        _buildCircle(size: 220, opacity: 0.2),
        _buildCircle(size: 140, opacity: 0.3),

        // مربع القفاز في المنتصف
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Center(
            child: Text('🧤', style: TextStyle(fontSize: 40)),
          ),
        ),

        // مستطيل جارِ الاتصال (Connecting)
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Container(
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
        ),
      ],
    );
  }

  // دالة مساعدة لرسم الدوائر بأحجام وشفافية مختلفة
  Widget _buildCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withValues(alpha: opacity),
          width: 1,
        ),
      ),
    );
  }
}
