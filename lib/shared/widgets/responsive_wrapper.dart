import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppConstants.maxContentWidth,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        child: child,
      ),
    );
  }
} 