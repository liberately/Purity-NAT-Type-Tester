import 'package:fluent_ui/fluent_ui.dart';
import 'package:nat_tester/widgets/adapter_list_tile.dart';

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
    return AdapterListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailingBuilder: (BuildContext context, bool isCompact) {
        return SizedBox(
          width: isCompact ? double.infinity : 320,
          child: Text(
            value,
            textAlign: isCompact ? TextAlign.start : TextAlign.end,
            maxLines: maxLines,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
