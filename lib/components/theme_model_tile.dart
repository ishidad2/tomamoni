import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_mode_provider.dart';

/// ドロワーメニュー（theme切り替え）
/// タップされたたときに ThemeModeNotifier#toggle() の呼び出しをしている
class ThemeModeTile extends ConsumerWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggle = ref.read(themeModeProvider.notifier).toggle;
    switch (ref.watch(themeModeProvider)) {
      case ThemeMode.light:
        return ListTile(
          leading: const Icon(Icons.light_mode_rounded),
          title: const Text('Light'),
          onTap: toggle,
        );
      case ThemeMode.dark:
        return ListTile(
          leading: const Icon(Icons.dark_mode_rounded),
          title: const Text('Dark'),
          onTap: toggle,
        );
      case ThemeMode.system:
        return ListTile(
          leading: const Icon(Icons.smartphone_rounded),
          title: const Text('System'),
          onTap: toggle,
        );
    }
  }
}
