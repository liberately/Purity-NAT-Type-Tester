import 'package:fluent_ui/fluent_ui.dart';

class ExpanderSection extends StatelessWidget {
  const ExpanderSection({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Expander(
      header: Text(title),
      initiallyExpanded: initiallyExpanded,
      contentPadding: EdgeInsets.zero,
      content: Column(children: _withDividers(children)),
    );
  }
}

List<Widget> _withDividers(List<Widget> children) {
  final List<Widget> result = <Widget>[];
  for (int index = 0; index < children.length; index++) {
    if (index > 0) {
      result.add(const Divider());
    }
    result.add(children[index]);
  }
  return result;
}
