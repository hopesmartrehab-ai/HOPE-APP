import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'debug/debug_log_store.dart';
import 'debug/debug_overlay.dart';
import 'l10n/gen/app_localizations.dart';
import 'state/locale_provider.dart';
import 'state/session_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: HopeColors.offWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final logStore = DebugLogStore();
  final localeProvider = LocaleProvider();
  await localeProvider.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DebugLogStore>.value(value: logStore),
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => SessionProvider(logStore: logStore),
        ),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
      ],
      child: const HopeApp(),
    ),
  );
}

class HopeApp extends StatelessWidget {
  const HopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return MaterialApp(
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      theme: buildHopeTheme(),
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: LocaleProvider.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const DebugOverlay(child: WelcomeScreen()),
    );
  }
}
