abstract class WebConstant {
  static const String baseUrl = 'https://api.taracar.store/';
  static const String baseUrlDev = 'https://api.taracar.store/';
  static const bool isDev = true;

  /// Host of the HOPE assessment backend, which is separate from [baseUrl].
  /// Kept without a trailing slash: request paths are appended as `/api/...`.
  static const String hopeBaseUrl = 'https://hope-backend-exdk.onrender.com';

  /// Header carrying [hopePrototypeKey].
  static const String hopePrototypeKeyHeader = 'X-Prototype-Key';

  /// Shared key guarding the prototype assessment endpoints.
  ///
  /// TODO: this is a shared secret shipped inside the client. Acceptable for
  /// the prototype backend, but it must move behind a real auth flow (or at
  /// least a build-time injected value) before any production build.
  static const String hopePrototypeKey =
      'proto_230cfcc167dd5757af9fb2d509d7523bb7764ea3f5b2a7d0f15e2a0ceb63cb68';
}
