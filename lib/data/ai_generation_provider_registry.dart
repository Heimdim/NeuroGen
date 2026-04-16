import 'package:neurogen/domain/ai/ai_generation_provider.dart';
import 'package:neurogen/domain/ai/ai_provider_id.dart';
import 'package:neurogen/domain/entities/job_metadata.dart';

class AiGenerationProviderRegistry {
  AiGenerationProviderRegistry(List<AiGenerationProvider> providers)
    : _byId = <AiProviderId, AiGenerationProvider>{
        for (final AiGenerationProvider p in providers) p.id: p,
      };

  final Map<AiProviderId, AiGenerationProvider> _byId;

  AiGenerationProvider resolve(AiProviderId id) {
    final AiGenerationProvider? provider = _byId[id];
    if (provider == null) {
      throw StateError('Missing AI provider for $id');
    }
    return provider;
  }

  AiGenerationProvider resolveForMetadata(JobMetadata metadata) {
    final AiProviderId id = AiProviderId.values.firstWhere(
      (AiProviderId e) => e.name == metadata.providerId,
      orElse: () => AiProviderId.kling,
    );
    return resolve(id);
  }

  Iterable<AiGenerationProvider> get all => _byId.values;
}
