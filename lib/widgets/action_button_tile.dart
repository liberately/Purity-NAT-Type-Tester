import 'package:fluent_ui/fluent_ui.dart';

class ActionButtonTile extends StatelessWidget {
  const ActionButtonTile({
    required this.icon,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: FilledButton(onPressed: onPressed, child: Text(buttonText)),
    );
  }
}
