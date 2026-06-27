import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/models/user_preferences_model.dart';
import 'package:flutter_spaghetti/notifiers/preferences_notifier.dart';
import 'package:flutter_spaghetti/states/preferences_state.dart';
import 'package:provider/provider.dart';

/// A screen for managing user preferences such as theme, font size,
/// and language.
@RoutePage()
class PreferencesScreen extends StatelessWidget {
  /// Creates a [PreferencesScreen] widget.
  const PreferencesScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final PreferencesState state = context.watch<PreferencesNotifier>().state;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
      body: switch (state) {
        PreferencesStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        PreferencesStateFailure(:final String message) => Center(
          child: Text(message),
        ),
        PreferencesStateSuccess(:final UserPreferences preferences) =>
          _PreferencesForm(preferences: preferences),
      },
    );
  }
}

class _PreferencesForm extends StatelessWidget {
  const _PreferencesForm({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(final BuildContext context) {
    final PreferencesNotifier notifier = context.read<PreferencesNotifier>();
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _SectionTitle(title: l10n.appearance),
        SwitchListTile(
          title: Text(l10n.darkMode),
          value: preferences.darkMode,
          onChanged: notifier.updateDarkMode,
        ),
        const Divider(),
        _SectionTitle(title: l10n.fontSize),
        Slider(
          value: preferences.fontScale,
          min: 0.8,
          max: 1.4,
          divisions: 6,
          label: preferences.fontScale.toStringAsFixed(1),
          onChanged: notifier.updateFontScale,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('A', style: TextStyle(fontSize: 12)),
            Text('A', style: TextStyle(fontSize: 20)),
          ],
        ),
        const Divider(),
        _SectionTitle(title: l10n.language),
        _LocaleTile(
          label: 'Português',
          value: 'pt',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('pt'),
        ),
        _LocaleTile(
          label: 'English',
          value: 'en',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('en'),
        ),
        _LocaleTile(
          label: 'Español',
          value: 'es',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('es'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => ListTile(
    title: Text(label),
    trailing: selected == value
        ? const Icon(Icons.check, color: Colors.green)
        : null,
    onTap: onTap,
  );
}
