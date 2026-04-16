import 'entities/generation_job.dart';

abstract class JobRepository {
  Future<List<GenerationJob>> loadJobs();

  Future<void> saveJobs(List<GenerationJob> jobs);
}
