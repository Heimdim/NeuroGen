import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/ai/ai_provider_id.dart';
import '../../../domain/entities/generation_job.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/job_media_result.dart';
import '../../../domain/entities/job_status.dart';
import '../../jobs/cubit/jobs_cubit.dart';
import '../../jobs/cubit/jobs_state.dart';
import '../../settings/settings_navigation.dart';
import '../../widgets/neurogen_brand_title.dart';
import '../widgets/reference_image_thumb.dart';

class GenerationHistoryScreen extends StatelessWidget {
  const GenerationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const NeuroGenBrandTitle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
            onPressed: () => pushSettingsScreen(context),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<JobsCubit, JobsState>(
          builder: (BuildContext context, JobsState state) {
            if (state.jobs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.historyEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }
            final List<_PromptGroup> groups = _groupJobs(state.jobs);
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index) {
                final _PromptGroup group = groups[index];
                return _PromptSection(group: group);
              },
            );
          },
        ),
      ),
    );
  }
}

class _PromptGroup {
  _PromptGroup({required this.prompt, required this.jobs});

  final String prompt;
  final List<GenerationJob> jobs;
}

List<_PromptGroup> _groupJobs(List<GenerationJob> jobs) {
  final Map<String, List<GenerationJob>> map = <String, List<GenerationJob>>{};
  for (final GenerationJob j in jobs) {
    map.putIfAbsent(j.prompt, () => <GenerationJob>[]).add(j);
  }
  for (final List<GenerationJob> list in map.values) {
    list.sort(
      (GenerationJob a, GenerationJob b) => b.createdAt.compareTo(a.createdAt),
    );
  }
  final List<String> keys = map.keys.toList()
    ..sort((String a, String b) {
      final DateTime ta = map[a]!.first.createdAt;
      final DateTime tb = map[b]!.first.createdAt;
      return tb.compareTo(ta);
    });
  return keys
      .map((String k) => _PromptGroup(prompt: k, jobs: map[k]!))
      .toList();
}

class _PromptSection extends StatefulWidget {
  const _PromptSection({required this.group});

  final _PromptGroup group;

  @override
  State<_PromptSection> createState() => _PromptSectionState();
}

class _PromptSectionState extends State<_PromptSection> {
  bool _expanded = false;

