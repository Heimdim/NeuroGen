import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GeneratedImageView extends StatelessWidget {
  const GeneratedImageView({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
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
        errorWidget: (context, url, error) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Unable to load generated image.'),
          ),
        ),
      ),
    );
  }
}
