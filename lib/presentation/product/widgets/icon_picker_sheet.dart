import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/icon_catalog.dart';

class IconPickResult {
  const IconPickResult({required this.iconKey, required this.colorHex});

  final String iconKey;
  final String colorHex;
}

Future<IconPickResult?> showIconPickerSheet({
  required BuildContext context,
  required String iconKey,
  required String colorHex,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  await Future<void>.delayed(const Duration(milliseconds: 180));
  if (!context.mounted) {
    return null;
  }

  return showModalBottomSheet<IconPickResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return _IconPickerSheet(iconKey: iconKey, colorHex: colorHex);
    },
  );
}

class _IconPickerSheet extends StatefulWidget {
  const _IconPickerSheet({required this.iconKey, required this.colorHex});

  final String iconKey;
  final String colorHex;

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  late String _iconKey = widget.iconKey;
  late String _colorHex = widget.colorHex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedColor = parseIconColor(_colorHex);
    final media = MediaQuery.of(context);
    final maxHeight =
        (media.size.height - media.padding.bottom) * 0.72;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('아이콘 · 색', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      IconPickResult(iconKey: _iconKey, colorHex: _colorHex),
                    );
                  },
                  child: const Text('완료'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Icon(
                  iconForKey(_iconKey),
                  size: 36,
                  color: contrastOnColor(selectedColor),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                iconLabelForKey(_iconKey),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in iconColorOptions)
                  Semantics(
                    button: true,
                    selected: color.hex == _colorHex,
                    label: color.label,
                    child: GestureDetector(
                      onTap: () => setState(() => _colorHex = color.hex),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: parseIconColor(color.hex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.hex == _colorHex
                                ? scheme.onSurface
                                : scheme.outlineVariant,
                            width: color.hex == _colorHex ? 2.5 : 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 8,
                ),
                itemCount: iconOptions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  final option = iconOptions[index];
                  final selected = option.key == _iconKey;
                  return Semantics(
                    button: true,
                    selected: selected,
                    label: option.label,
                    child: Material(
                      color: selected
                          ? selectedColor.withValues(alpha: 0.35)
                          : scheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected ? selectedColor : scheme.outlineVariant,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => setState(() => _iconKey = option.key),
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(
                          option.icon,
                          color: selected ? selectedColor : scheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