  Future<void> _confirmDeleteHistorySection(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.historyDeleteSectionTitle),
          content: Text(
            l10n.historyDeleteSectionMessage(widget.group.jobs.length),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.dialogCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    context.read<JobsCubit>().deleteAllJobsWithPrompt(widget.group.prompt);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final JobsCubit cubit = context.read<JobsCubit>();
    final GenerationJob referenceJob = widget.group.jobs.first;
    final String? referenceImagePath = referenceJob.metadata.imagePath;
    final bool canPromptRetry =
        referenceJob.status != JobStatus.pending &&
        referenceJob.status != JobStatus.processing &&
        !(referenceJob.status == JobStatus.failed && !referenceJob.canRetry);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Tooltip(
              message: _expanded
                  ? l10n.hideResultsTooltip
                  : l10n.showResultsTooltip,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    _expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                  const SizedBox(width: 8),
                                  _HistorySectionThumb(
                                    imagePath: referenceImagePath,
                                    scheme: scheme,
                                    l10n: l10n,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.group.prompt,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.generationRunsCount(
                                  widget.group.jobs.length,
                                ),
                                style: textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.latestStatusAt(
                                  _statusShortLabel(referenceJob.status, l10n),
                                  _formatLocalTime(referenceJob.createdAt),
                                ),
                                style: textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _StatusChip(status: referenceJob.status),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.editInGenerateTooltip,
                                    onPressed: () =>
                                        cubit.beginGenerateEditFromHistory(
                                          referenceJob,
                                        ),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.retry,
                                    onPressed: canPromptRetry
                                        ? () => cubit.rerunHistoryJob(
                                            referenceJob,
                                          )
                                        : null,
                                    icon: const Icon(
                                      Icons.replay_circle_filled_outlined,
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.historyDeleteSectionTooltip,
                                    onPressed: () => unawaited(
                                      _confirmDeleteHistorySection(context),
                                    ),
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: scheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.group.jobs
                      .map(
                        (GenerationJob job) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _JobCard(job: job),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HistorySectionThumb extends StatelessWidget {
  const _HistorySectionThumb({
    required this.imagePath,
    required this.scheme,
    required this.l10n,
  });

  final String? imagePath;
  final ColorScheme scheme;
  final AppLocalizations l10n;

  static const double _kSize = 44;

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;
    if (path != null && path.isNotEmpty) {
      return Tooltip(
        message: l10n.referenceImageTooltip,
        child: buildReferenceImageThumb(path, size: _kSize),
      );
    }
    return Tooltip(
      message: l10n.historyNoReferenceThumbnailTooltip,
      child: SizedBox(
        width: _kSize,
        height: _kSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Icon(
            Icons.hide_image_outlined,
            size: 22,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});

  final GenerationJob job;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final JobsCubit cubit = context.read<JobsCubit>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: ExpansionTile(
        key: ValueKey<String>(job.id),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        title: Row(
          children: <Widget>[
            _StatusChip(status: job.status),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _formatLocalTime(job.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
        subtitle: job.lastError != null && job.status == JobStatus.failed
            ? Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  job.lastError!,
                  style: TextStyle(color: scheme.error, fontSize: 13),
                ),
              )
            : Text(
                '${job.metadata.modelName} · ${_providerLabel(job)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
        children: <Widget>[
          if (job.status == JobStatus.failed && job.canRetry)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => cubit.retryJob(job.id),
                icon: const Icon(Icons.replay_circle_filled_outlined),
                label: Text(
                  l10n.retryWithRemaining(
                    GenerationJob.maxRetries - job.retryCount,
                  ),
                ),
              ),
            ),
          if (job.results.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: job.results.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 10),
                itemBuilder: (BuildContext context, int index) {
                  final JobMediaResult r = job.results[index];
                  return _ResultTile(job: job, result: r);
                },
              ),
            )
          else if (job.status == JobStatus.completed)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(l10n.noResultImagesOnJob),
            ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.job, required this.result});

  final GenerationJob job;
  final JobMediaResult result;

  static void _mockShare(BuildContext context, JobMediaResult result) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.shareMockMessage(result.imageUrl), maxLines: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final JobsCubit cubit = context.read<JobsCubit>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              border: result.hasGallerySave
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 180,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: result.imageUrl,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (BuildContext context, String url, Object error) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
          ),
          if (result.hasGallerySave)
            Positioned(
              top: 6,
              left: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.bookmark, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        l10n.saved,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: PopupMenuButton<String>(
              icon: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.more_horiz, color: Colors.white, size: 20),
                ),
              ),
              onSelected: (String value) async {
                if (value == 'save') {
                  final bool wasGallerySaved = result.hasGallerySave;
                  final String? err = await cubit.toggleResultLocalSave(
                    jobId: job.id,
                    resultId: result.id,
                  );
                  if (!context.mounted) {
                    return;
                  }
                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  if (err != null) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(err),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          wasGallerySaved
                              ? l10n.snackMarkedNotSaved
                              : l10n.snackImageAddedToGallery,
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else if (value == 'share') {
                  _mockShare(context, result);
                } else if (value == 'delete') {
                  cubit.deleteResult(jobId: job.id, resultId: result.id);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'save',
                  child: Text(
                    result.hasGallerySave
                        ? l10n.unmarkSaved
                        : l10n.saveToGallery,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'share',
                  child: Text(l10n.shareEllipsis),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(l10n.delete),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final JobStatus status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    late final Color bg;
    late final Color fg;
    late final String label;
    switch (status) {
      case JobStatus.pending:
        label = l10n.statusPending;
        bg = scheme.secondaryContainer;
        fg = scheme.onSecondaryContainer;
      case JobStatus.processing:
        label = l10n.statusProcessing;
        bg = scheme.primaryContainer;
        fg = scheme.onPrimaryContainer;
      case JobStatus.completed:
        label = l10n.statusDone;
        bg = scheme.tertiaryContainer;
        fg = scheme.onTertiaryContainer;
      case JobStatus.failed:
        label = l10n.statusFailed;
        bg = scheme.errorContainer;
        fg = scheme.onErrorContainer;
    }
    return Chip(
      label: Text(label, style: TextStyle(color: fg, fontSize: 12)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: bg,
    );
  }
}

String _pad2(int value) => value.toString().padLeft(2, '0');

String _statusShortLabel(JobStatus status, AppLocalizations l10n) {
  switch (status) {
    case JobStatus.pending:
      return l10n.statusPending;
    case JobStatus.processing:
      return l10n.statusProcessing;
    case JobStatus.completed:
      return l10n.statusDone;
    case JobStatus.failed:
      return l10n.statusFailed;
  }
}

String _formatLocalTime(DateTime utc) {
  final DateTime local = utc.toLocal();
  return '${local.year}-${_pad2(local.month)}-${_pad2(local.day)} '
      '${_pad2(local.hour)}:${_pad2(local.minute)}';
}

String _providerLabel(GenerationJob job) {
  final AiProviderId id = AiProviderId.values.firstWhere(
    (AiProviderId e) => e.name == job.metadata.providerId,
    orElse: () => AiProviderId.kling,
  );
  switch (id) {
    case AiProviderId.kling:
      return 'Kling';
    case AiProviderId.openAi:
      return 'OpenAI';
    case AiProviderId.deepSeek:
      return 'DeepSeek';
  }
}
