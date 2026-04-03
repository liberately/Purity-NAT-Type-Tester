import 'package:fluent_ui/fluent_ui.dart';
import 'package:nat_tester/widgets/adapter_list_tile.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AdapterListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: ToggleSwitch(checked: value, onChanged: onChanged),
    );
  }
}
