import 'package:flutter/material.dart';

class ShellStatusBar extends StatelessWidget {
  const ShellStatusBar({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Application status: $message',
      child: Container(
        key: const Key('status-bar-region'),
        height: 26,
        color: Theme.of(context).colorScheme.surfaceContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
