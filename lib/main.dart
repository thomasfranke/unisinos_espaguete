import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/models/user_preferences_model.dart';
import 'package:flutter_spaghetti/notifiers/crypto_quote_notifier.dart';
import 'package:flutter_spaghetti/notifiers/favorites_notifier.dart';
import 'package:flutter_spaghetti/notifiers/preferences_notifier.dart';
import 'package:flutter_spaghetti/routes/app_router.dart';
import 'package:flutter_spaghetti/states/preferences_state.dart';
import 'package:flutter_spaghetti/theme/app_theme.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<CryptoQuoteNotifier>(
          create: (_) => CryptoQuoteNotifier(),
        ),
        ChangeNotifierProvider<FavoritesNotifier>(
          create: (_) => FavoritesNotifier(),
        ),
        ChangeNotifierProvider<PreferencesNotifier>(
          create: (_) => PreferencesNotifier(),
        ),
        ChangeNotifierProvider<AppRouter>(create: (_) => AppRouter()),
      ],
      child: const MyApp(),
    ),
  );
}

/// The root widget of the app that sets up routing.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final AppRouter appRouter = context.read<AppRouter>();
    final PreferencesState preferencesState = context
        .watch<PreferencesNotifier>()
        .state;

    final UserPreferences preferences = switch (preferencesState) {
      PreferencesStateSuccess(:final UserPreferences preferences) =>
        preferences,
      _ => UserPreferences(),
    };

    return MaterialApp.router(
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(preferences.locale),
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
      builder: (final BuildContext context, final Widget? child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(preferences.fontScale)),
        child: child!,
      ),
    );
  }
}
