import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal_gun/lib.dart';

class AppSvgWidget extends StatelessWidget {
  const AppSvgWidget(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.semanticsLabel,
  });

  final AppSvgAsset asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Alignment alignment;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset.path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
