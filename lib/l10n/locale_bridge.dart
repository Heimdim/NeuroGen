import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../core/locale/app_locale_controller.dart';
import 'app_localizations.dart';

AppLocalizations resolveAppLocalizationsFromPlatform() {
  final GetIt getIt = GetIt.instance;
  if (getIt.isRegistered<AppLocaleController>()) {
    final Locale? over = getIt<AppLocaleController>().localeOverride;
    if (over != null) {
      return lookupAppLocalizations(over);
    }
  }
  final String code =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  if (code == 'ru') {
    return lookupAppLocalizations(const Locale('ru'));
  }
  return lookupAppLocalizations(const Locale('en'));
}
