import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nat_tester/widgets/adapter_list_tile.dart';

class TextFieldTile extends HookWidget {
  const TextFieldTile({
    required this.icon,
    required this.title,
    required this.placeholder,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String placeholder;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value);
    useEffect(() {
      final String nextValue = value ?? '';
      if (controller.text != nextValue) {
        controller.value = controller.value.copyWith(
          text: nextValue,
          selection: TextSelection.collapsed(offset: nextValue.length),
          composing: TextRange.empty,
        );
      }
      return null;
    }, <Object?>[value]);

    return AdapterListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailingBuilder: (BuildContext context, bool isCompact) {
        return SizedBox(
          width: isCompact ? double.infinity : 160,
          child: TextBox(
            controller: controller,
            placeholder: placeholder,
            onChanged: (String value) {
              if (value.isEmpty) {
                onChanged(placeholder);
              } else {
                onChanged(value);
              }
            },
            textAlign: isCompact ? TextAlign.start : TextAlign.center,
          ),
        );
      },
    );
  }
}
