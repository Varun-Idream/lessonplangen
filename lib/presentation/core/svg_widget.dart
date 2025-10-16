import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

class AssetSvg extends StatelessWidget {
  final String assetPath;
  final double? height;
  final double? width;
  final double scale;
  final Widget Function(BuildContext)? onLoading;
  final Widget Function(BuildContext)? onError;
  final Color? currentColor;

  const AssetSvg(
    this.assetPath, {
    super.key,
    this.height,
    this.width,
    this.scale = 1,
    this.onLoading,
    this.onError,
    this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ScalableImageWidget.fromSISource(
      currentColor: currentColor,
      scale: scale,
      si: ScalableImageSource.fromSvg(
        DefaultAssetBundle.of(context),
        assetPath,
      ),
      onLoading: onLoading,
      onError: onError,
    );
  }
}
