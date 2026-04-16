import 'dart:convert';

import 'package:hive/hive.dart';

import '../domain/entities/generation_job.dart';
import '../domain/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl(this._box);

  final Box<String> _box;

  static const String _storageKey = 'generation_jobs_v1';

  @override
  Future<List<GenerationJob>> loadJobs() async {
    final String? raw = _box.get(_storageKey);
    if (raw == null || raw.isEmpty) {
      return <GenerationJob>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (dynamic e) => GenerationJob.fromJson(
              Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
            ),
          )
          .toList();
    } on Object {
      return <GenerationJob>[];
    }
  }

  @override
  Future<void> saveJobs(List<GenerationJob> jobs) async {
    final String encoded = jsonEncode(
      jobs.map((GenerationJob j) => j.toJson()).toList(),
    );
    await _box.put(_storageKey, encoded);
  }
}
