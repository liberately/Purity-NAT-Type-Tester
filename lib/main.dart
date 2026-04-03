import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:nat_tester/pages/nat_diagnostics_page.dart';

void main() {
  runApp(const ProviderScope(child: NatTesterApp()));
}

class NatTesterApp extends StatelessWidget {
  const NatTesterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'NAT Tester',
      theme: FluentThemeData(brightness: Brightness.dark),
      home: const NavigationView(content: NatDiagnosticsPage()),
    );
  }
}
