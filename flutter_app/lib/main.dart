import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_localization.dart';
import 'core/old_core/debug/debug_log_store.dart';
import 'core/old_core/debug/debug_overlay.dart';
import 'core/old_core/theme/app_theme.dart';
import 'features/screens/welcome_screen.dart';
import 'features/state/session_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: HopeColors.offWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar', 'en');

  final logStore = DebugLogStore();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppLocalizations.englishLocale,
        AppLocalizations.arabicLocale,
      ],
      path: AppLocalizations.translationsPath,
      fallbackLocale: AppLocalizations.englishLocale,
      startLocale: AppLocalizations.englishLocale,
      useOnlyLangCode: true,
      saveLocale: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<DebugLogStore>.value(value: logStore),
          ChangeNotifierProvider<SessionProvider>(
            create: (_) => SessionProvider(logStore: logStore),
          ),
        ],
        child: const HopeApp(),
      ),
    ),
  );
}

class HopeApp extends StatelessWidget {
  const HopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildHopeTheme(),
      themeMode: ThemeMode.light,

      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      home: const DebugOverlay(child: WelcomeScreen()),
    );
  }
}
