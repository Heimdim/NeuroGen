import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';

class PromptInput extends StatefulWidget {
  const PromptInput({
    super.key,
    required this.controller,
    required this.enabled,
    this.onChanged,
  });

  static const int maxLength = 2500;

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends State<PromptInput> {
  static const Color _fieldFill = Color(0xFFF2F2F7);
  static const Color _counterColor = Color(0xFF8FA3B0);

  late final VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();
    _controllerListener = () => setState(() {});
    widget.controller.addListener(_controllerListener);
  }

  @override
  void didUpdateWidget(covariant PromptInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_controllerListener);
      widget.controller.addListener(_controllerListener);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  int get _length => widget.controller.text.characters.length;

  void _showPromptTips(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.promptTipsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.promptTipsParagraph1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.promptTipsParagraph2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool hasText = _length > 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: _fieldFill,
        child: Stack(
          children: [
            TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              maxLines: 6,
              minLines: 4,
              textInputAction: TextInputAction.newline,
              inputFormatters: [
                LengthLimitingTextInputFormatter(PromptInput.maxLength),
              ],
              onChanged: widget.onChanged,
              style: textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF424242),
                height: 1.35,
              ),
              decoration: InputDecoration(
                hintText: l10n.promptHint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 44),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 10,
              child: Text(
                '$_length/${PromptInput.maxLength}',
                style: textTheme.labelMedium?.copyWith(
                  color: _counterColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.enabled
                        ? () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _showPromptTips(context);
                          }
                        : null,
                    icon: const Icon(Icons.lightbulb_outline),
                    color: const Color(0xFF757575),
                    tooltip: l10n.promptTipsTooltip,
                    visualDensity: VisualDensity.compact,
                  ),
                  if (hasText)
                    Material(
                      color: Colors.black,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: widget.enabled
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.controller.clear();
                                widget.onChanged?.call('');
                              }
                            : null,
                        child: const SizedBox(
                          width: 28,
                          height: 28,
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
