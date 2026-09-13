import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/core/utils/app_route.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_demo_tip.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_footer.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_header.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: LocaleKeys.welcomeBack.tr(),
                subtitle: LocaleKeys.signInSubtitle.tr(),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: LocaleKeys.emailAddress.tr(),
                      hintText: LocaleKeys.emailHint.tr(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: LocaleKeys.password.tr(),
                      obscureText: true,
                      trailingLabel: LocaleKeys.forgotPasswordQuestion.tr(),
                      onTrailingTap: () {},
                    ),
                    const SizedBox(height: 32),
                    AuthDemoTip(
                      title: LocaleKeys.demoTip.tr(),
                      description: LocaleKeys.demoTipDescription.tr(),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      title: LocaleKeys.login.tr(),
                      isLoading: false,
                      backgroundColor: AppColors.onboardingStart,
                      borderRadius: 16,
                      height: 56,
                      onPressed: () {},
                      style: Styles.s16(context),
                    ),
                    const SizedBox(height: 16),
                    AuthFooter(
                      text: LocaleKeys.dontHaveAccount.tr(),
                      actionText: LocaleKeys.createAccount.tr(),
                      onTap: () => AppRoute.goToSignUp(context: context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
