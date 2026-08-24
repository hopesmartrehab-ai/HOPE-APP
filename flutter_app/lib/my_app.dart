// lib/my_app.dart

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hope_app/core/local_storage/local_storage.dart';
import 'package:hope_app/core/theme/logic/theme_cubit.dart';

import 'core/theme/styles/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // The root of your application

  void _syncLocaleLanguage(Locale locale) {
    final localeValue = locale.toString();
    if (LocalStorage.getLocaleLanguage() != locale.languageCode) {
      unawaited(LocalStorage.setLocaleLanguage(localeValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncLocaleLanguage(context.locale);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Hope App',
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}
