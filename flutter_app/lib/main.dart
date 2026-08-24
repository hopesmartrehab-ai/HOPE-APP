// lib/main.dart

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/my_app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/app_localization.dart';
import 'core/di/service_locator.dart';
import 'core/local_storage/local_storage.dart';
import 'core/resources/app_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  setupServiceLocator();
  await LocalStorage.init();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar', 'en');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppLocalizations.englishLocale,
        AppLocalizations.arabicLocale,
      ],
      path: AppLocalizations.translationsPath,
      fallbackLocale: AppLocalizations.englishLocale,
      startLocale: AppLocalizations.englishLocale,
      saveLocale: true,
      child: DevicePreview(
        enabled: kDebugMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}
