import 'package:connectivity_plus/connectivity_plus.dart';

/// Exposes the app's current network transport availability.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Checks whether the device currently has at least one network transport.
///
/// This intentionally uses the project's existing `connectivity_plus`
/// dependency. It reports network availability, not reachability of a
/// particular backend endpoint.
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl({required Connectivity connectivity})
    : _connectivity = connectivity;

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}
