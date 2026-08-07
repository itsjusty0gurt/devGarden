import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectExplorer extends StatelessWidget {
  const ProjectExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
            child: Text(
              'PROJECT EXPLORER',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Layout preview — no saved project data',
              style: TextStyle(fontSize: 11),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: ExpansionTile(
                key: const Key('demo-workspace-node'),
                initiallyExpanded: true,
                leading: const Icon(Icons.workspaces_outline, size: 18),
                title: const Text('Sample Workspace'),
                children: [
                  ExpansionTile(
                    initiallyExpanded: true,
                    leading: const Icon(Icons.folder_outlined, size: 18),
                    title: const Text('Sample Project'),
                    onExpansionChanged: (_) {},
                    children: [
                      ExpansionTile(
                        initiallyExpanded: true,
                        leading: const Icon(Icons.apps_outlined, size: 18),
                        title: const Text('Sample App'),
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.lightbulb_outline,
                              size: 18,
                            ),
                            title: const Text('Ideas (placeholder)'),
                            onTap: () => context.go('/app'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
