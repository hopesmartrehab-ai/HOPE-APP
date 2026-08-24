import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../connection/network_info.dart';
import '../network_services/api_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(ApiService());

  getIt.registerLazySingleton<Connectivity>(Connectivity.new);
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: getIt()),
  );

  getIt.registerLazySingleton<OnboardingRepo>(
    () => OnboardingRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(onboardingRepo: getIt.get<OnboardingRepo>()),
  );

  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepoImpl(networkInfo: getIt()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerRepo: getIt()),
  );
  getIt.registerFactory<VerifyCubit>(() => VerifyCubit(registerRepo: getIt()));

  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit(loginRepo: getIt()));

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(forgotPasswordRepo: getIt()),
  );

  getIt.registerLazySingleton<MyAccountLocalDataSource>(
    () => MyAccountLocalDataSource(),
  );

  getIt.registerLazySingleton<MyAccountRepo>(
    () => MyAccountRepoImpl(networkInfo: getIt(), localDataSource: getIt()),
  );

  getIt.registerFactory<MyAccountCubit>(
    () => MyAccountCubit(myAccountRepo: getIt()),
  );
  getIt.registerLazySingleton<DeleteAccountRepo>(
    () => DeleteAccountRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<DeleteAccountCubit>(
    () => DeleteAccountCubit(deleteAccountRepo: getIt()),
  );

  getIt.registerLazySingleton<FaqsRepo>(
    () => FaqsRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<FaqsCubit>(() => FaqsCubit(faqsRepo: getIt()));

  getIt.registerLazySingleton<PrivacyPolicyRepo>(
    () => PrivacyPolicyRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<PrivacyPolicyCubit>(
    () => PrivacyPolicyCubit(privacyPolicyRepo: getIt()),
  );

  getIt.registerLazySingleton<TermsAndConditionsRepo>(
    () => TermsAndConditionsRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<TermsAndConditionsCubit>(
    () => TermsAndConditionsCubit(termsAndConditionsRepo: getIt()),
  );

  getIt.registerLazySingleton<SettingsRepo>(
    () => SettingsRepoImpl(networkInfo: getIt()),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(settingsRepo: getIt()),
  );
  getIt.registerLazySingleton<HomeSliderRepo>(
    () => HomeSliderRepoImpl(networkInfo: getIt()),
  );
  getIt.registerFactory<HomeSliderBloc>(
    () => HomeSliderBloc(homeSliderRepo: getIt()),
  );
}

/// Resolves the HTTP service only after [setupServiceLocator] has registered it.
///
/// This must stay a getter instead of a top-level `final`: top-level variables
/// are evaluated while this library is imported, before `main()` can call
/// [setupServiceLocator]. Resolving it eagerly prevents Flutter from reaching
/// `runApp()` and leaves the Android launch splash on screen.
ApiService get apiService => getIt<ApiService>();
