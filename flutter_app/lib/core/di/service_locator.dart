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
}

/// Resolves the HTTP service only after [setupServiceLocator] has registered it.
///
/// This must stay a getter instead of a top-level `final`: top-level variables
/// are evaluated while this library is imported, before `main()` can call
/// [setupServiceLocator]. Resolving it eagerly prevents Flutter from reaching
/// `runApp()` and leaves the Android launch splash on screen.
ApiService get apiService => getIt<ApiService>();
