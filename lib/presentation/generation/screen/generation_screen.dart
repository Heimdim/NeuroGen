import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di/service_locator.dart';
import '../../history/screen/generation_history_screen.dart';
import '../cubit/generation_cubit.dart';
import '../cubit/generation_state.dart';
import '../widgets/generate_button.dart';
import '../widgets/generated_image_view.dart';
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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (!mounted || pickedFile == null) {
      return;
    }
    final previewBytes = await pickedFile.readAsBytes();
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

  void _openHistory() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => const GenerationHistoryScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GenerationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          title: const _NeuroGenBrandTitle(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<GenerationCubit, GenerationState>(
              listener: (context, state) {
                if (state is GenerationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is GenerationLoading;
                final hasPrompt = _promptController.text.trim().isNotEmpty;
                final canGenerate = hasPrompt && !isLoading;

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PromptInput(
                          controller: _promptController,
                          enabled: !isLoading,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _LavenderToolbarButton(
                                onPressed: isLoading
                                    ? null
                                    : _pickImageFromGallery,
                                icon: Icons.add_a_photo_outlined,
                                label: _selectedImagePath == null
                                    ? 'Add a photo'
                                    : 'Replace photo',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _LavenderToolbarButton(
                                onPressed: isLoading ? null : _openHistory,
                                icon: Icons.history,
                                label: 'History',
                              ),
                            ),
                          ],
                        ),
                        if (_selectedImagePreviewBytes != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _SelectedImagePreview(
                                bytes: _selectedImagePreviewBytes!,
                                onClear: _clearSelectedImage,
                                clearEnabled: !isLoading,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        GenerateButton(
                          isLoading: isLoading,
                          onPressed: canGenerate
                              ? () {
                                  context.read<GenerationCubit>().generate(
                                    prompt: _promptController.text,
                                    imagePath: _selectedImagePath,
                                  );
                                }
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (state is GenerationError) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<GenerationCubit>().generate(
                                      prompt: _promptController.text,
                                      imagePath: _selectedImagePath,
                                    );
                                  },
                            child: const Text('Retry'),
                          ),
                        ],
                        if (state is GenerationSuccess)
                          Expanded(
                            child: GeneratedImageView(
                              imageUrl: state.image.imageUrl,
                            ),
                          ),
                      ],
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: AbsorbPointer(
                          absorbing: true,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.65),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
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

class _NeuroGenBrandTitle extends StatelessWidget {
  const _NeuroGenBrandTitle();

  @override
  Widget build(BuildContext context) {
    const TextStyle base = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('NeuroGen', style: base.copyWith(color: Colors.black87)),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
            ),
          ),
          child: const Text(
            'AI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        Text(' Pro', style: base.copyWith(color: const Color(0xFF1976D2))),
      ],
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
            children: [
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

  static const double _thumbSize = 40;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: Image.memory(
              bytes,
              width: _thumbSize,
              height: _thumbSize,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ),
        IconButton(
          onPressed: clearEnabled ? onClear : null,
          icon: const Icon(Icons.close),
          tooltip: 'Clear selected image',
          visualDensity: VisualDensity.compact,
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 32),
            foregroundColor: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
