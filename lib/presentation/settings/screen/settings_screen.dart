import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/locale/app_locale_controller.dart';
import '../../../domain/ai/ai_provider_id.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/neurogen_brand_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static String _providerLabel(AiProviderId id) {
    switch (id) {
      case AiProviderId.kling:
        return 'Kling';
      case AiProviderId.openAi:
        return 'OpenAI';
      case AiProviderId.deepSeek:
        return 'DeepSeek';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              l10n.settingsLanguageSection,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsLanguageDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: getIt<AppLocaleController>(),
              builder: (BuildContext context, Widget? child) {
                final AppLocaleController locale = getIt<AppLocaleController>();
                return InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: locale.currentTag,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'system',
                          child: Text(l10n.settingsLanguageSystem),
                        ),
                        DropdownMenuItem<String>(
                          value: 'en',
                          child: Text(l10n.settingsLanguageEnglish),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ru',
                          child: Text(l10n.settingsLanguageRussian),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        unawaited(locale.applyTag(value));
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              l10n.settingsAiProviderMock,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsAiProviderMockDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...AiProviderId.values.map((AiProviderId id) {
              if (id == AiProviderId.kling) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_providerLabel(id)),
                  subtitle: Text(l10n.providerSubtitleActiveKling),
                  trailing: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
              return ListTile(
                contentPadding: EdgeInsets.zero,
                enabled: false,
                title: Text(_providerLabel(id)),
                subtitle: Text(l10n.providerSubtitleMock),
                trailing: Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.outline,
                ),
              );
            }),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              l10n.aboutSection,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Row(children: <Widget>[NeuroGenBrandTitle()]),
          ],
        ),
      ),
    );
  }
}
