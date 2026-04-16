import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/ai/ai_provider_id.dart';
import '../../../domain/entities/job_status.dart';
import '../../../l10n/app_localizations.dart';
import '../../jobs/cubit/jobs_cubit.dart';
import '../../jobs/cubit/jobs_state.dart';
import '../../settings/settings_navigation.dart';
import '../../widgets/neurogen_brand_title.dart';
import '../widgets/generate_button.dart';
import '../widgets/prompt_input.dart';

class GenerationScreen extends StatefulWidget {
  const GenerationScreen({super.key});

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  Uint8List? _selectedImagePreviewBytes;
  int _lastAppliedPrefillToken = 0;
  String? _editSourceJobId;
  String? _editBaselinePrompt;
  String? _editBaselineImagePath;

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (!mounted || pickedFile == null) {
      return;
    }
    final Uint8List previewBytes = await pickedFile.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedImagePath = pickedFile.path;
      _selectedImagePreviewBytes = previewBytes;
    });
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImagePath = null;
      _selectedImagePreviewBytes = null;
    });
  }

  void _dismissPromptFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _clearEditSession() {
    _editSourceJobId = null;
    _editBaselinePrompt = null;
    _editBaselineImagePath = null;
  }

  void _onGenerate(BuildContext context) {
    context.read<JobsCubit>().submitFromGenerateEditor(
      prompt: _promptController.text,
      imagePath: _selectedImagePath,
      linkedHistoryJobId: _editSourceJobId,
      baselinePrompt: _editBaselinePrompt,
      baselineImagePath: _editBaselineImagePath,
      providerId: AiProviderId.kling,
    );
    setState(_clearEditSession);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.generationQueuedSnack),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _applyGeneratePrefill(GeneratePrefill prefill) async {
    _promptController.text = prefill.prompt;
    _editSourceJobId = prefill.sourceJobId;
    _editBaselinePrompt = prefill.prompt.trim();
    _editBaselineImagePath = prefill.imagePath;
    _selectedImagePath = prefill.imagePath;
    _selectedImagePreviewBytes = null;
    _lastAppliedPrefillToken = prefill.token;
    if (prefill.imagePath != null && prefill.imagePath!.isNotEmpty) {
      try {
        final Uint8List bytes = await XFile(prefill.imagePath!).readAsBytes();
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedImagePreviewBytes = bytes;
        });
      } on Object catch (_) {
        if (mounted) {
          setState(() {});
        }
      }
    } else if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobsCubit, JobsState>(
      listenWhen: (JobsState previous, JobsState current) {
        final GeneratePrefill? p = current.generatePrefill;
        return p != null && p.token != _lastAppliedPrefillToken;
      },
      listener: (BuildContext context, JobsState state) async {
        final GeneratePrefill? prefill = state.generatePrefill;
        if (prefill == null) {
          return;
        }
        await _applyGeneratePrefill(prefill);
        if (!context.mounted) {
          return;
        }
        context.read<JobsCubit>().clearGeneratePrefillPayload();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          title: const NeuroGenBrandTitle(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: AppLocalizations.of(context)!.settingsTooltip,
              onPressed: () {
                _dismissPromptFocus();
                pushSettingsScreen(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<JobsCubit, JobsState>(
              builder: (BuildContext context, JobsState jobsState) {
                final AppLocalizations l10n = AppLocalizations.of(context)!;
                final int active = jobsState.jobs
                    .where(
                      (j) =>
                          j.status == JobStatus.pending ||
                          j.status == JobStatus.processing,
                    )
                    .length;
                final bool hasPrompt = _promptController.text.trim().isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (active > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  l10n.activeGenerationsBanner(active),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                            PromptInput(
                              controller: _promptController,
                              enabled: true,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            _LavenderToolbarButton(
                              onPressed: () {
                                _dismissPromptFocus();
                                _pickImageFromGallery();
                              },
                              icon: Icons.add_a_photo_outlined,
                              label: _selectedImagePath == null
                                  ? l10n.addPhoto
                                  : l10n.replacePhoto,
                            ),
                            if (_selectedImagePreviewBytes != null) ...<Widget>[
                              const SizedBox(height: 16),
                              Text(
                                l10n.uploadedReference,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              _SelectedImagePreview(
                                bytes: _selectedImagePreviewBytes!,
                                onClear: () {
                                  _dismissPromptFocus();
                                  _clearSelectedImage();
                                },
                                clearEnabled: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GenerateButton(
                      isLoading: false,
                      onPressed: hasPrompt
                          ? () {
                              _dismissPromptFocus();
                              _onGenerate(context);
                            }
                          : null,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LavenderToolbarButton extends StatelessWidget {
  const _LavenderToolbarButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDE7F5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 20, color: const Color(0xFF5E35B1)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF424242),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedImagePreview extends StatelessWidget {
  const _SelectedImagePreview({
    required this.bytes,
    required this.onClear,
    required this.clearEnabled,
  });

  final Uint8List bytes;
  final VoidCallback onClear;
  final bool clearEnabled;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const double maxPreviewHeight = 240;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        double boxWidth = maxWidth;
        double boxHeight = boxWidth * 3 / 4;
        if (boxHeight > maxPreviewHeight) {
          boxHeight = maxPreviewHeight;
          boxWidth = boxHeight * 4 / 3;
        }

        return SizedBox(
          width: maxWidth,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: boxWidth,
              height: boxHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.hardEdge,
                      child: ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: scheme.surface.withValues(alpha: 0.92),
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: clearEnabled ? onClear : null,
                        icon: const Icon(Icons.close),
                        tooltip: l10n.clearSelectedImageTooltip,
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(6),
                          minimumSize: const Size(36, 36),
                          foregroundColor: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
