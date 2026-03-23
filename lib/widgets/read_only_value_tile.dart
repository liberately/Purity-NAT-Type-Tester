import 'package:fluent_ui/fluent_ui.dart';

class ReadOnlyValueTile extends StatelessWidget {
  const ReadOnlyValueTile(
    this.title,
    this.value, {
    required this.icon,
    this.description,
    this.maxLines = 3,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? description;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: SizedBox(
        width: 320,
        child: Text(
          value,
          textAlign: TextAlign.end,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
