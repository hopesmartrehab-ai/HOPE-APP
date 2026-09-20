import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/clicked_widget.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/core/utils/app_route.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_footer.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_header.dart';
import 'package:hope_app/features/auth/shared_auth_widget/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController(text: 'Sarah Johnson');
  final _emailController = TextEditingController(text: 'sarah@example.com');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                title: LocaleKeys.createAccount.tr(),
                subtitle: LocaleKeys.signUpSubtitle.tr(),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTextField(
                      controller: _nameController,
                      label: LocaleKeys.fullName.tr(),
                      hintText: LocaleKeys.fullName.tr(),
                    ),
                    const SizedBox(height: 16),
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
                      hintText: LocaleKeys.passwordHint.tr(),
                      obscureText: true,
                      helperText: LocaleKeys.passwordHelper.tr(),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: LocaleKeys.confirmPassword.tr(),
                      hintText: LocaleKeys.repeatPassword.tr(),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClickedWidget(
                          onTap: () {
                            setState(() => _agreeToTerms = !_agreeToTerms);
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _agreeToTerms
                                  ? AppColors.onboardingPrimary
                                  : AppColors.scaffoldBg,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _agreeToTerms
                                    ? AppColors.onboardingPrimary
                                    : AppColors.onboardingBorder,
                              ),
                            ),
                            child: _agreeToTerms
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: AppColors.scaffoldBg,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: LocaleKeys.agreeToHopePrefix.tr(),
                              children: [
                                TextSpan(
                                  text: LocaleKeys.welcomeTermsService.tr(),
                                  style: const TextStyle(
                                    color: AppColors.onboardingLink,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: LocaleKeys.healthDataConsent.tr(),
                                ),
                              ],
                            ),
                            style: Styles.s12(context).copyWith(
                              color: AppColors.onboardingSecondary,
                              height: 1.63,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      title: LocaleKeys.createAccount.tr(),
                      isLoading: false,
                      backgroundColor: AppColors.onboardingStart,
                      borderRadius: 16,
                      height: 56,
                      onPressed: () =>
                          AppRoute.goToMainNavigation(context: context),
                      style: Styles.s16(context),
                    ),
                    const SizedBox(height: 16),
                    AuthFooter(
                      text: LocaleKeys.alreadyHaveAccount.tr(),
                      actionText: LocaleKeys.login.tr(),
                      onTap: () => AppRoute.goToSignIn(context: context),
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
