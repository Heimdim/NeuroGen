import 'job_media_result.dart';
import 'job_metadata.dart';
import 'job_status.dart';

class GenerationJob {
  const GenerationJob({
    required this.id,
    required this.prompt,
    required this.status,
    required this.createdAt,
    required this.results,
    required this.metadata,
    this.retryCount = 0,
    this.lastError,
  });

  final String id;
  final String prompt;
  final JobStatus status;
  final DateTime createdAt;
  final List<JobMediaResult> results;
  final JobMetadata metadata;
  final int retryCount;
  final String? lastError;

  static const int maxRetries = 3;

  bool get canRetry => status == JobStatus.failed && retryCount < maxRetries;

  GenerationJob copyWith({
    String? id,
    String? prompt,
    JobStatus? status,
    DateTime? createdAt,
    List<JobMediaResult>? results,
    JobMetadata? metadata,
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) {
    return GenerationJob(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      results: results ?? this.results,
      metadata: metadata ?? this.metadata,
      retryCount: retryCount ?? this.retryCount,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'prompt': prompt,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'results': results.map((JobMediaResult e) => e.toJson()).toList(),
      'metadata': metadata.toJson(),
      'retryCount': retryCount,
      'lastError': lastError,
    };
  }

  static GenerationJob fromJson(Map<String, dynamic> json) {
    final statusName = json['status'] as String;
    final JobStatus status = JobStatus.values.firstWhere(
      (JobStatus e) => e.name == statusName,
      orElse: () => JobStatus.pending,
    );
    final resultsJson = json['results'] as List<dynamic>? ?? <dynamic>[];
    return GenerationJob(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      status: status,
      createdAt: DateTime.parse(json['createdAt'] as String),
      results: resultsJson
          .map(
            (dynamic e) =>
                JobMediaResult.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      metadata: JobMetadata.fromJson(
        Map<String, dynamic>.from(json['metadata'] as Map),
      ),
      retryCount: json['retryCount'] as int? ?? 0,
      lastError: json['lastError'] as String?,
    );
  }
}
