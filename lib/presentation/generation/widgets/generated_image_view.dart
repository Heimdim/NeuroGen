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
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Unable to load generated image.'),
            ),
          );
        },
      ),
    );
  }
}
