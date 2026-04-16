import 'dart:io';

import 'package:flutter/material.dart';

Widget buildReferenceImageThumb(String? path, {double size = 48}) {
  if (path == null || path.isEmpty) {
    return const SizedBox.shrink();
  }
  final File file = File(path);
  if (!file.existsSync()) {
    return _Placeholder(size: size);
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: size,
      height: size,
      child: Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return _Placeholder(size: size);
            },
      ),
    ),
  );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.broken_image_outlined,
          size: size * 0.45,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
