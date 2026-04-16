class JobMediaResult {
  const JobMediaResult({
    required this.id,
    required this.imageUrl,
    this.savedToGallery = false,
  });

  final String id;
  final String imageUrl;

  final bool savedToGallery;

  bool get hasGallerySave => savedToGallery;

  JobMediaResult copyWith({
    String? id,
    String? imageUrl,
    bool? savedToGallery,
  }) {
    return JobMediaResult(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      savedToGallery: savedToGallery ?? this.savedToGallery,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'savedToGallery': savedToGallery,
    };
  }

  static JobMediaResult fromJson(Map<String, dynamic> json) {
    final String? legacyPath = json['savedLocalPath'] as String?;
    final bool fromLegacyDisk = legacyPath != null && legacyPath.isNotEmpty;
    return JobMediaResult(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      savedToGallery: json['savedToGallery'] as bool? ?? fromLegacyDisk,
    );
  }
}
