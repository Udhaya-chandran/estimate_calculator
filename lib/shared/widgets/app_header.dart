import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showLogo;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    double leadingWidth = 56;

    if (showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.primaryText),
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      );
    } else if (showLogo) {
      leadingWidth = 160;
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Image.asset(
          AppConstants.logoAsset,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'SAUDI STEELS',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
      );
    } else {
      leadingWidth = 52;
      leadingWidget = Container(
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.center,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.construction_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      leading: leadingWidget,
      leadingWidth: leadingWidth,
      title: showLogo
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
              ],
            ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
