import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SelectFieldTile<T> extends HookWidget {
  const SelectFieldTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final List<T> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: SizedBox(
        width: 160,
        child: ComboBox<T>(
          value: value,
          onChanged: (T? selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
          items: options.map((T entry) {
            return ComboBoxItem<T>(value: entry, child: Text('$entry'));
          }).toList(),
        ),
      ),
    );
  }
}
