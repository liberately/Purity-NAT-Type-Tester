import 'package:fluent_ui/fluent_ui.dart';
import 'package:nat_tester/widgets/adapter_list_tile.dart';

class NumberFieldTile extends StatelessWidget {
  const NumberFieldTile({
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
  final int placeholder;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AdapterListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailingBuilder: (BuildContext context, bool isCompact) {
        return SizedBox(
          width: isCompact ? double.infinity : 160,
          child: NumberBox(
            mode: SpinButtonPlacementMode.none,
            placeholder: placeholder.toString(),
            value: value,
            onChanged: (num? value) {
              if (value == null) {
                onChanged(placeholder);
              } else if (value is int) {
                onChanged(value);
              } else {
                onChanged(value.round());
              }
            },
          ),
        );
      },
    );
  }
}
