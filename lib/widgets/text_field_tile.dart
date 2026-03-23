import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: SizedBox(
        width: 160,
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
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
