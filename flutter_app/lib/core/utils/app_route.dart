import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tara_car/core/di/service_locator.dart';
import 'package:tara_car/core/enums/app_flow.dart';
import 'package:tara_car/feature/auth/data/forget_password/logic/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:tara_car/feature/auth/data/login/login_cubit/login_cubit.dart';
import 'package:tara_car/feature/auth/data/register/logic/register_cubit/register_cubit.dart';
import 'package:tara_car/feature/auth/data/register/logic/verify_cubit/verify_cubit.dart';
import 'package:tara_car/feature/auth/presentation/forget_password/pages/create_new_password.dart';
import 'package:tara_car/feature/auth/presentation/forget_password/pages/forget_password_screen.dart';
import 'package:tara_car/feature/auth/presentation/forget_password/pages/password_updated.dart';
import 'package:tara_car/feature/auth/presentation/forget_password/pages/verify_forgot_password_screen.dart';
import 'package:tara_car/feature/auth/presentation/login/pages/login_screen.dart';
import 'package:tara_car/feature/auth/presentation/register/pages/register_screen.dart';
import 'package:tara_car/feature/auth/presentation/shared_widgets/verify_number_screen.dart';
import 'package:tara_car/feature/compare_car/presentation/pages/compare_result.dart';
import 'package:tara_car/feature/error/maintenance_screen.dart';
import 'package:tara_car/feature/error/no_internet_connection_screen.dart';
import 'package:tara_car/feature/error/something_went_wrong_screen.dart';
import 'package:tara_car/feature/more/data/account/delete_account/logic/delete_account_cubit/delete_account_cubit.dart';
import 'package:tara_car/feature/more/data/account/my_account/logic/my_account_cubit/my_account_cubit.dart';
import 'package:tara_car/feature/more/data/settings/settings/logic/settings_cubit/settings_cubit.dart';
import 'package:tara_car/feature/more/data/support/faqs/logic/faqs_cubit/faqs_cubit.dart';
import 'package:tara_car/feature/more/data/support/privacy_policy/logic/privacy_policy_cubit/privacy_policy_cubit.dart';
import 'package:tara_car/feature/more/data/support/terms_and_conditions/logic/terms_and_conditions_cubit/terms_and_conditions_cubit.dart';
import 'package:tara_car/feature/more/presentation/pages/account/change_password_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/account/my_account_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/ads/my_ads_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/provider/provider_details_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/settings/settings_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/showroom/become_showroom_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/showroom/showrooms_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/support/contact_us_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/support/faqs_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/support/privacy_policy_screen.dart';
import 'package:tara_car/feature/more/presentation/pages/support/terms_and_conditions_screen.dart';
import 'package:tara_car/feature/more/presentation/widgets/showroom/success_screen.dart';
import 'package:tara_car/feature/nav_bar/presentation/pages/nav_bar.dart';
import 'package:tara_car/feature/notification/presentation/pages/notification_screen.dart';
import 'package:tara_car/feature/onboarding/data/onboarding_cubit/onboarding_cubit.dart';
import 'package:tara_car/feature/onboarding/presentation/pages/onbording.dart';
import 'package:tara_car/feature/post_ad/presentation/pages/ad_submitted_screen.dart';
import 'package:tara_car/feature/post_ad/presentation/pages/post_ad_screen_step_one.dart';
import 'package:tara_car/feature/search_module/advanced_search/presentation/pages/advanced_search_screen.dart';
import 'package:tara_car/feature/shared_screen/available_cars/pages/availabe_cars_screen.dart';
import 'package:tara_car/feature/shared_screen/available_cars/widgets/no_cars_available_screen.dart';
import 'package:tara_car/feature/shared_screen/filter/pages/filter_screen.dart';
import 'package:tara_car/feature/shared_screen/product_details/pages/product_details_screen.dart';
import 'package:tara_car/feature/shared_screen/select_brand/pages/select_brand_screen.dart';
import 'package:tara_car/feature/shared_screen/select_model/pages/select_model_screen.dart';

abstract class AppRoute {
  AppRoute._();

