import 'package:flutter/material.dart';

const devGardenMarkAsset = 'assets/branding/devgarden_mark.png';

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 40, this.semanticLabel, super.key});

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      devGardenMarkAsset,
      width: size,
      height: size,
      filterQuality: FilterQuality.high,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({this.markSize = 72, super.key});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      label: 'devGarden. Where ideas grow!',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandMark(size: markSize),
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('devGarden', style: theme.textTheme.headlineSmall),
              Text(
                'Where ideas grow!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
