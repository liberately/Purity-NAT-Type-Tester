import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nat_tester/widgets/adapter_list_tile.dart';

class EditableComboActionTile extends HookWidget {
  const EditableComboActionTile({
    required this.icon,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.buttonText,
    required this.onPressed,
    this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value);
    useEffect(() {
      if (controller.text != value) {
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
          composing: TextRange.empty,
        );
      }
      return null;
    }, <Object>[value]);

    return AdapterListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailingBuilder: (BuildContext context, bool isCompact) {
        final Widget comboBox = EditableComboBox<String>(
          value: value,
          textController: controller,
          onTextChanged: onChanged,
          onChanged: (String? selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
          items: options.map((String entry) {
            return ComboBoxItem<String>(
              value: entry,
              child: Text(entry, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onFieldSubmitted: (String text) {
            onChanged(text);
            return text;
          },
        );

        if (isCompact) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(width: double.infinity, child: comboBox),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),
            ],
          );
        }

        return SizedBox(
          width: 360,
          child: Row(
            children: <Widget>[
              Expanded(child: comboBox),
              const SizedBox(width: 8),
              FilledButton(onPressed: onPressed, child: Text(buttonText)),
            ],
          ),
        );
      },
    );
  }
}
