import 'package:flutter/material.dart';

import 'reference_image_thumb_io.dart'
    if (dart.library.html) 'reference_image_thumb_web.dart'
    as thumb_impl;

Widget buildReferenceImageThumb(String? path, {double size = 48}) {
  return thumb_impl.buildReferenceImageThumb(path, size: size);
}
