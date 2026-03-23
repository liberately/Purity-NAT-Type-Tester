import 'package:fluent_ui/fluent_ui.dart';
import 'package:nat_tester/pages/nat_diagnostics_page.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationView(content: NatDiagnosticsPage());
  }
}
