import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class NeuroGenBrandTitle extends StatelessWidget {
  const NeuroGenBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppThemeColors appColors = context.appColors;
    const TextStyle base = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          l10n.brandNeurogen,
          style: base.copyWith(color: appColors.brandTitle),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: <Color>[
                appColors.brandBadgeStart,
                appColors.brandBadgeEnd,
              ],
            ),
          ),
          child: Text(
            l10n.brandAiBadge,
            style: TextStyle(
              color: appColors.brandBadgeForeground,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        Text(l10n.brandPro, style: base.copyWith(color: appColors.brandAccent)),
      ],
    );
  }
}
