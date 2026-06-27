import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/screens/detail_screen.dart';
import 'package:flutter_spaghetti/screens/home_screen.dart';
import 'package:flutter_spaghetti/screens/preferences_screen.dart';

part 'app_router.gr.dart';

/// A router class for managing the app's navigation using auto_route.
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: PreferencesRoute.page),
    AutoRoute(page: DetailRoute.page),
  ];
}
