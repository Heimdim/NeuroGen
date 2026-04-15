import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di/service_locator.dart';
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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (!mounted || pickedFile == null) {
      return;
    }
    setState(() {
      _selectedImagePath = pickedFile.path;
    });
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
        appBar: AppBar(title: const Text('AI Image Generation')),
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
                        OutlinedButton(
                          onPressed: isLoading ? null : _pickImageFromGallery,
                          child: Text(
                            _selectedImagePath == null
                                ? 'Select Image from Gallery'
                                : 'Image Selected',
                          ),
                        ),
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
