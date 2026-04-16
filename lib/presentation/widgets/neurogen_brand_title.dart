import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class NeuroGenBrandTitle extends StatelessWidget {
  const NeuroGenBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    const TextStyle base = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(l10n.brandNeurogen, style: base.copyWith(color: Colors.black87)),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF7C4DFF), Color(0xFF536DFE)],
            ),
          ),
          child: Text(
            l10n.brandAiBadge,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          l10n.brandPro,
          style: base.copyWith(color: const Color(0xFF1976D2)),
        ),
      ],
    );
  }
}
