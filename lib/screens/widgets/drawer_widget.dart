import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/routes/app_router.dart';

/// A widget that represents the app's navigation drawer.
class AppDrawer extends StatelessWidget {
  /// Creates an [AppDrawer] widget.
  const AppDrawer({super.key});

  @override
  Widget build(final BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.currency_bitcoin, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                'Crypto Quotes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context).settings),
          onTap: () => context.router.push(const PreferencesRoute()),
        ),
      ],
    ),
  );
}
