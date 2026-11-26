import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  final double size;
  final EdgeInsets padding;

  const ThemeToggleButton({
    super.key,
    this.size = 20,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      padding: padding,
      splashRadius: 20,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: isDark
            ? Icon(
                Icons.light_mode_rounded,
                key: const ValueKey('light_icon'),
                size: size,
                color: const Color(0xFFFFD54F),
              )
            : Icon(
                Icons.dark_mode_outlined,
                key: const ValueKey('dark_icon'),
                size: size,
                color: context.colors.primaryText,
              ),
      ),
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
    );
  }
}