  static Widget onboardingScreen() {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>()..loadUserOnboarding(),
      child: const OnboardingView(),
    );
  }

  static void goToLoginScreen({required BuildContext context}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),
      (route) => false,
    );
  }

  static void goToNavBarScreen({required BuildContext context}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScaffold()),
      (route) => false,
    );
  }

  static void goToRegisterScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<RegisterCubit>(),
          child: const RegisterScreen(),
        ),
      ),
    );
  }

  static void goBack({required BuildContext context}) {
    Navigator.maybePop(context);
  }

  static void goToVerifyNumberScreen({
    required BuildContext context,
    required String fullName,
    required String phone,
    required String password,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<VerifyCubit>(),
          child: VerifyNumberScreen(
            fullName: fullName,
            phone: phone,
            password: password,
          ),
        ),
      ),
    );
  }

  static void goToVerifyNumberForgetPassword({
    required BuildContext context,
    required String phone,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ForgotPasswordCubit>(),
          child: VerifyForgotPasswordScreen(phone: phone),
        ),
      ),
    );
  }

  static void goToForgetPasswordScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ForgotPasswordCubit>(),
          child: const ForgetPasswordScreen(),
        ),
      ),
    );
  }

  static void goToCreateNewPasswordScreen({
    required BuildContext context,
    required String resetToken,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ForgotPasswordCubit>(),
          child: CreateNewPassword(resetToken: resetToken),
        ),
      ),
    );
  }

  static void goToUpdatedPassword({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordUpdated()),
    );
  }

  static void goToNotificationScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  }

  static void goToAdvancedSearchScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdvancedSearchScreen()),
    );
  }

  static void goToSelectBrandScreen({
    required BuildContext context,
    AppFlowTarget? target,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectBrandScreen(target: target),
      ),
    );
  }

  static void goToSelectModelScreen({
    required BuildContext context,
    AppFlowTarget? target,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectModelScreen(target: target),
      ),
    );
  }

  static void goToAvailableCarsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvailableCarsScreen()),
    );
  }

  static void goToFilterScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FilterScreen()),
    );
  }

  static void goToNoCarsAvailableScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoCarsAvailableScreen()),
    );
  }

  static void goToProductDetailsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductDetailsScreen()),
    );
  }

  static void goToMyAdsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyAdsScreen()),
    );
  }

  static void goToShowroomsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShowroomsScreen()),
    );
  }

  static void goToProviderDetailsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProviderDetailsScreen()),
    );
  }

  static void goToBecomeShowroomScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BecomeShowroomScreen()),
    );
  }

  static void goToSuccessScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessScreen()),
    );
  }

  static void goToMainScaffold({required BuildContext context}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScaffold()),
      (route) => false,
    );
  }

  static void goToMyAccountScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<MyAccountCubit>()),
            BlocProvider(create: (_) => getIt<DeleteAccountCubit>()),
          ],
          child: const MyAccountScreen(),
        ),
      ),
    );
  }

  static void goToSettingsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  static void goToChangePasswordScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  static void goToPrivacyPolicyScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<PrivacyPolicyCubit>()..getPrivacyPolicy(),
          child: const PrivacyPolicyScreen(),
        ),
      ),
    );
  }

  static void goToTermsAndConditionsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              getIt<TermsAndConditionsCubit>()..getTermsAndConditions(),
          child: const TermsAndConditionsScreen(),
        ),
      ),
    );
  }

  static void goToContactUsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<SettingsCubit>()..getSettings(),
          child: const ContactUsScreen(),
        ),
      ),
    );
  }

  static void goToFaqsScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<FaqsCubit>()..getFaqs(),
          child: const FaqsScreen(),
        ),
      ),
    );
  }

  static void goToPostAdScreenOne({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostAdScreenStepOne()),
    );
  }

  static void goTo({required BuildContext context, required Widget routeName}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => routeName));
  }

  static void goToAdSubmittedScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdSubmittedScreen()),
    );
  }

  static void goToCompareResultScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CompareResultView()),
    );
  }

  static void goToMaintenanceScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MaintenanceScreen()),
    );
  }

  static void goToNoInternetConnectionScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoInternetConnectionScreen(),
      ),
    );
  }

  static void goToSomethingWentWrongScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SomethingWentWrongScreen()),
    );
  }
}
