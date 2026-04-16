class JobMetadata {
  const JobMetadata({
    required this.modelName,
    required this.providerId,
    this.aspectRatio,
    this.imagePath,
    this.externalTaskId,
  });

  final String modelName;
  final String providerId;
  final String? aspectRatio;
  final String? imagePath;
  final String? externalTaskId;

  JobMetadata copyWith({
    String? modelName,
    String? providerId,
    String? aspectRatio,
    String? imagePath,
    String? externalTaskId,
    bool clearExternalTaskId = false,
    bool clearImagePath = false,
  }) {
    return JobMetadata(
      modelName: modelName ?? this.modelName,
      providerId: providerId ?? this.providerId,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      externalTaskId: clearExternalTaskId
          ? null
          : (externalTaskId ?? this.externalTaskId),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'modelName': modelName,
      'providerId': providerId,
      'aspectRatio': aspectRatio,
      'imagePath': imagePath,
      'externalTaskId': externalTaskId,
    };
  }

  static JobMetadata fromJson(Map<String, dynamic> json) {
    return JobMetadata(
      modelName: json['modelName'] as String,
      providerId: json['providerId'] as String,
      aspectRatio: json['aspectRatio'] as String?,
      imagePath: json['imagePath'] as String?,
      externalTaskId: json['externalTaskId'] as String?,
    );
  }
}
