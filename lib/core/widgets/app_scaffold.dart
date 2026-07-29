import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_banner_ad.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final bool centerTitle;
  final EdgeInsetsGeometry? padding;
  final bool showBanner;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.backgroundColor,
    this.floatingActionButton,
    this.appBar,
    this.bottomNavigationBar,
    this.actions,
    this.centerTitle = false,
    this.padding,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar:
          appBar ??
          (title != null
              ? AppBar(
                  title: Text(title!),
                  centerTitle: centerTitle,
                  actions: actions,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                )
              : null),
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!kIsWeb && showBanner) const AppBannerAd(),
          ?bottomNavigationBar,
        ].whereType<Widget>().toList(),
      ),
    );
  }
}
