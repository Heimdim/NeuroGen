import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class GeneratedImageView extends StatelessWidget {
  const GeneratedImageView({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.unableToLoadGeneratedImage),
          ),
        ),
      ),
    );
  }
}
