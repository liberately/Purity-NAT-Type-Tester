import 'package:fluent_ui/fluent_ui.dart';

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
    return ListTile(
      leading: Icon(icon),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          if (description != null)
            Text(
              description!,
              style: FluentTheme.of(context).typography.caption,
            ),
        ],
      ),
      trailing: ToggleSwitch(checked: value, onChanged: onChanged),
    );
  }
}
